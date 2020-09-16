//
//  DataStorage.swift
//  petCare
//
//  Created by Patrik Pluhař on 16/09/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class DataStorage {
    static var pets = [Pet]()
    
    static func addPet(pet: Pet) {
        pets.append(pet)
    }
}
