//
//  AddNewPetController.swift
//  petCare
//
//  Created by Patrik Pluhař on 18/08/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class AddNewPetController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
