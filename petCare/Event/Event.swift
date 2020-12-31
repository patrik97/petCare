//
//  Event.swift
//  petCare
//
//  Created by Patrik Pluhař on 30.12.2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class Event {
    var name: String
    var description: String
    var startDate: Date
    var endDate: Date?
    var pets: [Pet]
    
    init(name: String, description: String, startDate: Date, endDate: Date?, pets: [Pet]) {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.pets = pets
    }
    
    func names() -> String {
        var names = ""
        var first = true
        for pet in pets {
            if !first {
                names += ", "
            }
            
            names += pet.name
            first = false
        }
        return names
    }
}
