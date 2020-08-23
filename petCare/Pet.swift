//
//  Pet.swift
//  petCare
//
//  Created by Patrik Pluhař on 18/08/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class Pet {
    let id: Int
    let name: String
    let birth: Date
    
    init(id: Int, name: String, birth: Date) {
        self.id = id
        self.name = name
        self.birth = birth
    }
}
