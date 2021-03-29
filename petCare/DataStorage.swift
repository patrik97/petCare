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
    static var events = [Event]()
    static var vets = [Vet]()
    static var selectedPet: Pet? = nil
    
    static func addPet(pet: Pet) {
        pets.append(pet)
    }
    
    static func addEvent(event: Event) {
        events.append(event)
    }
    
    static func addVet(vet: Vet) {
        vets.append(vet)
    }
}
