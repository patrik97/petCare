//
//  NewDescriptionController.swift
//  petCare
//
//  Created by Patrik Pluhař on 02.01.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class NewDescriptionController: UIViewController {
    var event: Event? = nil
    var newDescriptionDelegate: SetEventDescriptionProtocol? = nil
    @IBOutlet weak var newDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let description = event?.description {
            newDescriptionTextView.text = description
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        newDescriptionDelegate?.setDescription(description: newDescriptionTextView.text)
        self.navigationController?.popViewController(animated: true)
    }
}
