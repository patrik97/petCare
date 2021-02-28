//
//  VetVisitsController.swift
//  petCare
//
//  Created by Patrik Pluhař on 28.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class VetVisitsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DataStorage.vetVisits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VetVisitCell", for: indexPath) as? VetVisitCell else {
            return UITableViewCell()
        }
        
        let vetVisit = DataStorage.vetVisits[indexPath.row]
        cell.vetLabel.text = vetVisit.vet?.name ?? ""
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        cell.dateLabel.text = formatter.string(from: vetVisit.date)
        
        var text: String
        if vetVisit.notes.count > 13 {
            let index = vetVisit.notes.index(vetVisit.notes.startIndex, offsetBy: 10)
            text = vetVisit.notes[..<index] + "..."
        } else {
            text = vetVisit.notes
        }
        cell.notesLabel.text = text
        
        return cell
    }
}

class VetVisitCell: UITableViewCell {
    @IBOutlet weak var vetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
}
