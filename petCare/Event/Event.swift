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
    var eventType: EventType
    // date cannot be easily changed
    // there must be classical setter 
    private(set) var startDate: Date
    private(set) var endDate: Date?
    var pets: [Pet]
    private var eventIdentifier: String? = nil
    var photos = [Data]()
    var mainPhoto: Data? = nil
    
    var hasCalendarEvent: Bool {
        get {
            return eventIdentifier != nil
        }
    }
    
    init(name: String, description: String, startDate: Date, endDate: Date?, pets: [Pet], addCalendarEvent: Bool, eventType: EventType) {
        self.name = name
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.pets = pets
        self.eventType = eventType
        
        if addCalendarEvent, let end = endDate {
            eventIdentifier = CalendarManager.createEvent(title: name, isAllDay: false, startDate: startDate, endDate: end)
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
    
    public func removeEvent() {
        if let identifier = eventIdentifier {
            if CalendarManager.removeEvent(withIdentifier: identifier) {
                eventIdentifier = nil
                endDate = nil
            }
        }
    }
    
    public func setPhotoAsMain(index: Int) {
        mainPhoto = photos[index]
    }
    
    public func removePhotoAt(index: Int) {
        if index >= photos.count {
            return
        }
        
        photos.remove(at: index)
    }
}
