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
    @IBOutlet weak var mainPhotoLabel: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventNameLabel.text = event?.name
        petsLabel.text = event?.names()
        descriptionLabel.text = event?.description
        
        if let photoData = event?.mainPhoto {
            if let image = UIImage(data: photoData) {
                mainPhotoLabel.image = image
            }
        } else if let photos = event?.photos {
            if !photos.isEmpty {
                if let image = UIImage(data: photos[0]) {
                    mainPhotoLabel.image = image
                }
            }
        }
        
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
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Delete this event?", comment: ""), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { _ in self.deleteEvent() }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func deleteEvent() {
        guard let e = event else {
            return
        }
        
        e.removeEvent()
        DataStorage.events.removeAll(where: { $0.id == e.id })
        DataStorage.persistEvents()
        DataStorage.loadEvents()
        self.navigationController?.popViewController(animated: true)
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
