//
//  FoodEvent.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation

struct FoodEvent {
    var eventName: String
    var eventDescription: String
    
    init(eventName: String, eventDescription: String) {
        self.eventName = eventName
        self.eventDescription = eventDescription
    }
}
