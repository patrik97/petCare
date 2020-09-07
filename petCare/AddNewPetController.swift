//
//  AddNewPetController.swift
//  petCare
//
//  Created by Patrik Pluhař on 18/08/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class AddNewPetController: UIViewController {
    let species = Species.allCases.map { $0.rawValue }
    var currentSpecies: Species = Species.dog
    @IBOutlet weak var speciesPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speciesPickerView.delegate = self
        speciesPickerView.dataSource = self
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Cancel without saving?", message: "It may cause loss data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in self.presentingViewController?.dismiss(animated: true, completion: nil) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in self.save() }))
        self.present(alert, animated: true)
    }
    
    func save() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension AddNewPetController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return species.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return species[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentSpecies = Species.allCases[row]
    }
}
