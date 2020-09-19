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

class PeDetailController: UITableViewController, PetDetailDelegate {
    var menu: SideMenuNavigationController?
    var pet: Pet?
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSpecies: UILabel!
    @IBOutlet weak var labelSex: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuParametres()
        if (DataStorage.pets.count > 0) {
            pet = DataStorage.pets[0]
        } else {
            pet = nil
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
    
    func selectPet(pet: Pet) {
        self.pet = pet;
        labelName.text = pet.name
        labelSpecies.text = pet.species.description
    }
}
