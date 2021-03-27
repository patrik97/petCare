//
//  AddVetVisitController.swift
//  petCare
//
//  Created by Patrik Pluhař on 07.03.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class AddVetVisitController: UIViewController {
    @IBOutlet weak var vetLabel: UILabel!
    @IBOutlet weak var vetsPickerView: UIPickerView!
    @IBOutlet weak var visitDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextField: UITextField!
    private var selectedVet: Vet? = nil
    var currentVetVisit: VetVisit? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vetsPickerView.delegate = self
        vetsPickerView.dataSource = self
        notesTextField.delegate = self
        if !DataStorage.vets.isEmpty {
            vetsPickerView.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if DataStorage.vets.isEmpty {
            vetLabel.text = "No vet available."
        } else {
            vetLabel.text = "Vet"
        }
        if let vetVisit = currentVetVisit {
            let vet = DataStorage.vets.first(where: { $0 == vetVisit.vet })
            let vetIndex = DataStorage.vets.firstIndex(of: vet ?? Vet(name: ""))
            selectedVet = DataStorage.vets[vetIndex ?? 0]
            vetsPickerView.selectRow(vetIndex ?? 0, inComponent: 0, animated: true)
            visitDatePicker.setDate(vetVisit.date, animated: true)
            notesTextField.text = vetVisit.notes
        }
    }
    
    @IBAction func saveButtonClick(_ sender: Any) {
        let notes: String = notesTextField.text ?? ""
        let date = visitDatePicker.date
        guard let vet = selectedVet else {
            alertHandler()
            return
        }
        let vetVisit = VetVisit(date: date, vet: vet)
        vetVisit.notes = notes
        if (currentVetVisit == nil) {
            DataStorage.vetVisits.append(vetVisit)
        } else {
            let currentVet = DataStorage.vetVisits.first(where: { $0 == currentVetVisit })
            if let current = currentVet {
                let vetIndex = DataStorage.vetVisits.firstIndex(of: current)
                if let index = vetIndex {
                    DataStorage.vetVisits[index] = vetVisit
                }
            }
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
            DataStorage.vets.append(Vet(name: name))
            self.vetsPickerView.reloadAllComponents()
            self.vetsPickerView.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(self.vetsPickerView, didSelectRow: 0, inComponent: 0)
            if self.vetLabel.text != "Vet" {
                self.vetLabel.text = "Vet"
            }
        }}))
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddVetVisitController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataStorage.vets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DataStorage.vets[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVet = DataStorage.vets[row]
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
