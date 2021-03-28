//
//  AddFoodController.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class AddFoodController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var characterLeftLabel: UILabel!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventDateTimeDatePickerView: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTextField.delegate = self
    }
    
    @IBAction func didChangeValueSwitch(_ sender: Any) {
        eventDateTimeDatePickerView.isHidden = !eventDateTimeDatePickerView.isHidden
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
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
     Ask user whether they want save food event to iOS calendar
     
     - Returns answer yes or no
     */
    private func addEventToCalendarAlert() -> Bool {
        return false
    }
}
