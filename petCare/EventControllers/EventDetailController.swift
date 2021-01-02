//
//  EventDetailController.swift
//  petCare
//
//  Created by Patrik Pluhař on 01.01.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

protocol SetEventDescriptionProtocol {
    func setDescription(description: String)
}

class EventDetailController: UIViewController, SetEventDescriptionProtocol {
    var event: Event? = nil
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var petsLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameLabel.text = event?.name
        petsLabel.text = event?.names()
        descriptionLabel.text = event?.description
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        startLabel.text = formatter.string(from: event?.startDate ?? Date())
        
        if let endDate = event?.endDate {
            endLabel.text = formatter.string(from: endDate)
        } else {
            endLabel.text = "/"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewDescriptionSegue", let newDescriptionController = segue.destination as? NewDescriptionController {
            newDescriptionController.event = event
            newDescriptionController.newDescriptionDelegate = self
        }
    }
    
    /**
     Change description including text in label
     
     - Parameter description: new description
     */
    func setDescription(description: String) {
        event?.description = description
        descriptionLabel.text = description
    }
}
