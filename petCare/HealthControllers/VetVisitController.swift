//
//  VetVisitController.swift
//  petCare
//
//  Created by Patrik Pluhař on 11.04.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit
import SideMenu

protocol VetVisitDelegate {
    func removeVetVisit(vetVisit: VetVisit)
}

class VetVisitController: UIViewController, VetVisitDelegate {
    var menu: SideMenuNavigationController?
    var pet: Pet? = nil
    var filteredVisits = [VetVisit]()
    @IBOutlet weak var vetVisitsCollectionView: UICollectionView!
    @IBOutlet weak var vetVisitSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vetVisitsCollectionView.dataSource = self
        vetVisitsCollectionView.delegate = self
        vetVisitsCollectionView.keyboardDismissMode = .onDrag
        vetVisitSearchBar.delegate = self
        setSideMenuParametres()
        setCollectionViewLayout()
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
        vetVisitsCollectionView.reloadData()
    }
    
    private func reloadData() {
        if let text = vetVisitSearchBar.text {
            if text != "", let p = pet {
                filteredVisits = p.vetVisits.filter({ (visit) -> Bool in visit.vet.name.lowercased().contains(text.lowercased()) || visit.type.rawValue.lowercased().contains(text.lowercased()) })
            } else {
                filteredVisits = pet?.vetVisits ?? []
            }
        } else {
            filteredVisits = pet?.vetVisits ?? []
        }
        
        self.vetVisitsCollectionView.reloadData()
    }
    
    internal func removeVetVisit(vetVisit: VetVisit) {
        let alert = UIAlertController(title: "Remove " + vetVisit.type.rawValue.lowercased() + "?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
            vetVisit.delete()
            self.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        self.view.endEditing(true)
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
            if let index = vetVisitsCollectionView.indexPathsForSelectedItems?.first?.row {
                detailVetVisitController.currentVetVisit = filteredVisits[index]
            }
        }
        if segue.identifier == "CreateVetVisitSegue", let addVetVisitController = segue.destination as? AddVetVisitController {
            addVetVisitController.pet = pet
        }
    }
}

extension VetVisitController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredVisits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = vetVisitsCollectionView.dequeueReusableCell(withReuseIdentifier: "VetVisitCollectionViewCell", for: indexPath) as? VetVisitCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let vetVisit = filteredVisits[indexPath.row]
        cell.vetLabel.text = vetVisit.vet.name
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        cell.dateLabel.text = formatter.string(from: vetVisit.date)
        cell.typeLabel.text = vetVisit.type.rawValue
        cell.frequencyLabel.text = vetVisit.frequency.rawValue.lowercased() + " " + String(vetVisit.interval) + "x"
        
        var text: String
        if vetVisit.notes.count > 40 {
            let index = vetVisit.notes.index(vetVisit.notes.startIndex, offsetBy: 10)
            text = vetVisit.notes[..<index] + "..."
        } else {
            text = vetVisit.notes
        }
        
        cell.notesLabel.text = text
        cell.cornerRadius()
        cell.vetVisit = vetVisit
        cell.vetVisitDelegate = self
        return cell
    }
    
    /**
     Sets layout for collection view cells
     */
    private func setCollectionViewLayout() {
        let size = UIScreen.main.bounds.width - 30
        let cellSize = CGSize(width: size, height: 160)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        vetVisitsCollectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension VetVisitController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = vetVisitSearchBar.text {
            if text != "", let p = pet {
                filteredVisits = p.vetVisits.filter({ (visit) -> Bool in visit.vet.name.lowercased().contains(text.lowercased()) || visit.type.rawValue.lowercased().contains(text.lowercased()) })
            } else {
                filteredVisits = pet?.vetVisits ?? []
            }
        } else {
            filteredVisits = pet?.vetVisits ?? []
        }
        
        self.vetVisitsCollectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        vetVisitSearchBar.endEditing(true)
    }
}

extension VetVisitController: SelectPetDelegate {
    func selectPet(pet: Pet) {
        self.pet = pet
        filteredVisits = pet.vetVisits
        vetVisitSearchBar.text = nil
        vetVisitsCollectionView.reloadData()
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
        self.view.endEditing(true)
        present(menu!, animated: true)
    }
}

class VetVisitCollectionViewCell: UICollectionViewCell {
    var vetVisit: VetVisit? = nil
    var vetVisitDelegate: VetVisitDelegate?
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var vetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    
    @IBAction func deleteButtonClick(_ sender: Any) {
        if let visit = vetVisit {
            vetVisitDelegate?.removeVetVisit(vetVisit: visit)
        }
    }
}

extension UICollectionViewCell {
    /**
     Sets round corners to collection view cell
     */
    public func cornerRadius() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
}
