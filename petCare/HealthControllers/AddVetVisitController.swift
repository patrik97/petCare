//
//  AddVetVisitController.swift
//  petCare
//
//  Created by Patrik Pluhař on 07.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit
import DropDown

class AddVetVisitController: UIViewController {
    @IBOutlet weak var vetLabel: UILabel!
    @IBOutlet weak var visitDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextField: UITextField!
    private var selectedVet: Vet? = nil
    var currentVetVisit: VetVisit? = nil
    var pet: Pet? = nil
    @IBOutlet weak var repeatSlider: UISlider!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var repeatFrequencyLabel: UILabel!
    var vetVisitFrequency = VetVisitFrequency.Yearly
    var vetVisitType = VetVisitType.Examination
    @IBOutlet weak var vetVisitTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DataStorage.vets.isEmpty {
            vetLabel.text = "No vet available."
        } else {
            vetLabel.text = "Vet: " + DataStorage.vets[0].name
            selectedVet = DataStorage.vets[0]
        }
        if let vetVisit = currentVetVisit {
            let vet = DataStorage.vets.first(where: { $0 == vetVisit.vet })
            let vetIndex = DataStorage.vets.firstIndex(of: vet ?? Vet(name: ""))
            selectedVet = DataStorage.vets[vetIndex ?? 0]
            visitDatePicker.setDate(vetVisit.date, animated: true)
            notesTextField.text = vetVisit.notes
            vetVisitType = vetVisit.type
            vetVisitTypeLabel.text = vetVisit.type.rawValue
            repeatSlider.value = Float(vetVisit.interval)
            repeatLabel.text = String(Int(repeatSlider.value)) + "x"
            vetVisitFrequency = vetVisit.frequency
            repeatFrequencyLabel.text = vetVisitFrequency.rawValue
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func notesEditingDidEnd(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func notesDidEndOnExit(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func selectVetButtonClick(_ sender: Any) {
        guard let vet = selectedVet else {
            return
        }
        let anchorView: AnchorView? = sender as? AnchorView
        let dropDown = DropDownInitializer.Initialize(dataSource: DataStorage.vets.map({ $0.name }), anchorView: anchorView, width: self.view.frame.size.width, selectedRow: DataStorage.vets.firstIndex(of: vet) ?? 0)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in self.selectVet(vet: DataStorage.vets[index]) }
        dropDown.show()
    }
    
    private func selectVet(vet: Vet) {
        selectedVet = vet
        vetLabel.text = "Vet: " + vet.name
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        let notes: String = notesTextField.text ?? ""
        let date = visitDatePicker.date
        guard let vet = selectedVet else {
            alertHandler()
            return
        }
        let vetVisit = VetVisit(date: date, vet: vet, notes: notes, type: vetVisitType, frequency: vetVisitFrequency, interval: Int(repeatSlider.value))
        if (currentVetVisit == nil) {
            pet?.vetVisits.append(vetVisit)
        } else {
            currentVetVisit?.update(date: date, vet: vet, notes: notes, type: vetVisitType, frequency: vetVisitFrequency, interval: Int(repeatSlider.value))
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     Call alert to inform user there is no vet selected
     */
    private func alertHandler() {
        let alert = UIAlertController(title: "No vet selected", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func newVetButtonClick(_ sender: Any) {
        let alert = UIAlertController(title: "Insert New Vet", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: {textField in textField.placeholder = "Name"})
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in if let name = alert.textFields?.first?.text {
            let newVet = Vet(name: name)
            DataStorage.addVet(vet: newVet)
            self.selectedVet = newVet
            self.vetLabel.text = "Vet: " + newVet.name
        }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectRepeatingButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        let dataSource = VetVisitFrequency.allTypesString()
        let anchorView: AnchorView? = sender as? AnchorView
        let dropDown = DropDownInitializer.Initialize(dataSource: dataSource, anchorView: anchorView, width: self.view.frame.size.width, selectedRow: dataSource.firstIndex(of: repeatFrequencyLabel.text ?? "") ?? 0)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in self.changeFrequency(index: index) }
        dropDown.show()
    }
    
    private func changeFrequency(index: Int) {
        vetVisitFrequency = VetVisitFrequency.allCases[index]
        repeatFrequencyLabel.text = vetVisitFrequency.rawValue
    }
    
    @IBAction func sliderChangedValue(_ sender: Any) {
        self.view.endEditing(true)
        repeatLabel.text = String(Int(repeatSlider.value)) + "x"
    }
    
    @IBAction func selectTypeButtonClick(_ sender: Any) {
        self.view.endEditing(true)
        let dataSource = VetVisitType.allTypesString()
        let anchorView: AnchorView? = sender as? AnchorView
        let dropDown = DropDownInitializer.Initialize(dataSource: dataSource, anchorView: anchorView, width: self.view.frame.size.width, selectedRow: dataSource.firstIndex(of: vetVisitTypeLabel.text ?? "") ?? 0)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in self.changeVetVisitType(index: index) }
        dropDown.show()
    }
    
    private func changeVetVisitType(index: Int) {
        vetVisitType = VetVisitType.allCases[index]
        vetVisitTypeLabel.text = VetVisitType.allTypesString()[index]
    }
}

extension AddVetVisitController: UITextFieldDelegate {
    /* not allow notes to be longer then 40 characters */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (notesTextField.text ?? "") as NSString
        let newText = text.replacingCharacters(in: range, with: string) as NSString
        return newText.length <= 40
    }
}
