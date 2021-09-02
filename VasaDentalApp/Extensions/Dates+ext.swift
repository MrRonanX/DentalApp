//
//  Dates+ext.swift
//  GitHubFollowers
//
//  Created by Roman Kavinskyi on 25.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation

extension Date {
	
	func convertToMonthYearFormat() -> String {
		let dateFormatter 			= DateFormatter()
		dateFormatter.dateFormat 	= "dd MMMM"  //original: "MMM yyy"
        dateFormatter.locale = Locale(identifier: "uk")
		return dateFormatter.string(from: self)
	}
    
    
    func convertToMonthFormat() -> String {
        let dateFormatter             = DateFormatter()
        dateFormatter.dateFormat     = "MMMM"
        dateFormatter.locale = Locale(identifier: "uk")
        return dateFormatter.string(from: self)
    }
    
    
    func convertToDateFormat() -> String {
        let dateFormatter             = DateFormatter()
        dateFormatter.dateFormat     = "dd"
        dateFormatter.locale = Locale(identifier: "uk")
        return dateFormatter.string(from: self)
    }
}
