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

protocol PetDetailChangeName {
    func changeName(newName: String)
}

protocol PetDetailChangeBirthday {
    func changeBirth(newBirth: Date)
}

class PetDetailController: UITableViewController, SelectPetDelegate, PetDetailChangeName, PetDetailChangeBirthday {
    var menu: SideMenuNavigationController?
    var pet: Pet?
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSpecies: UILabel!
    @IBOutlet weak var labelSex: UILabel!
    @IBOutlet weak var labelBirthday: UILabel!
    @IBOutlet weak var thrashButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuParametres()
        DataStorage.loadPets()
        DataStorage.loadVets()
        DataStorage.loadEvents()
        
        // to hide empty rows and it's lines
        //self.tableView.tableFooterView = UIView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let p = DataStorage.selectedPet {
            selectPet(pet: p)
        }
        
        if DataStorage.pets.count < 2 {
            thrashButton.isEnabled = false
        } else {
            thrashButton.isEnabled = true
        }
    }
    
    @IBAction func menuButtonItem(_ sender: UIBarButtonItem) {
        present(menu!, animated: true)
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
                if let date = pet?.birth {
                    addNewDateOfBirthController.date = date
                }
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
        DataStorage.selectedPet = pet
        labelName.text = pet.name
        labelSpecies.text = pet.species.description
        labelSex.text = pet.sex?.description ?? "-"
        profilePictureImageView.image = UIImage(named: pet.species.rawValue.lowercased())
        if pet.sex == Sex.female {
            profilePictureImageView.backgroundColor = UIColor(red: 255/255, green: 75/255, blue: 255/255, alpha: 1)
        } else {
            profilePictureImageView.backgroundColor = UIColor.link
        }

        changeBirth()
        self.tableView.allowsSelection = true
    }
    
    func changeName(newName: String) {
        if pet == nil {
            return
        }
        pet?.name = newName
        labelName.text = newName
        DataStorage.persistAndLoadAll()
    }
    
    func changeSpecies(newSpecies: Species) {
        pet?.species = newSpecies
        labelSpecies.text = newSpecies.description
        profilePictureImageView.image = UIImage(named: newSpecies.rawValue.lowercased())
        DataStorage.persistAndLoadAll()
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
        DataStorage.persistAndLoadAll()
    }
    
    func changeBirth(newBirth: Date) {
        pet?.birth = newBirth
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateLabelText = formatter.string(from: newBirth)
        labelBirthday.text = dateLabelText
        pet?.addBirthday()
        
        DataStorage.persistAndLoadAll()
    }
    
    func changeBirth() {
        guard let birth = pet?.birth else {
            labelBirthday.text = "-"
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateLabelText = formatter.string(from: birth)
        labelBirthday.text = dateLabelText
    }
    
    @IBAction func deletePetButtonClick(_ sender: Any) {
        if DataStorage.pets.count <= 1 {
            let alert = UIAlertController(title: "Sorry, your only pet cannot be deleted", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(title: NSLocalizedString("Delete pet?", comment: ""), message: NSLocalizedString("All events where this pet is only participant will be deleted", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: { _ in self.deletePet() }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func deletePet() {
        pet?.delete()
        if let p = DataStorage.selectedPet {
            selectPet(pet: p)
        }
        
        if DataStorage.pets.count < 2 {
            thrashButton.isEnabled = false
        } else {
            thrashButton.isEnabled = true
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
            let dropDown = initializeDropDown(indexPath: indexPath, data: Species.allCases.map { $0.description })
            if let species = pet?.species {
                dropDown.selectRow(species.index)
            }
            dropDown.selectionBackgroundColor = UIColor.lightGray
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in self.changeSpecies(newSpecies: Species.allCases[index])}
            dropDown.show()
        }
        
        if indexPath.row == 3 {
            let dropDown = initializeDropDown(indexPath: indexPath, data: Sex.allCases.map { $0.description })
            if let sex = pet?.sex {
                dropDown.selectRow(sex.index)
            }
            dropDown.selectionBackgroundColor = UIColor.lightGray
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in self.changeSex(newSex: Sex.allCases[index]) }
            dropDown.show()
        }
    }
}
