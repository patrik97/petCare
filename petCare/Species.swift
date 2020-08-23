//
//  Species.swift
//  petCare
//
//  Created by Patrik Pluhař on 21/08/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

enum Species: String, Codable, CaseIterable {
    case dog = "Dog"
    case cat = "Cat"
    case bird = "Bird"
    case snake = "Snake"
    case turtle = "Turtle"
    case horse = "Horse"
    case bunny = "Bunny"
    case rodent = "Rodent"
    case other = "Other"
    
    var description: String {
        get {
            return self.rawValue
        }
    }
}
