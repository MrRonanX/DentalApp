//
//  TabBarController.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 11/6/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemTeal
        viewControllers = [createDoctorsVC(), createPersonalVC()]
    }
    
    private func createDoctorsVC() -> UINavigationController {
        let doctorVC = WelcomeVC()
        doctorVC.tabBarItem = UITabBarItem(title: "Прийом",
                                           image: UIImage(systemName: "person.3.fill"),
                                           selectedImage: UIImage(systemName: "person.3.fill")?.withTintColor(.systemBlue))
        
        return UINavigationController(rootViewController: doctorVC)
    }
    
    
    private func createPersonalVC() -> UINavigationController {
        let personalVC = PersonalPageVC()
        personalVC.tabBarItem = UITabBarItem(title: "Мій аккаунт",
                                             image: UIImage(systemName: "person.circle.fill"),
                                             selectedImage: UIImage(systemName: "person.circle.fill")?.withTintColor(.systemBlue))
        
        return UINavigationController(rootViewController: personalVC)
    }
}
