//
//  FoodEvent.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation
import EventKit

class FoodEvent: Equatable {
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
        eventIdentifier = CalendarManager.createEvent(title: eventName, isAllDay: false, startDate: dateAndTime, endDate: dateAndTime.addingTimeInterval(10 * 60))
    }
    
    init(eventName: String, eventDescription: String, dateAndTime: Date?, eventIdentifier: String?) {
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.dateAndTime = dateAndTime
        self.eventIdentifier = eventIdentifier
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
            eventIdentifier = CalendarManager.createEvent(title: eventName, isAllDay: false, startDate: dateAndTime, endDate: dateAndTime.addingTimeInterval(10 * 60))
        }
        
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.dateAndTime = dateAndTime
    }
    
    public func removeEvent() {
        if let identifier = eventIdentifier {
            if CalendarManager.removeEvent(withIdentifier: identifier) {
                eventIdentifier = nil
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
