//
//  AddNewDateOfBirthController.swift
//  petCare
//
//  Created by Patrik Pluhař on 22/10/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit
import EventKit

class AddNewDateOfBirthController: UIViewController {
    var petDetailChangeBirthday: PetDetailChangeBirthday?
    var date: Date?
    @IBOutlet weak var BirthDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BirthDatePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            BirthDatePicker.preferredDatePickerStyle = .inline
        } else {
            BirthDatePicker.preferredDatePickerStyle = .wheels
        }
        
        if let d = date {
            BirthDatePicker.date = d
        }
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        let date = BirthDatePicker.date
        if date.isPastOrCurrentDate {
            if date != self.date {
                petDetailChangeBirthday?.changeBirth(newBirth: date)
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Invalid date", comment: ""), message: NSLocalizedString("Date must be today or before", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}

extension Date {
    var isPastOrCurrentDate: Bool {
        return self <= Date()
    }
}
