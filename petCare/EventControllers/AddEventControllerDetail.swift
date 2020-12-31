//
//  AddEventControllerDetail.swift
//  petCare
//
//  Created by Patrik Pluhař on 31.12.2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class AddEventControllerDetail: UIViewController {
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextField: UITextField!
    @IBOutlet weak var eventStartDatePicker: UIDatePicker!
    @IBOutlet weak var eventEndDatePicker: UIDatePicker!
    @IBOutlet weak var endDateAndTimeLabel: UILabel!
    @IBOutlet weak var eventEndDatePickerHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 14.0, *) {
            eventStartDatePicker.preferredDatePickerStyle = .inline
            eventEndDatePicker.preferredDatePickerStyle = .inline
        } else {
            eventStartDatePicker.preferredDatePickerStyle = .wheels
            eventEndDatePicker.preferredDatePickerStyle = .wheels
        }
    }
    @IBAction func selectEndDateSwitchValueChanged(_ sender: UISwitch) {
        eventEndDatePicker.isHidden = !sender.isOn
        endDateAndTimeLabel.isHidden = !sender.isOn
        if sender.isOn {
            eventEndDatePickerHeight.constant = 390
        } else {
            eventEndDatePickerHeight.constant = 0
        }
    }
}
