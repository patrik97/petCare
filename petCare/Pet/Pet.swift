//
//  Pet.swift
//  petCare
//
//  Created by Patrik Pluhař on 18/08/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation
import EventKit

class Pet: Equatable {
    var name: String
    var species: Species
    var birth: Date? = nil
    var sex: Sex? = nil
    var hasBirthdayReminder: Bool = false
    var foodEvents = [FoodEvent]()
    var vetVisits = [VetVisit]()
    
    init(name: String, species: Species) {
        self.name = name
        self.species = species
    }
    
    init(name: String, species: Species, sex: Sex?, birth: Date?) {
        self.name = name
        self.species = species
        self.sex = sex
        self.birth = birth
    }
    
    public static func ==(lhs: Pet, rhs: Pet) -> Bool {
        return lhs.name == rhs.name && lhs.species == rhs.species && lhs.birth == rhs.birth && lhs.sex == rhs.sex && lhs.hasBirthdayReminder == rhs.hasBirthdayReminder && lhs.foodEvents == rhs.foodEvents && lhs.vetVisits == rhs.vetVisits
    }
    
    /**
     Requests access to iOS calendar if not have and creates birthday event every year
     
     - Parameter startDate date when event starts
     - Parameter endDate date when event ends
     */
    public func requestAccessAndCreateEvent(startDate: Date, endDate: Date) {
        let eventStore = EKEventStore()
        
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in self.createBirthdayEvent(eventStore: eventStore, startDate: startDate, endDate: endDate)
            })
        } else {
            createBirthdayEvent(eventStore: eventStore, startDate: startDate, endDate: endDate)
        }
    }
    
    private func createBirthdayEvent(eventStore: EKEventStore, startDate: Date, endDate: Date) {
        guard let year = Calendar.current.dateComponents([.year], from: Date()).year else {
            return
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = name + " birthday"
        event.isAllDay = true
        
        var component = Calendar.current.dateComponents([.month], from: startDate)
            
        guard let month = component.month else {
            return
        }
        component.year = year
        event.startDate = component.date
        event.endDate = component.date

        event.calendar = eventStore.defaultCalendarForNewEvents
        event.addRecurrenceRule(EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, daysOfTheWeek: nil, daysOfTheMonth: nil, monthsOfTheYear: [NSNumber(value: month)], weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil))
        
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print("Error saving calendar event")
        }
    }
}
