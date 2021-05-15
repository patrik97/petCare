//
//  Species.swift
//  petCare
//
//  Created by Patrik Pluhař on 21/08/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

enum Species: String, Codable, CaseIterable {
    case dog
    case cat
    case bird
    case snake
    case turtle
    case horse
    case bunny
    case rodent
    case other
    
    var description: String {
        get {
            switch self {
            case .dog:
                return NSLocalizedString("Dog", comment: "Dog enum")
            case .cat:
                return NSLocalizedString("Cat", comment: "Cat enum")
            case .bird:
                return NSLocalizedString("Bird", comment: "Bird enum")
            case .snake:
                return NSLocalizedString("Snake", comment: "Snake enum")
            case .turtle:
                return NSLocalizedString("Turtle", comment: "Turtle enum")
            case .horse:
                return NSLocalizedString("Horse", comment: "Horse enum")
            case .bunny:
                return NSLocalizedString("Bunny", comment: "Bunny enum")
            case .rodent:
                return NSLocalizedString("Rodent", comment: "Rodent enum")
            case .other:
                return NSLocalizedString("Other", comment: "Other enum")
            }
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
