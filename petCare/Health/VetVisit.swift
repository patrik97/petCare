//
//  VetVisit.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation
import EventKit

class VetVisit: Equatable, Encodable, Decodable {
    var date: Date
    var notes: String = ""
    var vet: Vet
    var type: VetVisitType
    var interval: Int
    var eventIdentifier: String? = nil
    var frequency: VetVisitFrequency
    
    init(date: Date, vet: Vet, notes: String, type: VetVisitType, frequency: VetVisitFrequency, interval: Int) {
        self.date = date
        self.vet = vet
        self.notes = notes
        self.type = type
        self.interval = interval
        self.frequency = frequency
        eventIdentifier = CalendarManager.createEvent(title: type.rawValue, isAllDay: false, startDate: date, endDate: date.addingTimeInterval(60 * 60), reccurenceCount: interval, reccurenceWith: frequency.rawValue)
    }
    
    public static func ==(lhs: VetVisit, rhs: VetVisit) -> Bool {
        return lhs.date == rhs.date && lhs.notes == rhs.notes && lhs.vet == rhs.vet && lhs.type == rhs.type && lhs.interval == rhs.interval && lhs.eventIdentifier == rhs.eventIdentifier && lhs.frequency == rhs.frequency;
    }
    
    public func update(date: Date, vet: Vet, notes: String, type: VetVisitType, frequency: VetVisitFrequency, interval: Int) {
        let updateEvent = date != self.date || type != self.type || self.interval != interval
        
        self.date = date
        self.vet = vet
        self.notes = notes
        self.interval = interval
        self.type = type
        self.frequency = frequency
        
        if updateEvent {
            removeEvent()
            eventIdentifier = CalendarManager.createEvent(title: type.rawValue, isAllDay: false, startDate: date, endDate: date.addingTimeInterval(60 * 60), reccurenceCount: interval, reccurenceWith: frequency.rawValue)
        }
    }
    
    public func removeEvent() {
        if let identifier = eventIdentifier {
            if CalendarManager.removeEvent(withIdentifier: identifier) {
                eventIdentifier = nil
            }
        }
    }
    
    public func delete() {
        if let identifier = eventIdentifier {
            if CalendarManager.removeEvent(withIdentifier: identifier) {
                eventIdentifier = nil
            }
        }
        
        let owner = DataStorage.pets.first(where: { $0.vetVisits.contains(self) })
        owner?.vetVisits.removeAll(where: { $0 == self })
    }
}
