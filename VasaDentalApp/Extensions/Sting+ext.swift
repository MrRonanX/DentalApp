//
//  Sting+ext.swift
//  GitHubFollowers
//
//  Created by Roman Kavinskyi on 25.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation

extension String {
	
	func convertToDate() -> Date? {
		let dateFormatter 			= DateFormatter()
		dateFormatter.dateFormat 	= "dd-MM"  // yyyy-MM-dd'T'HH:mm:ssZ
		dateFormatter.locale 		= Locale(identifier: "uk")  // original: "en_US_POSIX"
		dateFormatter.timeZone 		= .current
		
		return dateFormatter.date(from: self)
	}
	
    
	func convertToDisplayFormat() -> String {
		guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
	}
}
