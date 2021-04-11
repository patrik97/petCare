//
//  CalendarManager.swift
//  petCare
//
//  Created by Patrik Pluhař on 10.04.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation
import EventKit

class CalendarManager {
    /**
     Request access to iOS Calendar and create event with given parameters
     
     - Parameter title: event's title
     - Parameter isAllDay: whether event is all day event
     - Parameter startDate: date and time of start
     - Parameter endDate: date and time of end
     
     - Returns unique event identifier if success, else nil
     */
    public static func createEvent(title: String, isAllDay: Bool, startDate: Date, endDate: Date) -> String? {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.isAllDay = false
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        let eventIdentifier = event.eventIdentifier
        
        if requestAccess(eventStore: eventStore, event: event) {
            return eventIdentifier
        } else {
            return nil
        }
    }
    
    /**
     Request access to iOS Calendar and create event with given parameters
     
     - Parameter title: event's title
     - Parameter isAllDay: whether event is all day event
     - Parameter startDate: date and time of start
     - Parameter endDate: date and time of end
     - Parameter frequency: frenquention of events
     - Parameter interval: how many times is event repeated
     
     - Returns unique event identifier if success, else nil
     */
    public static func createEvent(title: String, isAllDay: Bool, startDate: Date, endDate: Date, reccurenceCount: Int, reccurenceWith: String) -> String? {
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.isAllDay = false
        event.startDate = startDate
        event.endDate = endDate
        var frequency: EKRecurrenceFrequency = .daily
        if reccurenceWith == "Yearly" {
            frequency = .yearly
        } else if reccurenceWith == "Monthly" {
            frequency = .monthly
        } else if reccurenceWith == "Weekly" {
            frequency = .weekly
        }
        event.addRecurrenceRule(EKRecurrenceRule(recurrenceWith: frequency, interval: 1, end: EKRecurrenceEnd(occurrenceCount: reccurenceCount)))
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        let eventIdentifier = event.eventIdentifier
        
        if requestAccess(eventStore: eventStore, event: event) {
            return eventIdentifier
        } else {
            return nil
        }
    }
    
    private static func requestAccess(eventStore: EKEventStore, event: EKEvent) -> Bool {
        var result = false
        
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in result = self.insertEvent(eventStore: eventStore, event: event)
            })
        } else {
            result = insertEvent(eventStore: eventStore, event: event)
        }
        
        return result
    }
    
    private static func insertEvent(eventStore: EKEventStore, event: EKEvent) -> Bool {
        do {
            try eventStore.save(event, span: .thisEvent)
            return true
        } catch {
            return false
        }
    }
    
    /**
     Removes with given identifier event from calendar
     
     - Parameter withIdentifier: event's identifier
     
     - Returns true if event succesfully removed or no event with given identifier exists, else false
     */
    public static func removeEvent(withIdentifier: String) -> Bool {
        let eventStore = EKEventStore()
        var result = false;
        if EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in result = self.remove(eventStore: eventStore, identifier: withIdentifier)
            })
        } else {
            result = remove(eventStore: eventStore, identifier: withIdentifier)
        }
        
        return result
    }
    
    private static func remove(eventStore: EKEventStore, identifier: String) -> Bool {
        if let event = eventStore.event(withIdentifier: identifier) {
            do {
                try eventStore.remove(event, span: .thisEvent, commit: true)
                return true
            } catch {
                print("Error when deleting event")
                return false
            }
        }
        
        return true
    }
}
