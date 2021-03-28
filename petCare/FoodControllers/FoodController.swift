//
//  FoodController.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class FoodController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var pet: Pet? = nil
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var foodEventsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pet = DataStorage.selectedPet
        petNameLabel.text = pet?.name ?? "Pet Name"
        foodEventsCollectionView.dataSource = self
        foodEventsCollectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = foodEventsCollectionView.dequeueReusableCell(withReuseIdentifier: "FoodEventColectionViewCell", for: indexPath) as? FoodEventCell else {
            return UICollectionViewCell()
        }
        
        let event = pet?.foodEvents[indexPath.row]
        cell.eventNameLabel.text = event?.eventName
        cell.eventDescriptionLabel.text = event?.eventDescription
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pet?.foodEvents.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width / 2) - 8
        return CGSize(width: width, height: 130)
    }
}

class FoodEventCell: UICollectionViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
}
