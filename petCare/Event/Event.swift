//
//  Event.swift
//  petCare
//
//  Created by Patrik Pluhař on 30.12.2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import Foundation
import EventKit

class Event {
    var name: String
    var description: String
    // date cannot be easily changed
    // there must be classical setter 
    private(set) var startDate: Date
    private(set) var endDate: Date?
    var pets: [Pet]
    private var eventIdentifier: String? = nil
    var photos = [Data]()
    
    var hasCalendarEvent: Bool {
        get {
            return eventIdentifier != nil
        }
    }
    
    init(name: String, description: String, startDate: Date, endDate: Date?, pets: [Pet], addCalendarEvent: Bool) {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.pets = pets
        
        if addCalendarEvent, let end = endDate {
            requestAccessAndCreateEvent(startDate: startDate, endDate: end, title: name)
        }
    }
    
    /**
     Create string of all pets in event like: First, Second, Third etc.
     
     - Returns: string of all pets in event
     */
    func names() -> String {
        var names = ""
        var first = true
        for pet in pets {
            if !first {
                names += ", "
            }
            
            names += pet.name
            first = false
        }
        return names
    }
}

// Extension that works with iOS calendar
extension Event {
    /**
     Requests access to iOS calendar, remove old event and add new event
     Event cannot be renamed alone without change date. It is needed to rename event, change date and then event can be renamed
     Rename means remove old event and add new one
     
     - Parameter startDate: date when event starts
     - Parameter endDate: date when event ends
     - Parameter title: new event name
     */
    public func requestAccessAndCreateEvent(startDate: Date, endDate: Date, title: String) {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.isAllDay = false
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        eventIdentifier = event.eventIdentifier
        
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in self.createEvent(eventStore: eventStore, event: event)
            })
        } else {
            createEvent(eventStore: eventStore, event: event)
        }
    }
    
    public func removeEvent() {
        let eventStore = EKEventStore()
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in self.removeOldEvent(eventStore: eventStore)
            })
        } else {
            removeOldEvent(eventStore: eventStore)
        }
    }
    
    private func removeOldEvent(eventStore: EKEventStore) {
        if let identifier = eventIdentifier {
            if let event = eventStore.event(withIdentifier: identifier) {
                do {
                    try eventStore.remove(event, span: .thisEvent, commit: true)
                    eventIdentifier = nil
                } catch {
                    print("Error when deleting event")
                }
            }
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
}
