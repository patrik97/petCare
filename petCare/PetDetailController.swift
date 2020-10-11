//
//  PetMenuController.swift
//  petCare
//
//  Created by Patrik Pluhař on 19/09/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import SideMenu
import UIKit

protocol PetDetailDelegate {
    func selectPet(pet: Pet)
}

protocol PetDetailChangeName {
    func changeName(newName: String)
}

protocol PetDetailChangeSpecies {
    func changeSpecies(newSpecies: Species)
}

class PeDetailController: UITableViewController, PetDetailDelegate, PetDetailChangeName, PetDetailChangeSpecies {
    var menu: SideMenuNavigationController?
    var pet: Pet?
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSpecies: UILabel!
    @IBOutlet weak var labelSex: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuParametres()
        if DataStorage.pets.count > 0 {
            pet = DataStorage.pets[0]
        } else {
            pet = nil
            self.tableView.allowsSelection = false
        }
    }
    
    @IBAction func menuButtonItem(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    
    private func setSideMenuParametres() {
        let sideMenuController = SideMenuController()
        sideMenuController.petDetailDelegate = self
        menu = SideMenuNavigationController(rootViewController: sideMenuController)
        menu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewPetSegue", let addNewPetController = segue.destination as? AddNewPetController {
            addNewPetController.petDetailDelegate = self
        }
        
        if segue.identifier == "addNewNameSegue", let addNewNameController = segue.destination as? AddNewNameController {
            if pet != nil {
                addNewNameController.petDetailChangeName = self
            }
        }
        
        if segue.identifier == "changeSpeciesSegue", let changeSpeciesSegueController = segue.destination as? ChangeSpeciesController {
            changeSpeciesSegueController.currentPet = pet
            changeSpeciesSegueController.changeSpeciesDelegate = self
        }
    }
    
    func selectPet(pet: Pet) {
        self.pet = pet;
        labelName.text = pet.name
        labelSpecies.text = pet.species.description
        self.tableView.allowsSelection = true
    }
    
    func changeName(newName: String) {
        if pet == nil {
            return
        }
        pet?.name = newName
        labelName.text = newName
    }
    
    func changeSpecies(newSpecies: Species) {
        pet?.species = newSpecies
        labelSpecies.text = newSpecies.description
    }
}
