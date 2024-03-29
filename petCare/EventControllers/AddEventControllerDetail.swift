//
//  AddEventControllerDetail.swift
//  petCare
//
//  Created by Patrik Pluhař on 31.12.2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit
import DropDown

class AddEventControllerDetail: UIViewController {
    var event: Event? = nil
    var pets: [Pet] = []
    var eventType: EventType = .Walk
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
    @IBOutlet weak var eventTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 14.0, *) {
            eventStartDatePicker.preferredDatePickerStyle = .inline
            eventEndDatePicker.preferredDatePickerStyle = .inline
        } else {
            eventStartDatePicker.preferredDatePickerStyle = .wheels
            eventEndDatePicker.preferredDatePickerStyle = .wheels
        }
        
        eventTypeLabel.text = EventType.Walk.description
        eventEndDatePicker.date.addTimeInterval(10 * 60)
        if let editedEvent = event {
            setElementsForEditedEvent(editedEvent: editedEvent)
        }
    }
    @IBAction func selectEndDateSwitchValueChanged(_ sender: UISwitch) {
        self.view.endEditing(true)
        setElementsByEndDateSwitch()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // actually used for UITextField description as well
    @IBAction func eventNameDidEndOnExit(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        self.view.endEditing(true)
        if !eventEndDatePicker.isHidden && eventEndDatePicker.date <= eventStartDatePicker.date {
            invalidParameter(title: NSLocalizedString("Invalid date", comment: ""), message: NSLocalizedString("End date must be later then start date", comment: ""))
            return
        }
        
        guard let eventName = eventNameTextField.text else {
            invalidParameter(title: NSLocalizedString("Invalid name", comment: ""), message: NSLocalizedString("Please type an event name", comment: ""))
            return
        }
        
        if eventName.count == 0 || eventName.count > 30 {
            if eventName.count == 0 {
                invalidParameter(title: NSLocalizedString("Invalid name", comment: ""), message: NSLocalizedString("Please type an event name", comment: ""))
            } else {
                invalidParameter(title: NSLocalizedString("Invalid name", comment: ""), message: NSLocalizedString("Name is bigger then 30 characters", comment: ""))
            }
            return
        }
        
        let endDate = eventEndDatePicker.date
        let description = eventDescriptionTextField.text ?? ""
        let addCalendarEvent = !eventEndDatePicker.isHidden && calendarAppSwitch.isOn
        
        if let editedEvent = event {
            editedEvent.name = eventName
            editedEvent.description = description
            editedEvent.eventType = eventType
            if !addCalendarEvent && editedEvent.hasCalendarEvent {
                editedEvent.removeEvent()
            }
            DataStorage.updateEvent(event: editedEvent)
            self.navigationController?.popBackTo(viewController: EventDetailController.self)
            return
        }
        
        var dateOfEnd: Date? = nil
        if !eventEndDatePicker.isHidden {
            dateOfEnd = endDate
        }
        
        let petNames = pets.map({ $0.name })
        DataStorage.addEvent(event: Event(name: eventName, description: description, startDate: eventStartDatePicker.date, endDate: dateOfEnd, pets: petNames, addCalendarEvent: addCalendarEvent, eventType: eventType))
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func invalidParameter(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true)
        return
    }
    
    @IBAction func selectEventTypeButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        let dataSource: [String] = EventType.allCases.map( { $0.description } )
        let anchorView: AnchorView? = sender as? AnchorView
        let dropDown = DropDownInitializer.Initialize(dataSource: dataSource, anchorView: anchorView, width: self.view.frame.size.width, selectedRow: dataSource.firstIndex(of: eventType.description) ?? 0)
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in self.changeEventType(index: index) }
        dropDown.show()
    }
    
    private func setElementsForEditedEvent(editedEvent: Event) {
        eventNameTextField.text = editedEvent.name
        eventDescriptionTextField.text = editedEvent.description
        eventStartDatePicker.date = editedEvent.startDate
        if let endDate = editedEvent.endDate {
            eventEndDatePicker.date = endDate
            endDateSwitch.isOn = true
            setElementsByEndDateSwitch()
        } else {
            endDateSwitch.isOn = false
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
    
    private func changeEventType(index: Int) {
        eventType = EventType.allCases[index]
        eventTypeLabel.text = eventType.description
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
