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
     Updates name and description and also set's dateAndTime value to nil and removes calendar item if exists
     
     - Parameter eventName: event's name
     - Parameter eventDescription: event's description
     */
    public func update(eventName: String, eventDescription: String) {
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.dateAndTime = nil
        removeEvent()
    }
    
    /**
     Updates name, description, date and also add or remove calendar item
     
     - Parameter eventName: event's name
     - Parameter eventDescription: event's description
     - Parameter dateAndTime: event's date
     - Parameter addCalendarItem: whether calendar item should be updated or add if needs, otherwise is removed
     */
    public func update(eventName: String, eventDescription: String, dateAndTime: Date, addCalendarItem: Bool) {
        if !addCalendarItem {
            removeEvent()
        } else if addCalendarItem && (dateAndTime != self.dateAndTime || eventName != self.eventName) {
            removeEvent()
            requestAccessAndCreateEvent(startDate: dateAndTime)
        }
        
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.dateAndTime = dateAndTime
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
    
    private func removeEvent() {
        if eventIdentifier == nil {
            return
        }
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
                    print("Error when deleting food event")
                }
            }
        }
    }
    
    public static func ==(lhs: FoodEvent, rhs: FoodEvent) -> Bool {
        let name = lhs.eventName == rhs.eventName
        let description = lhs.eventDescription == rhs.eventDescription
        let date = lhs.dateAndTime == rhs.dateAndTime
        return name && description && date
    }
}
