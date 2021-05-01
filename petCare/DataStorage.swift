//
//  DataStorage.swift
//  petCare
//
//  Created by Patrik Pluhař on 16/09/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation

class DataStorage {
    private static let PETS_KEY = "pets"
    private static let VETS_KEY = "vets"
    private static let EVENTS_KEY = "event"
    
    public static var pets = [Pet]()
    public static var events = [Event]()
    public static var vets = [Vet]()
    
    static var selectedPet: Pet? = nil
    
    static func addPet(pet: Pet) {
        pets.append(pet)
        persistPets()
    }
    
    static func addEvent(event: Event) {
        events.append(event)
        persistEvents()
    }
    
    static func addVet(vet: Vet) {
        vets.append(vet)
        persistVets()
    }
    
    public static func persistPets() {
        if let selected = selectedPet {
            pets.removeAll(where: { $0.name == selected.name })
            pets.append(selected)
        }
        
        do {
            let petAsJson = try JSONEncoder().encode(DataStorage.pets)
            UserDefaults.standard.set(petAsJson, forKey: DataStorage.PETS_KEY)
        } catch let error {
            print("Error when saving Pets data: " + error.localizedDescription)
        }
    }
    
    public static func persistVets() {
        do {
            let vetAsJson = try JSONEncoder().encode(DataStorage.vets)
            UserDefaults.standard.set(vetAsJson, forKey: DataStorage.VETS_KEY)
        } catch let error {
            print("Error when saving Vets data: " + error.localizedDescription)
        }
    }
    
    public static func persistEvents() {
        do {
            let eventAsJson = try JSONEncoder().encode(DataStorage.events)
            UserDefaults.standard.set(eventAsJson, forKey: DataStorage.EVENTS_KEY)
        } catch let error {
            print("Error when saving Events data: " + error.localizedDescription)
        }
    }
    
    public static func loadPets() {
        guard let jsonData = UserDefaults.standard.data(forKey: DataStorage.PETS_KEY) else {
            return
        }
        
        do {
            pets = try JSONDecoder().decode([Pet].self, from: jsonData)
        } catch let error {
            print("Error when loading Pets data: " + error.localizedDescription)
        }
        
        if selectedPet == nil && !pets.isEmpty {
            selectedPet = pets[0]
        }
    }
    
    public static func loadEvents() {
        guard let jsonData = UserDefaults.standard.data(forKey: DataStorage.EVENTS_KEY) else {
            return
        }
        
        do {
            events = try JSONDecoder().decode([Event].self, from: jsonData)
        } catch let error {
            print("Error when loading Events data: " + error.localizedDescription)
        }
    }
    
    public static func loadVets() {
        guard let jsonData = UserDefaults.standard.data(forKey: DataStorage.VETS_KEY) else {
            return
        }
        
        do {
            vets = try JSONDecoder().decode([Vet].self, from: jsonData)
        } catch let error {
            print("Error when loading Vets data: " + error.localizedDescription)
        }
    }
    
    public static func updateEvent(event: Event) {
        events.removeAll(where: { $0.id == event.id })
        addEvent(event: event)
    }
    
    public static func persistAndLoadAll() {
        persistPets()
        persistVets()
        persistEvents()
        loadPets()
        loadVets()
        loadEvents()
    }
}
