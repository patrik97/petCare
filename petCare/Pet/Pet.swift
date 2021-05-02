//
//  Pet.swift
//  petCare
//
//  Created by Patrik Pluhař on 18/08/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation
import EventKit

class Pet: Equatable, Encodable, Decodable {
    var name: String
    var species: Species
    var birth: Date? = nil
    var sex: Sex? = nil
    var hasBirthdayReminder: Bool = false
    var foodEvents = [FoodEvent]()
    var vetVisits = [VetVisit]()
    var eventIdentifier: String? = nil
    
    init(name: String, species: Species) {
        self.name = name
        self.species = species
    }
    
    public static func==(lhs: Pet, rhs: Pet) -> Bool {
        return lhs.name == rhs.name && lhs.species == rhs.species && lhs.birth == rhs.birth && lhs.sex == rhs.sex && rhs.hasBirthdayReminder == lhs.hasBirthdayReminder
    }
    
    public func addBirthday() {
        removeBirthday()
        
        guard let birthday = birth else {
            return
        }
        
        let endDate = birthday.addingTimeInterval(1)
        eventIdentifier = CalendarManager.createEvent(title: "\(name) birthday", isAllDay: true, startDate: birthday, endDate: endDate)
    }
    
    public func removeBirthday() {
        if let identifier = eventIdentifier {
            if CalendarManager.removeEvent(withIdentifier: identifier) {
                birth = nil
                eventIdentifier = nil
            }
        }
    }
    
    public func delete() {
        for visit in vetVisits {
            visit.delete()
        }
        
        for event in foodEvents {
            event.removeEvent()
        }
        
        for event in DataStorage.events {
            event.pets.removeAll(where: { $0 == name })
        }
        
        removeBirthday()
        DataStorage.events.removeAll(where: { $0.pets.isEmpty })
        DataStorage.pets.removeAll(where: { $0.name == name })
        DataStorage.selectedPet = nil
        DataStorage.persistAndLoadAll()
    }
}
