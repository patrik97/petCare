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
    
    var index: Int {
        get {
            switch self {
            case .dog:
                return 0
            case .cat:
                return 1
            case .bird:
                return 2
            case .snake:
                return 3
            case .turtle:
                return 4
            case .horse:
                return 5
            case .bunny:
                return 6
            case .rodent:
                return 7
            case .other:
                return 8
            }
        }
    }
}
