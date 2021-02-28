//
//  VetVisit.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation

class VetVisit {
    var date: Date
    var notes: String = ""
    var vet: Vet?
    
    init(date: Date, vet: Vet?) {
        self.date = date
        self.vet = vet
    }
}
