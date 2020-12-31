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
        eventCollectionView.dataSource = self
        eventCollectionView.delegate = self
        setCollectionViewLayout()
        eventCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventCollectionView.reloadData()
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
        guard let cell = eventCollectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as? EventCell else {
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
        
        cell.pictureImageView.image = UIImage(named: event.pets[0].species.rawValue)
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
