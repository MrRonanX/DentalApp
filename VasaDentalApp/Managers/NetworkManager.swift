//
//  NetworkManager.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 10/26/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import Foundation

struct NetworkManager {
    
    static let shared = NetworkManager()
    let baseURL = "http://127.0.0.1:8080/bookings"
    
    
    func saveBooking(booking: VaporBooking, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: baseURL) else { fatalError("wrong url in call")}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try? encoder.encode(booking)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else { return completion(false) }
            
            completion(true)
        }
        .resume()
    }
    
    
    func deleteBooking(bookingID: String, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: baseURL + "/delete/" + bookingID) else { fatalError("wrong url in call") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else { return completion(false) }
            completion(true)
        }
        .resume()
    }
    
    
    func addRating(booking: VaporBooking, completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: baseURL) else { fatalError("wrong url in call")}
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try? encoder.encode(booking)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else { return completion(false) }
            
            completion(true)
        }
        .resume()
    }
}
