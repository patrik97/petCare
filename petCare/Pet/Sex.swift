//
//  Sex.swift
//  petCare
//
//  Created by Patrik Pluhař on 18/10/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

enum Sex: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    
    var description: String {
        get {
            return self.rawValue
        }
    }
    
    var index: Int {
        get {
            switch self {
            case .male:
                return 0
            case .female:
                return 1
            }
        }
    }
}
