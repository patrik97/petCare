//
//  VetVisitType.swift
//  petCare
//
//  Created by Patrik Pluhař on 10.04.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation

enum VetVisitType: String, Codable, CaseIterable {
    case Examination
    case Vaccination
    case Surgery
    case Other
    
    public static func allTypesString() -> [String] {
        return [VetVisitType.Examination.description, VetVisitType.Vaccination.description, VetVisitType.Surgery.description, VetVisitType.Other.description]
    }
    
    var description: String {
        get {
            switch self {
            case .Examination:
                return NSLocalizedString("Examination", comment: "")
            case .Vaccination:
                return NSLocalizedString("Vaccination", comment: "")
            case .Surgery:
                return NSLocalizedString("Surgery", comment: "")
            case .Other:
                return NSLocalizedString("Other", comment: "")
            }
        }
    }
}
