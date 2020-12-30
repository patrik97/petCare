//
//  Event.swift
//  petCare
//
//  Created by Patrik Pluhař on 30.12.2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class Event {
    var startDate: Date
    var endDate: Date
    var pets: [Pet]
    
    init(startDate: Date, endDate: Date, pets: [Pet]) {
        self.startDate = startDate
        self.endDate = endDate
        self.pets = pets
    }
    
    convenience init(startDate: Date, endDate: Date, pet: Pet) {
        self.init(startDate: startDate, endDate: endDate, pets: [pet])
    }
}
