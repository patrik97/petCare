//
//  VetVisit.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation

class VetVisit: Equatable {
    var date: Date
    var notes: String = ""
    var vet: Vet
    
    init(date: Date, vet: Vet) {
        self.date = date
        self.vet = vet
    }
    
    public static func ==(lhs: VetVisit, rhs: VetVisit) -> Bool {
        return lhs.date == rhs.date && lhs.notes == rhs.notes && lhs.vet == rhs.vet;
    }
    
    public func update(date: Date, vet: Vet, notes: String) {
        self.date = date
        self.vet = vet
        self.notes = notes
    }
}
