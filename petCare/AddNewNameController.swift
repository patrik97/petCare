//
//  AddNewNameController.swift
//  petCare
//
//  Created by Patrik Pluhař on 20/09/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class AddNewNameController: UIViewController {
    var pet: Pet?
    var petDetailChangeName: PetDetailChangeName?
    @IBOutlet weak var newNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let newName = newNameTextField.text ?? ""
        if newName != "" {
            petDetailChangeName?.changeName(newName: newNameTextField.text ?? "")
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Invalid name", message: "Name cannot be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
