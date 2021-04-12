//
//  EventType.swift
//  petCare
//
//  Created by Patrik Pluhař on 12.04.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation

enum EventType: String, Codable, CaseIterable {
    case Walk = "Walk"
    case Competition = "Competition"
    case Exhibiton = "Exhibiton"
    case Training = "Training"
    case Other = "Other"
}
