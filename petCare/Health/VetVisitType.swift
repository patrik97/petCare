//
//  VetVisitType.swift
//  petCare
//
//  Created by Patrik Pluhař on 10.04.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation

enum VetVisitType: String, Codable, CaseIterable {
    case Examination = "Examination"
    case Vaccination = "Vaccination"
    case Surgery = "Surgery"
    case Other = "Other"
    
    public static func allTypesString() -> [String] {
        return [VetVisitType.Examination.rawValue, VetVisitType.Vaccination.rawValue, VetVisitType.Surgery.rawValue, VetVisitType.Other.rawValue]
    }
}
