//
//  AddEventController.swift
//  petCare
//
//  Created by Patrik Pluhař on 31.12.2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class AddEventControllerPet: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "petCell", for: indexPath) as? PetCell else {
            return UITableViewCell()
        }
        
        let pet = DataStorage.pets[indexPath.row]
        cell.petNameLabel.text = pet.name
        cell.petImageView.image = UIImage(named: pet.species.rawValue)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.pets.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor(red: 255/255, green: 75/255, blue: 255/255, alpha: 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.link
        }
    }
}

class PetCell: UITableViewCell {
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petImageView: UIImageView!
}
