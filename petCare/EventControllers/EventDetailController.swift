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
    @IBOutlet weak var textEndLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            endLabel.isHidden = true
            textEndLabel.isHidden = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditEventSegue", let editEventPetController = segue.destination as? AddEventControllerPet {
            editEventPetController.event = event
        }
        
        if segue.identifier == "EventPhotosSegue", let eventGalleryController = segue.destination as? EventGalleryController {
            eventGalleryController.event = event
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
