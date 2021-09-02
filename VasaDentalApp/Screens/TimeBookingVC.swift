//
//  TimeBookingVC.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/14/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import FSCalendar

class TimeBookingVC: ViewAndConstraintsVC {
    
    typealias DataSource    = UICollectionViewDiffableDataSource<Section, TimeData>
    typealias Snapshot      = NSDiffableDataSourceSnapshot<Section, TimeData>
    
    private var dataSource      : DataSource!
    private var snapshot        = Snapshot()
    
    private var collectionView  : UICollectionView!
    
    private var dateSelected    = false
    
    private var middleViewLabel = UILabel()
    private let tableView       = UITableView()
    private var dateArray       : [DateAndTimeModel] = []
    private var selectedDoctor  : DoctorModel!
    private var selectedService = ""
    private var selectedDate    = Date()
    
    private var lastItem        = 0
    private var lastSection     = 0
    private var selectedTime    = ""
    private var chosenDate      = ""
    
    private var theBooking      : BookingModel!
    private var vaporBooking    : VaporBooking!
    
    private var customer        : [CustomerModel] = []
    
    private var calendar        = FSCalendar()
    
    init(doctor: DoctorModel, service: String) {
        super.init(nibName: nil, bundle: nil)
        selectedService = service
        selectedDoctor = doctor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDates()
        configure()
        configureTableView()
        loadCustomer()
        
    }
    
    
    private func loadDates() {
        let date1 = DateAndTimeModel(month: "Вересня", date: "25", time: [
            TimeData(time: "09:00"),
            TimeData(time: "10:00"),
            TimeData(time: "13:00"),
            TimeData(time: "15:00"),
            TimeData(time: "17:00")
        ])
        let date2 = DateAndTimeModel(month: "Вересня", date: "28", time: [
            TimeData(time: "10:00"),
            TimeData(time: "12:00"),
            TimeData(time: "14:00"),
            TimeData(time: "16:00")
        ])
        let date3 = DateAndTimeModel(month: "Вересня", date: "30", time: [
            TimeData(time: "09:00"),
            TimeData(time: "15:00"),
            TimeData(time: "18:00")
        ])
        dateArray.append(date1)
        dateArray.append(date2)
        dateArray.append(date3)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    private func loadCustomer() {
        PersistenceManager.retrieveCustomers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loadedCustomer):
                self.customer = loadedCustomer
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @objc private func nextButtonTapped() {
        theBooking = BookingModel(id: UUID(), service: selectedService, date: chosenDate, rawDate: selectedDate, time: selectedTime, doctor: selectedDoctor)
        vaporBooking = VaporBooking(id: theBooking.id, service: selectedService, doctorName: selectedDoctor.doctorName, date: selectedDate, time: selectedTime, address: selectedDoctor.address, phoneNumber: selectedDoctor.phone, email: selectedDoctor.doctorEmail)
        
        checkIfThereIsCustomer()
    }
    
    
    private func checkIfThereIsCustomer() {
         guard customer.count != 0 else {
            createCustomerName()
            return
        }
        askIfTheCustomerIsSame()
    }
    
    
    private func askIfTheCustomerIsSame() {
        let customerName = self.customer.first?.name ?? "Таємного клієнта"
        let alert = UIAlertController(title: "Бронювання для \(customerName)", message: nil, preferredStyle: .alert)
        let yesAction =  UIAlertAction(title: "Так", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let bookingVC = ConfirmBookingVC(booking: self.theBooking, vaporBooking: self.vaporBooking)
            self.navigationController?.pushViewController(bookingVC, animated: true)
        }
        
        let noAction = UIAlertAction(title: "Ні", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.customer.removeAll()
            self.createCustomerName()
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    private func createCustomerName() {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Яке Ваше ім'я?", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Дальше", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let name = alertTextField.text
            self.createCustomer(name: name!)
        }
        
        alert.addTextField { textfield in
            textfield.placeholder = "Ім'я"
            alertTextField = textfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func createCustomer(name: String) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Який Ваш номер телефону?", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Дальше", style: .default) { _ in
            let phone = alertTextField.text
            let customer = CustomerModel(name: name, phone: phone!)
            
            PersistenceManager.updateCustomer(customer: customer, actionType: .add) { [weak self] _ in
                guard let self = self else { return }
                let bookingVC = ConfirmBookingVC(booking: self.theBooking, vaporBooking: self.vaporBooking)
                self.navigationController?.pushViewController(bookingVC, animated: true)
            }
        }
        
        alert.addTextField { textfield in
            textfield.placeholder = "Номер телефону"
            alertTextField = textfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @objc private func showCalendar() {
        middleView.subviews.forEach { $0.removeFromSuperview() }
        
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: middleView.bounds.width, height: middleView.bounds.height / 2 + 50))
        calendar.locale = Locale(identifier: "uk")
        calendar.appearance.caseOptions = .headerUsesUpperCase
        calendar.appearance.headerDateFormat = "LLLL YYYY"
        
        calendar.dataSource = self
        calendar.delegate = self
        middleView.addSubview(calendar)
    }
    
    
    private func dateSelected(date: Date) {
        let correctMonth = date.convertToMonthFormat().uppercased()
        let correctDate  = date.convertToDateFormat()
        let selectedDate = DateAndTimeModel(month: correctMonth, date: correctDate, time: [TimeData(time: "09:00"), TimeData(time: "13:00"), TimeData(time: "17:00")])
        dateArray = []
        dateArray.append(selectedDate)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        middleView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -padding / 2)
        ])
        
