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
        return [VetVisitFrequency.Yearly.description, VetVisitFrequency.Monthly.description, VetVisitFrequency.Weekly.description, VetVisitFrequency.Daily.description]
    }
    
    var description: String {
        switch self {
        case .Yearly:
            return NSLocalizedString("Yearly", comment: "")
        case .Monthly:
            return NSLocalizedString("Monthly", comment: "")
        case .Weekly:
            return NSLocalizedString("Weekly", comment: "")
        case .Daily:
            return NSLocalizedString("Daily", comment: "")
        }
    }
}
