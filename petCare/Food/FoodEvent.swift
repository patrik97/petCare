//
//  FoodEvent.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation
import EventKit

class FoodEvent {
    var eventName: String
    var eventDescription: String
    var dateAndTime: Date? = nil
    private var eventIdentifier: String? = nil
    
    init(eventName: String, eventDescription: String) {
        self.eventName = eventName
        self.eventDescription = eventDescription
    }
    
    init(eventName: String, eventDescription: String, dateAndTime: Date) {
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.dateAndTime = dateAndTime
        requestAccessAndCreateEvent(startDate: dateAndTime)
    }
    
    /**
     Request access and creates event
     
     - Parameter startDate: date of start
     */
    private func requestAccessAndCreateEvent(startDate: Date) {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = eventName
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(10 * 60) // 10 minutes
        event.isAllDay = false
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in self.createEvent(eventStore: eventStore, event: event)
            })
        } else {
            createEvent(eventStore: eventStore, event: event)
        }
    }
    
    private func createEvent(eventStore: EKEventStore, event: EKEvent) {
        do {
            try eventStore.save(event, span: .thisEvent)
            eventIdentifier = event.eventIdentifier
        } catch {
            eventIdentifier = nil
        }
    }
    
    public static func ==(lhs: FoodEvent, rhs: FoodEvent) -> Bool {
        let name = lhs.eventName == rhs.eventName
        let description = lhs.eventDescription == rhs.eventDescription
        let date = lhs.dateAndTime == rhs.dateAndTime
        return name && description && date
    }
}
