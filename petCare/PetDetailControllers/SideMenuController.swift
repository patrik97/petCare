//
//  SideMenuController.swift
//  petCare
//
//  Created by Patrik Pluhař on 12/09/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class SideMenuController: UITableViewController {
    var petDetailDelegate: PetDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.backgroundColor = UIColor(named: "BlueBackground")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.pets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pet = DataStorage.pets[indexPath.row]
        cell.textLabel?.text = pet.name
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.00)
        cell.imageView?.image = UIImage(named: pet.species.rawValue.lowercased())
        cell.backgroundColor = UIColor(named: "BlueBackground")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        petDetailDelegate?.selectPet(pet: DataStorage.pets[indexPath.row])
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
