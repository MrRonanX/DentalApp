//
//  PersistanceManager.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 10/27/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}


enum Keys {
    static let bookings = "bookings"
    static let customer = "customer"
}


enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    
    static func retrieveFavorites(completed: @escaping (Result<[BookingModel], Error>) -> Void) {
        guard let bookingData = defaults.object(forKey: Keys.bookings) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let bookings = try decoder.decode([BookingModel].self, from: bookingData)
            completed(.success(bookings))
        } catch {
            print(error)
            completed(.failure(error))
        }
    }
    
    
    static func save(booking: [BookingModel]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedBooking = try encoder.encode(booking)
            
            defaults.set(encodedBooking, forKey: Keys.bookings)
            return nil
        } catch {
            print("error: \(error)")
            return error
        }
    }
    
    
    static func updateWith(booking: BookingModel, actionType: PersistenceActionType, completed: @escaping (Error?) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var bookings):
                switch actionType {
                case .add:
                    bookings.append(booking)
                case .remove:
                    bookings.removeAll { $0.id == booking.id }
                }
                completed(save(booking: bookings))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func updateCustomer(customer: CustomerModel, actionType: PersistenceActionType, completed: @escaping (Error?) -> Void) {
        retrieveCustomers { result in
            switch result {
            case .success(var retrievedCustomer):
                switch actionType {
                case .add:
                    retrievedCustomer.removeAll()
                    retrievedCustomer.append(customer)
                case .remove:
                    retrievedCustomer.removeAll()
                }
                completed(saveNewCustomer(customer: retrievedCustomer))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveCustomers(completed: @escaping (Result<[CustomerModel], Error>) -> Void) {
        guard let customerData = defaults.object(forKey: Keys.customer) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let customer = try decoder.decode([CustomerModel].self, from: customerData)
            completed(.success(customer))
            
        } catch {
            print(error)
            completed(.failure(error))
        }
    }
    
    
    static func saveNewCustomer(customer: [CustomerModel]) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedCustomer = try encoder.encode(customer)
            
            defaults.set(encodedCustomer, forKey: Keys.customer)
            return nil
        } catch {
            print("error saving customer")
            return error
        }
        
    }
}
