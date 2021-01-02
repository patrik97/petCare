//
//  AddEventControllerDetail.swift
//  petCare
//
//  Created by Patrik Pluhař on 31.12.2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class AddEventControllerDetail: UIViewController {
    var event: Event? = nil
    var pets: [Pet] = []
    var addEventControllerPet: AddEventControllerPet? = nil
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextField: UITextField!
    @IBOutlet weak var eventStartDatePicker: UIDatePicker!
    @IBOutlet weak var eventEndDatePicker: UIDatePicker!
    @IBOutlet weak var endDateAndTimeLabel: UILabel!
    @IBOutlet weak var endDateSwitch: UISwitch!
    @IBOutlet weak var eventEndDatePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var calendarAppSwitch: UISwitch!
    @IBOutlet weak var calendarAppLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 14.0, *) {
            eventStartDatePicker.preferredDatePickerStyle = .inline
            eventEndDatePicker.preferredDatePickerStyle = .inline
        } else {
            eventStartDatePicker.preferredDatePickerStyle = .wheels
            eventEndDatePicker.preferredDatePickerStyle = .wheels
        }
        
        if let editedEvent = event {
            setElementsForEditedEvent(editedEvent: editedEvent)
        }
    }
    @IBAction func selectEndDateSwitchValueChanged(_ sender: UISwitch) {
        setElementsByEndDateSwitch()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if !eventEndDatePicker.isHidden && eventEndDatePicker.date <= eventStartDatePicker.date {
            invalidParameter(title: "Invalid date", message: "End date must be later then start date")
            return
        }
        
        guard let eventName = eventNameTextField.text else {
            invalidParameter(title: "Invalid name", message: "Please type an event name")
            return
        }
        
        if eventName.count == 0 || eventName.count > 30 {
            if eventName.count == 0 {
                invalidParameter(title: "Invalid name", message: "Please type an event name")
            } else {
                invalidParameter(title: "Invalid name", message: "Name is bigger then 30 characters")
            }
            return
        }
        
        let endDate = eventEndDatePicker.isHidden ? nil : eventEndDatePicker.date
        let description = eventDescriptionTextField.text ?? ""
        let addCalendarEvent = !eventEndDatePicker.isHidden && calendarAppSwitch.isOn
        
        if let editedEvent = event {
            editedEvent.name = eventName
            editedEvent.description = description
            if addCalendarEvent && (eventStartDatePicker.date != editedEvent.startDate || endDate != editedEvent.endDate), let notOptionalEndDate = endDate {
                editedEvent.requestAccessRemoveEventAndCreateNew(startDate: eventStartDatePicker.date, endDate: notOptionalEndDate, title: eventName)
            } else if editedEvent.hasCalendarEvent && !addCalendarEvent {
                editedEvent.removeEvent()
            }
            
            self.navigationController?.popBackTo(viewController: EventDetailController.self)
            return
        }
        
        DataStorage.addEvent(event: Event(name: eventName, description: description, startDate: eventStartDatePicker.date, endDate: endDate, pets: pets, addCalendarEvent: addCalendarEvent))
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func invalidParameter(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        return
    }
    
    private func setElementsForEditedEvent(editedEvent: Event) {
        eventNameTextField.text = editedEvent.name
        eventDescriptionTextField.text = editedEvent.description
        eventStartDatePicker.date = editedEvent.startDate
        if let endDate = editedEvent.endDate {
            eventEndDatePicker.date = endDate
            endDateSwitch.isOn = true
            setElementsByEndDateSwitch()
        }
    }
    
    private func setElementsByEndDateSwitch() {
        eventEndDatePicker.isHidden = !endDateSwitch.isOn
        endDateAndTimeLabel.isHidden = !endDateSwitch.isOn
        calendarAppSwitch.isHidden = !endDateSwitch.isOn
        calendarAppLabel.isHidden = !endDateSwitch.isOn
        if endDateSwitch.isOn {
            eventEndDatePickerHeight.constant = 390
        } else {
            eventEndDatePickerHeight.constant = 0
        }
    }
}


// Inspiration: https://stackoverflow.com/questions/65526016/swift-dismiss-two-controllers-wrong-order
extension UINavigationController {
    func popBackTo(viewController: UIViewController.Type) {
        for vc in self.viewControllers {
            if vc.isKind(of: viewController) {
                self.popToViewController(vc, animated: true)
                return
            }
        }
    }
}
