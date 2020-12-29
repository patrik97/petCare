//
//  AddNewDateOfBirthController.swift
//  petCare
//
//  Created by Patrik Pluhař on 22/10/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class AddNewDateOfBirthController: UIViewController {
    var petDetailChangeBirthday: PetDetailChangeBirthday?
    @IBOutlet weak var BirthDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BirthDatePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            BirthDatePicker.preferredDatePickerStyle = .inline
        } else {
            BirthDatePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        let date = BirthDatePicker.date
        if date.isPastOrCurrentDate {
            petDetailChangeBirthday?.changeBirth(newBirth: date)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Invalid date", message: "Date must be today or before", preferredStyle: .alert)
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
