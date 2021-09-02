//
//  DateAndTimeModel.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 10/26/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation

struct DateAndTimeModel: Hashable {
    var month   : String
    var date    : String
    var time    : [TimeData]
}

struct TimeData: Hashable {
    var time    : String
    var isChosen: Bool = false
}

