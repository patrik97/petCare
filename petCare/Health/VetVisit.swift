//
//  VetVisit.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation
import EventKit

class VetVisit: Equatable {
    var date: Date
    var notes: String = ""
    var vet: Vet
    var type: VetVisitType
    var interval: Int
    var eventIdentifier: String? = nil
    
    init(date: Date, vet: Vet, notes: String, type: VetVisitType, frequency: String?, interval: Int) {
        self.date = date
        self.vet = vet
        self.notes = notes
        self.type = type
        self.interval = interval
        eventIdentifier = CalendarManager.createEvent(title: type.rawValue, isAllDay: false, startDate: date, endDate: date.addingTimeInterval(10 * 60 * 60), reccurenceCount: interval)
    }
    
    public static func ==(lhs: VetVisit, rhs: VetVisit) -> Bool {
        return lhs.date == rhs.date && lhs.notes == rhs.notes && lhs.vet == rhs.vet;
    }
    
    public func update(date: Date, vet: Vet, notes: String, type: VetVisitType, frequency: String?, interval: Int) {
        let updateEvent = date != self.date || type != self.type || self.interval != interval
        
        self.date = date
        self.vet = vet
        self.notes = notes
        self.interval = interval
        self.type = type
        
        if updateEvent {
            if let identifier = eventIdentifier {
                if CalendarManager.removeEvent(withIdentifier: identifier) {
                    eventIdentifier = nil
                }
            }
            eventIdentifier = CalendarManager.createEvent(title: type.rawValue, isAllDay: false, startDate: date, endDate: date.addingTimeInterval(10 * 60 * 60), reccurenceCount: interval)
        }
    }
}
