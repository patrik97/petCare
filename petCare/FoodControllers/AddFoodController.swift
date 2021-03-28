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
    @IBOutlet weak var characterLeftLabel: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventDateTimeDatePickerView: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTextField.delegate = self
        eventDateTimeDatePickerView.preferredDatePickerStyle = .wheels
    }
    
    @IBAction func didChangeValueSwitch(_ sender: Any) {
        eventDateTimeDatePickerView.isHidden = !eventDateTimeDatePickerView.isHidden
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        if eventDateTimeDatePickerView.isHidden {
            saveWithoutDateInCalendar()
        } else {
            addEventToCalendarAlert()
        }
    }
    
    private func saveWithDateInCalendar() {
        pet?.foodEvents.append(FoodEvent(eventName: eventNameTextField.text ?? "", eventDescription: eventDescriptionTextView.text ?? "", dateAndTime: eventDateTimeDatePickerView.date))
        self.navigationController?.popViewController(animated: true)
    }
    
    private func saveWithoutDateInCalendar() {
        if eventDateTimeDatePickerView.isHidden {
            let foodEvent = FoodEvent(eventName: eventNameTextField.text ?? "", eventDescription: eventDescriptionTextView.text ?? "")
            pet?.foodEvents.append(foodEvent)
        } else {
            let foodEvent = FoodEvent(eventName: eventNameTextField.text ?? "", eventDescription: eventDescriptionTextView.text ?? "")
            foodEvent.dateAndTime = eventDateTimeDatePickerView.date
            pet?.foodEvents.append(foodEvent)
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
        let alert = UIAlertController(title: "Add event to iOS calendar?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in self.saveWithDateInCalendar() }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { _ in self.saveWithoutDateInCalendar() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion:nil)
    }
}
