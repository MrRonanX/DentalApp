//
//  BookingModel.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 10/26/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation

struct BookingModel: Hashable, Codable {
    let id      : UUID
    let service : String
    let date    : String
    let rawDate : Date
    let time    : String
    let doctor  : DoctorModel
}

struct DoctorModel: Codable, Hashable {
    var doctorName          : String
    var doctorSpeciality    : String
    var doctorEmail         : String = "mrronanx@gmail.com"
    var address             : String = "Жаб'ївська 55"
    var phone               : String = "+38 096 820 99 83"
    var doctorRating        : Double
    
}