        dateSelected = true
        tableView.reloadData()
    }
    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeCell.self, forCellReuseIdentifier: TimeCell.reuseID)
        tableView.register(DateSectionCell.self, forHeaderFooterViewReuseIdentifier: DateSectionCell.reuseID)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none        
    }
    
    
    private func tableViewRowHeight(section: Int) -> CGFloat {
        let numberOfItems = ceilf(Float(dateArray[section].time.count) / 3)
        let height = CGFloat(numberOfItems) * 65
        
        return height
    }
    
    
    private func configure() {
        doctorTextLabel = "\(selectedDoctor.doctorName) • \(selectedService)"
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        middleViewLabel.font = .systemFont(ofSize: 15, weight: .medium)
        middleViewLabel.textColor = .secondaryLabel
        middleViewLabel.text = "НАЙБЛИЖЧИЙ ЧАС У \(selectedDoctor.doctorName.uppercased())"
        
        middleView.addSubviews(middleViewLabel, tableView)
        
        NSLayoutConstraint.activate([
            middleViewLabel.topAnchor.constraint(equalTo: middleView.topAnchor, constant: padding / 2),
            middleViewLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: padding),
            middleViewLabel.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -padding),
            middleViewLabel.heightAnchor.constraint(equalToConstant: padding),
            
            tableView.topAnchor.constraint(equalTo: middleViewLabel.bottomAnchor, constant: padding / 2),
            tableView.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -padding / 2)
        ])
    }
}

extension TimeBookingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dateArray.count > section { return 1 }
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard dateSelected else { return dateArray.count + 1 }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.section < dateArray.count else { return 0 }
        return tableViewRowHeight(section: indexPath.section)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return padding
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let contentView = cell.contentView
        
        // this separator is subview of first UITableViewCell in section
        // trying to find it in subviews
        
        if indexPath.row == 0, let divider = cell.subviews.filter({ $0.frame.minY == 0 && $0 !== contentView }).first {
            divider.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimeCell.reuseID, for: indexPath) as! TimeCell
        let size = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableViewRowHeight(section: indexPath.section))
        
        cell.configure(frame: size, layout: UIHelper.createThreeColumnFlowLayout(in: tableView))
        cell.setCell(with: dateArray[indexPath.section].time, section: indexPath.section)
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateSectionCell.reuseID) as! DateSectionCell
        guard section < dateArray.count else {
            header.showCalendar()
            header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCalendar)))
            return header
        }
        header.setCell(with: dateArray[section].month, and: dateArray[section].date)
        return header
    }
}


extension TimeBookingVC: TimeCellDelegate {
    func timeTapped(item: Int, section: Int, chosenTime: String) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: lastSection)) as? TimeCell else { return }
        cell.doctorsTime[lastItem].isChosen = false
        cell.applySnapshot()
        lastItem = item
        lastSection = section
        selectedTime = chosenTime
        
        guard let sectionCell = tableView.headerView(forSection: section) as? DateSectionCell else { return }
        chosenDate = sectionCell.dateLabel.text!
    }
    
}

extension TimeBookingVC: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        dateSelected(date: date)
    }
}

