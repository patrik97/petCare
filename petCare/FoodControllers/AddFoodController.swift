//
//  AddFoodController.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class AddFoodController: UIViewController, UITextFieldDelegate {
    var pet: Pet? = nil
    var event: FoodEvent? = nil
    @IBOutlet weak var characterLeftLabel: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventDateTimeDatePickerView: UIDatePicker!
    @IBOutlet weak var showDatePickerSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTextField.delegate = self
        eventDateTimeDatePickerView.preferredDatePickerStyle = .wheels
        if let e = event {
            characterLeftLabel.text = String(e.eventName.count) + "/10"
            eventNameTextField.text = e.eventName
            eventDescriptionTextView.text = e.eventDescription
            if let d = e.dateAndTime {
                showDatePickerSwitch.isOn = true
                eventDateTimeDatePickerView.date = d
            } else {
                showDatePickerSwitch.isOn = false
            }
        }
    }
    
    @IBAction func didChangeValueDateTime(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func didChangeValueSwitch(_ sender: Any) {
        self.view.endEditing(true)
        eventDateTimeDatePickerView.isHidden = !eventDateTimeDatePickerView.isHidden
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        if eventNameTextField.text == nil || eventNameTextField.text == "" {
            let alert = UIAlertController(title: NSLocalizedString("Empty name", comment: "Name is empty"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel the alert"), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if event != nil {
            createAlertAndUpdateFoodEvent()
        }
        else if eventDateTimeDatePickerView.isHidden {
            saveWithoutDateInCalendar()
        } else {
            addEventToCalendarAlert()
        }
    }
    
    private func createAlertAndUpdateFoodEvent() {
        if !showDatePickerSwitch.isOn {
            event?.update(eventName: eventNameTextField.text ?? "", eventDescription: eventDescriptionTextView.text ?? "")
            self.navigationController?.popBackTo(viewController: FoodController.self)
        } else {
            let eventName = eventNameTextField.text ?? ""
            let description = eventDescriptionTextView.text ?? ""
            let date = eventDateTimeDatePickerView.date
            let alert = UIAlertController(title: NSLocalizedString("Update event in iOS calendar", comment: ""), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { _ in self.updateFoodEvent(name: eventName, description: description, date: date, addCalendarItem: true) }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No and remove old", comment: ""), style: .destructive, handler: { _ in self.updateFoodEvent(name: eventName, description: description, date: date, addCalendarItem: false) }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel the alert"), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func updateFoodEvent(name: String, description: String, date: Date, addCalendarItem: Bool) {
        event?.update(eventName: name, eventDescription: description, dateAndTime: date, addCalendarItem: addCalendarItem)
        self.navigationController?.popBackTo(viewController: FoodController.self)
    }
    
    private func saveWithDateInCalendar() {
        DataStorage.selectedPet?.foodEvents.append(FoodEvent(eventName: eventNameTextField.text ?? "", eventDescription: eventDescriptionTextView.text ?? "", dateAndTime: eventDateTimeDatePickerView.date))
        DataStorage.persistAndLoadAll()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func saveWithoutDateInCalendar() {
        if eventDateTimeDatePickerView.isHidden {
            let foodEvent = FoodEvent(eventName: eventNameTextField.text ?? "", eventDescription: eventDescriptionTextView.text ?? "")
            DataStorage.selectedPet?.foodEvents.append(foodEvent)
            DataStorage.persistAndLoadAll()
        } else {
            let foodEvent = FoodEvent(eventName: eventNameTextField.text ?? "", eventDescription: eventDescriptionTextView.text ?? "")
            foodEvent.dateAndTime = eventDateTimeDatePickerView.date
            DataStorage.selectedPet?.foodEvents.append(foodEvent)
            DataStorage.persistAndLoadAll()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (eventNameTextField.text ?? "") as NSString
        let newText = text.replacingCharacters(in: range, with: string) as NSString
        if newText.length <= 10 {
            characterLeftLabel.text = String(newText.length) + "/10"
        } else {
            characterLeftLabel.text = "10/10"
        }
        return newText.length <= 10
    }
    
    /**
     Ask user whether they want save food event to iOS calendar and create FoodEvent object
     or stop saving and continue editing
     */
    private func addEventToCalendarAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Add event to iOS calendar?", comment: ""), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: { _ in self.saveWithDateInCalendar() }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default, handler: { _ in self.saveWithoutDateInCalendar() }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion:nil)
    }
}
