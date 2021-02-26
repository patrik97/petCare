//
//  PetMenuController.swift
//  petCare
//
//  Created by Patrik Pluhař on 19/09/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import DropDown
import SideMenu
import UIKit

protocol PetDetailDelegate {
    func selectPet(pet: Pet)
}

protocol PetDetailChangeName {
    func changeName(newName: String)
}

protocol PetDetailChangeBirthday {
    func changeBirth(newBirth: Date, createBirthdayEvent: Bool)
}

class PetDetailController: UITableViewController, PetDetailDelegate, PetDetailChangeName, PetDetailChangeBirthday {
    var menu: SideMenuNavigationController?
    var pet: Pet?
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSpecies: UILabel!
    @IBOutlet weak var labelSex: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuParametres()
        
        // to hide empty rows and it's lines
        self.tableView.tableFooterView = UIView()
        //self.view.backgroundColor = UIColor(red: 20/255, green: 175/255, blue: 255/255, alpha: 1)
        self.navigationController?.view.backgroundColor = UIColor(red: 20/255, green: 175/255, blue: 255/255, alpha: 1)
        
        if DataStorage.pets.count > 0 {
            pet = DataStorage.pets[0]
        } else {
            pet = nil
            self.tableView.allowsSelection = false
            labelName.text = "-"
            labelSpecies.text = "-"
            labelSex.text = "-"
            labelBirthday.text = "-"
        }
        
        /* need for overriding heightForRowAt in tableView that is needed
         * for correct size of top cell at small devices */
        self.tableView.reloadData()
    }
    
    @IBAction func menuButtonItem(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
    }
    
    /**
    Sets parametres of SideMenu that is used to change pet-context
     */
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
        
        if segue.identifier == "addNewDateOfBirthSegue", let addNewDateOfBirthController = segue.destination as? AddNewDateOfBirthController {
            if pet != nil {
                addNewDateOfBirthController.petDetailChangeBirthday = self
            }
        }
    }
    
    /**
     Creates DropDown and allows change pet data
     
     - Parameter indexPath: indexPath below which DropDown starts
     - Parameter data: data inside DropDown, currently Male/Female or species
     
     - Returns: DropDown instance with prepared data
     */
    func initializeDropDown(indexPath: IndexPath, data: [String]) -> DropDown {
        let dropDown = DropDown()
        dropDown.anchorView = tableView.cellForRow(at: IndexPath(row: indexPath.row+1, section: indexPath.section))
        dropDown.direction = .bottom
        dropDown.dataSource = data
        dropDown.cellHeight = 43.5
        dropDown.width = self.view.frame.size.width - 20
        dropDown.bottomOffset = CGPoint(x: 10, y: 0)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .center
            cell.optionLabel.font = UIFont(name: "System", size: 21)
        }
        return dropDown
    }
    
    /**
     Select Pet after creating new instance or selected by user in SideMenuController
     
     - Parameter pet: instance of Pet that will be selected in PetDetailController
     */
    func selectPet(pet: Pet) {
        self.pet = pet;
        labelName.text = pet.name
        labelSpecies.text = pet.species.description
        labelSex.text = pet.sex?.description ?? "-"
        profilePictureImageView.image = UIImage(named: pet.species.rawValue.lowercased())
        if pet.sex == Sex.female {
            profilePictureImageView.backgroundColor = UIColor(red: 255/255, green: 75/255, blue: 255/255, alpha: 1)
        } else {
            profilePictureImageView.backgroundColor = UIColor.link
        }
        if let birthday = pet.birth {
            changeBirth(newBirth: birthday)
        } else {
            labelBirthday.text = "-"
        }
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
        profilePictureImageView.image = UIImage(named: newSpecies.rawValue.lowercased())
    }
    
    func changeSex(newSex: Sex) {
        pet?.sex = newSex
        labelSex.text = newSex.description
        var color: UIColor
        if newSex == Sex.female {
            color = UIColor(red: 255/255, green: 75/255, blue: 255/255, alpha: 1)
        } else {
            color = UIColor.link
        }
        profilePictureImageView.backgroundColor = color
    }
    
    func changeBirth(newBirth: Date, createBirthdayEvent: Bool = false) {
        pet?.birth = newBirth
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateLabelText = formatter.string(from: newBirth)
        labelBirthday.text = dateLabelText
        
        if createBirthdayEvent {
            pet?.requestAccessAndCreateEvent(startDate: newBirth, endDate: newBirth)
        }
    }
}

/**
 Implements override UITableView methods
 */
extension PetDetailController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return view.safeAreaLayoutGuide.layoutFrame.height - 200
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        if indexPath.row == 2 {
            let dropDown = initializeDropDown(indexPath: indexPath, data: Species.allCases.map { $0.rawValue })
            if let species = pet?.species {
                dropDown.selectRow(species.index)
            }
            dropDown.selectionBackgroundColor = UIColor.blue
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in self.changeSpecies(newSpecies: Species.allCases[index])}
            dropDown.show()
        }
        
        if indexPath.row == 3 {
            let dropDown = initializeDropDown(indexPath: indexPath, data: Sex.allCases.map { $0.rawValue })
            if let sex = pet?.sex {
                dropDown.selectRow(sex.index)
            }
            dropDown.selectionBackgroundColor = UIColor.blue
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in self.changeSex(newSex: Sex.allCases[index]) }
            dropDown.show()
        }
    }
}
