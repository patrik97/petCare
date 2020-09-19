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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStorage.pets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = DataStorage.pets[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        petDetailDelegate?.selectPet(pet: DataStorage.pets[indexPath.row])
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
