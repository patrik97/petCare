//
//  FoodController.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit
import SideMenu

class FoodController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SelectPetDelegate {
    var pet: Pet? = nil
    var menu: SideMenuNavigationController?
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var foodEventsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodEventsCollectionView.dataSource = self
        foodEventsCollectionView.delegate = self
        setSideMenuParametres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        pet = DataStorage.selectedPet
        petNameLabel.text = pet?.name ?? "Pet Name"
        foodEventsCollectionView.reloadData()
    }
    
    /**
    Sets parametres of SideMenu that is used to change pet-context
     */
    private func setSideMenuParametres() {
        let sideMenuController = SideMenuController()
        sideMenuController.selectPetDelegate = self
        menu = SideMenuNavigationController(rootViewController: sideMenuController)
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    func selectPet(pet: Pet) {
        self.pet = pet
        petNameLabel.text = pet.name
        foodEventsCollectionView.reloadData()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if  identifier == "AddFoodSegue" && DataStorage.pets.isEmpty {
            let alert = UIAlertController(title: "No pets avaliable!", message: "You have no pets. Add pet before vet visit.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
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
    
    @IBAction func sideMenuButtonClick(_ sender: Any) {
        present(menu!, animated: true)
    }
}

class FoodEventCell: UICollectionViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    
}
