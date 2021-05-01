//
//  EventsController.swift
//  petCare
//
//  Created by Patrik Pluhař on 30.12.2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class EventsController: UIViewController {
    @IBOutlet weak var eventCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventCollectionView.allowsSelection = true
        eventCollectionView.allowsMultipleSelection = false
        eventCollectionView.dataSource = self
        eventCollectionView.delegate = self
        setCollectionViewLayout()
        eventCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        eventCollectionView.reloadData()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if  identifier == "CreateEventSegue" && DataStorage.pets.isEmpty {
            let alert = UIAlertController(title: "No pets avaliable!", message: "You have no pets. Add pet before creating an event.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EventDetailSegue", let eventDetailController = segue.destination as? EventDetailController {
            eventDetailController.event = DataStorage.events[eventCollectionView.indexPathsForSelectedItems?.first?.row ?? 0]
        }
    }
    
    /**
     Sets layout for collection view cells
     */
    private func setCollectionViewLayout() {
        let size = UIScreen.main.bounds.width - 30
        let cellSize = CGSize(width: size, height: 160)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        eventCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension EventsController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DataStorage.events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = eventCollectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }
        
        let event = DataStorage.events[indexPath.row]
        cell.eventNameLabel.text = event.name
        cell.petsLabel.text = event.names()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        cell.startDateLabel.text = formatter.string(from: event.startDate)
        if let endDate = event.endDate {
            cell.endDateLabel.text = formatter.string(from: endDate)
        } else {
            cell.endDateLabel.text = ""
        }
        
        let imageSpecies = DataStorage.pets.first(where: { $0.name == event.pets[0] })?.species ?? Species.other
        cell.pictureImageView.image = UIImage(named: imageSpecies.rawValue.lowercased())
        cell.cornerRadius()
        return cell
    }
}

class EventCell: UICollectionViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var petsLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
}
