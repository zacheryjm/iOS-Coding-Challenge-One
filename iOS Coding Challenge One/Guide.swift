//
//  Guide.swift
//  iOS Coding Challenge One
//
//  Created by Zachery Miller on 1/28/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import Foundation

struct Guide {
    
    let name : String?
    let city : String?
    let state : String?
    let startDate : Date?
    let endDate : Date?
    
}

enum SerializationError: Error {
    case missing(String)
}

//TODO: Handle Error of Venue not being there.
extension Guide {
    
    init?(json : [String : Any]) throws{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        //Extract Name
        if let name = json["name"] as? String {
            self.name = name
        } else {
            self.name = nil
        }
        
        
        //Extract City & State
        if let jsonVenue = json["venue"] as? [String : String] {
            if let city = jsonVenue["city"] {
                self.city = city
            } else {
                self.city = nil
            }
            if let state = jsonVenue["state"] {
                self.state = state
            } else {
                self.state = nil
            }
        } else {
            self.city = nil
            self.state = nil
        }
        
        //Extract Start Date
        if let startDateAsString = json["startDate"] as? String {
            let startDate = dateFormatter.date(from: startDateAsString)
            self.startDate = startDate
        } else {
            self.startDate = nil
        }
        
        //Extract End Date
        if let endDateAsString = json["endDate"] as? String {
            let endDate = dateFormatter.date(from: endDateAsString)
            self.endDate = endDate
        } else {
            self.endDate = nil
        }

        
    }
}

extension Guide : Comparable {
    static func < (first : Guide, second : Guide) -> Bool {
        if first.startDate != second.startDate {
            return first.startDate! < second.startDate!
        }
        else {
            return first.endDate! < second.endDate!
        }
    }
    
    static func == (first : Guide, second : Guide) -> Bool {
        return first.startDate == second.startDate && first.endDate == second.endDate
    }
}
