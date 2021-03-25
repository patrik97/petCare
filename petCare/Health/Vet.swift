//
//  Vet.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation

class Vet: Equatable {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    public static func==(lhs: Vet, rhs: Vet) -> Bool {
        return lhs.name == rhs.name
    }
}
