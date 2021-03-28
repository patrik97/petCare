//
//  FoodController.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class FoodController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var pet: Pet? = nil
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var foodEventsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodEventsCollectionView.dataSource = self
        foodEventsCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pet = DataStorage.selectedPet
        petNameLabel.text = pet?.name ?? "Pet Name"
        foodEventsCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddFoodSegue", let addFoodController = segue.destination as? AddFoodController {
            addFoodController.pet = pet
        }
        if segue.identifier == "FoodEventDetailSegue", let foodDetailController = segue.destination as? FoodDetailController {
            foodDetailController.pet = pet
            if let p = pet {
                if !p.foodEvents.isEmpty {
                    let index = foodEventsCollectionView.indexPathsForSelectedItems?.first?.row ?? 0
                    foodDetailController.foodEvent = p.foodEvents[index]
                }
            }
        }
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
        let width = (UIScreen.main.bounds.width / 2) - 10
        return CGSize(width: width, height: 128.0)
    }
}

class FoodEventCell: UICollectionViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
}
