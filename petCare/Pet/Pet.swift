//
//  Pet.swift
//  petCare
//
//  Created by Patrik Pluhař on 18/08/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation
import EventKit

class Pet {
    var name: String
    var species: Species
    var birth: Date? = nil
    var sex: Sex? = nil
    var hasBirthdayReminder: Bool = false
    
    init(name: String, species: Species) {
        self.name = name
        self.species = species
    }
    
    /**
     Requests access to iOS calendar if not have and creates birthday event every year
     Currently not using (prepared for future). Main problem is what to do with events when user changes date of birth
     
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
