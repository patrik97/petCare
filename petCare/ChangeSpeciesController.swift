//
//  ChangeSpeciesController.swift
//  petCare
//
//  Created by Patrik Pluhař on 20/09/2020.
//  Copyright © 2020 FI MU. All rights reserved.
//

import UIKit

class ChangeSpeciesController: UIViewController {
    let species = Species.allCases
    var currentPet: Pet?
    @IBOutlet weak var speciesTableView: UITableView!
    @IBOutlet weak var visibleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1, alpha: 0)
        speciesTableView.delegate = self
        speciesTableView.dataSource = self
    }
}

extension ChangeSpeciesController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        species.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "speciesCell", for: indexPath) as? SpeciesCell else {
            return UITableViewCell()
        }
        cell.labelSpecies.text = species[indexPath.row].description
        if species[indexPath.row] == currentPet?.species {
            cell.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
            cell.labelSpecies.textColor = UIColor.white
        }
        
        return cell
    }
}

class SpeciesCell: UITableViewCell {
    @IBOutlet weak var labelSpecies: UILabel!
}
