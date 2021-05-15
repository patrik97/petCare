//
//  EventType.swift
//  petCare
//
//  Created by Patrik Pluhař on 12.04.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation

enum EventType: String, Codable, CaseIterable {
    case Walk
    case Competition
    case Exhibiton
    case Training
    case Other
    
    var description: String {
        get {
            switch self {
            case .Walk:
                return NSLocalizedString("Walk", comment: "")
            case .Competition:
                return NSLocalizedString("Competition", comment: "")
            case .Exhibiton:
                return NSLocalizedString("Exhibition", comment: "")
            case .Training:
                return NSLocalizedString("Training", comment: "")
            case .Other:
                return NSLocalizedString("Other", comment: "")
            }
        }
    }
}
