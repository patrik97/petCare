//
//  VetVisitFrequency.swift
//  petCare
//
//  Created by Patrik Pluhař on 11.04.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation

enum VetVisitFrequency: String, Codable, CaseIterable {
    case Yearly = "Yearly"
    case Monthly = "Monthly"
    case Weekly = "Weekly"
    case Daily = "Daily"
    
    public static func allTypesString() -> [String] {
        return [VetVisitFrequency.Yearly.rawValue, VetVisitFrequency.Monthly.rawValue, VetVisitFrequency.Weekly.rawValue, VetVisitFrequency.Daily.rawValue]
    }
}
