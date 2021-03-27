//
//  VetVisitsController.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class VetVisitsController: UITableViewController {
    @IBOutlet weak var vetVisitSearchBar: UISearchBar!
    var filteredVisits = DataStorage.vetVisits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        vetVisitSearchBar.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.link
        vetVisitSearchBar.searchTextField.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredVisits = DataStorage.vetVisits
        vetVisitSearchBar.text = nil
        tableView.reloadData()
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
            if let index = self.tableView.indexPathForSelectedRow?.first {
                detailVetVisitController.currentVetVisit = filteredVisits[index]
            }
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
            if text != "" {
            filteredVisits = DataStorage.vetVisits.filter({ (visit) -> Bool in visit.vet.name.lowercased().contains(text.lowercased()) })
            } else {
                filteredVisits = DataStorage.vetVisits
            }
        } else {
            filteredVisits = DataStorage.vetVisits
        }
        
        self.tableView.reloadData()
    }
}

class VetVisitCell: UITableViewCell {
    @IBOutlet weak var vetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
}
