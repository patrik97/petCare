//
//  VetVisitsController.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit
import SideMenu

class VetVisitsController: UITableViewController, SelectPetDelegate {
    var menu: SideMenuNavigationController?
    var pet: Pet? = nil
    @IBOutlet weak var vetVisitSearchBar: UISearchBar!
    var filteredVisits = [VetVisit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        vetVisitSearchBar.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.link
        vetVisitSearchBar.searchTextField.backgroundColor = UIColor.white
        setSideMenuParametres()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pet = DataStorage.selectedPet
        if let p = pet {
            filteredVisits = p.vetVisits
        } else {
            filteredVisits = []
        }
        vetVisitSearchBar.text = nil
        tableView.reloadData()
    }
    
    func selectPet(pet: Pet) {
        self.pet = pet
        filteredVisits = pet.vetVisits
        vetVisitSearchBar.text = nil
        tableView.reloadData()
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
    
    @IBAction func sideMenuButtonClick(_ sender: Any) {
        present(menu!, animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if  identifier == "CreateVetVisitSegue" && DataStorage.pets.isEmpty {
            let alert = UIAlertController(title: "No pets avaliable!", message: "You have no pets. Add pet before vet visit.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VetVisitDetailSegue", let detailVetVisitController = segue.destination as? AddVetVisitController {
            detailVetVisitController.pet = pet
            if let index = self.tableView.indexPathForSelectedRow?.first {
                detailVetVisitController.currentVetVisit = filteredVisits[index]
            }
        }
        if segue.identifier == "CreateVetVisitSegue", let addVetVisitController = segue.destination as? AddVetVisitController {
            addVetVisitController.pet = pet
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredVisits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VetVisitCell", for: indexPath) as? VetVisitCell else {
            return UITableViewCell()
        }
        
        let vetVisit = filteredVisits[indexPath.row]
        cell.vetLabel.text = vetVisit.vet.name
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        cell.dateLabel.text = formatter.string(from: vetVisit.date)
        
        var text: String
        if vetVisit.notes.count > 40 {
            let index = vetVisit.notes.index(vetVisit.notes.startIndex, offsetBy: 10)
            text = vetVisit.notes[..<index] + "..."
        } else {
            text = vetVisit.notes
        }
        cell.notesLabel.text = text
        
        return cell
    }
}

extension VetVisitsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = vetVisitSearchBar.text {
            if text != "", let p = pet {
            filteredVisits = p.vetVisits.filter({ (visit) -> Bool in visit.vet.name.lowercased().contains(text.lowercased()) })
            } else {
                filteredVisits = pet?.vetVisits ?? []
            }
        } else {
            filteredVisits = pet?.vetVisits ?? []
        }
        
        self.tableView.reloadData()
    }
}

class VetVisitCell: UITableViewCell {
    @IBOutlet weak var vetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
}
