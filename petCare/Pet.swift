//
//  Pet.swift
//  petCare
//
//  Created by Patrik Pluhař on 18/08/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation
import UIKit

class Pet {
    var name: String
    var species: Species
    var birth: Date? = nil
    var sex: Sex? = nil
    var profileImage: UIImage? = nil
    
    init(name: String, species: Species) {
        self.name = name
        self.species = species
    }
}
