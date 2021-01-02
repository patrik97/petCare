//
//  AddEventController.swift
//  petCare
//
//  Created by Patrik Pluhař on 31.12.2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class AddEventControllerPet: UITableViewController {
    private var selectedIndicies: [IndexPath] = []
    private var selectInViewWillAppear = true
    private var pets: [Pet] = []
    var event: Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let realEvent = event {
            pets = realEvent.pets
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectInViewWillAppear {
            for index in selectedIndicies {
                tableView.selectRow(at: index, animated: false, scrollPosition: .none)
            }
        }
        selectInViewWillAppear = false
        selectedIndicies = []
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath) as? PetCell else {
            return UITableViewCell()
        }
        
        let pet = DataStorage.pets[indexPath.row]
        cell.petNameLabel.text = pet.name
        cell.petImageView.image = UIImage(named: pet.species.rawValue)
        cell.selectionStyle = .none
        if pets.contains(where: { $0 === pet }) {
            selectedIndicies.append(indexPath)
            cell.contentView.backgroundColor = UIColor(red: 255/255, green: 75/255, blue: 255/255, alpha: 1)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.pets.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pets.append(DataStorage.pets[indexPath.row])
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(red: 255/255, green: 75/255, blue: 255/255, alpha: 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        pets.removeAll(where: { $0 === DataStorage.pets[indexPath.row] })
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(named: "BlueBackground")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "AddEventDetailSegue" && pets.isEmpty {
            let alert = UIAlertController(title: "No pet selected", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEventDetailSegue", let addEventControllerDetail = segue.destination as? AddEventControllerDetail {
            addEventControllerDetail.pets = pets
            addEventControllerDetail.event = event
            addEventControllerDetail.addEventControllerPet = self
        }
    }
}

class PetCell: UITableViewCell {
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
}
