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
    var petDetailDelegate: SelectPetDelegate?
    @IBOutlet weak var speciesPickerView: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speciesPickerView.delegate = self
        speciesPickerView.dataSource = self
    }
    

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        save()
    }
    
    func save() {
        if nameTextField.text?.count == 0 || nameTextField.text?.count ?? 0 > 30 {
            let alert = UIAlertController(title: "Incorrect name", message: "Name length is minimum 1 and maximum 20 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        if let name = nameTextField.text {
            if DataStorage.pets.contains(where: { $0.name == name }) {
                let alert = UIAlertController(title: "Pet with this name already exists", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                return
            }
        }
        
        let newPet = Pet(name: nameTextField.text ?? "invalid name", species: currentSpecies)
        DataStorage.addPet(pet: newPet)
        petDetailDelegate?.selectPet(pet: newPet)
        self.navigationController?.popViewController(animated: true)
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
