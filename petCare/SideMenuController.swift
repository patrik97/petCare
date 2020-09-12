//
//  SideMenuController.swift
//  petCare
//
//  Created by Patrik Pluhař on 12/09/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

protocol SideMenuAddPetDelegate {
    func addPet(pet: Pet)
}

class SideMenuController: UITableViewController, SideMenuAddPetDelegate {
    var pets = [Pet]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pets[indexPath.row].name
        return cell
    }
    
    func addPet(pet: Pet) {
        pets.append(pet)
        self.tableView.reloadData()
    }
}
