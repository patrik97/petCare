//
//  FoodDetailController.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class FoodDetailController: UIViewController {
    var foodEvent: FoodEvent? = nil
    var pet: Pet? = nil
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var foodEventNameLabel: UILabel!
    @IBOutlet weak var foodEventDescriptionLabel: UILabel!
    @IBOutlet weak var foodEventDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        petNameLabel.text = pet?.name
        foodEventNameLabel.text = foodEvent?.eventName
        foodEventDescriptionLabel.text = foodEvent?.eventDescription
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        if let date = foodEvent?.dateAndTime {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .medium
            foodEventDateLabel.text = formatter.string(from: date)
        } else {
            foodEventDateLabel.text = ""
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditFoodSegue", let addFoodController = segue.destination as? AddFoodController {
            addFoodController.pet = pet
            addFoodController.event = foodEvent
        }
    }
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        guard let event = foodEvent else {
            return
        }
        // gets position of deleted item
        let index = pet?.foodEvents.firstIndex(where: { $0 == event })
        let alert = UIAlertController(title: "Delete event?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in self.removeEventAt(index: index) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func removeEventAt(index: Int?) {
        if let i = index {
            pet?.foodEvents.remove(at: i)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
