//
//  CreateCollegeViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/6/23.
//

import UIKit
import CoreData
class CreateCollegeViewController: UIViewController {

    
    @IBOutlet weak var AddCollegeTitle: UILabel!
    @IBOutlet weak var collegeIDTextField: UITextField!
    @IBOutlet weak var collegeNameTextField: UITextField!
    @IBOutlet weak var collegeAddressTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var managedObject: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var collegeModel = [CollegesEntity]()
    
    
    @IBAction func onAddClick(_ sender: UIButton) {
        addColleges()
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        dismiss(animated: true)
    }
    private func clearFields(){
        collegeIDTextField.text = ""
        collegeNameTextField.text = ""
        collegeAddressTextField.text = ""
    }
    @objc func addColleges(){
        guard let id = collegeIDTextField.text, !id.isEmpty,
              let name = collegeNameTextField.text, !name.isEmpty,
              let address = collegeAddressTextField.text, !address.isEmpty else {
            presentErrorAlert(message: "All fields are required.")
            return
        }
        if collegeWithIDExists(id: id) {
            presentErrorAlert(message: "College ID already exists.")
            return
        }
        
        let newEntry = CollegesEntity(context: self.managedObject)
        newEntry.collegeID = id
        newEntry.collegeName = name
        newEntry.collegeAddress = address
        
        self.collegeModel.append(newEntry)
        
        do {
            try managedObject.save()
            presentSuccessAlert()
        } catch {
            
        }
    }
    
    private func collegeWithIDExists(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<CollegesEntity> = CollegesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "collegeID == %@", id)
        
        do {
            let count = try managedObject.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "College Added", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadSavedData() {
        let fetchRequest: NSFetchRequest<CollegesEntity> = CollegesEntity.fetchRequest()
        let sortedOrder = NSSortDescriptor(key: "collegeName", ascending: false)
        fetchRequest.sortDescriptors = [sortedOrder]
        do {
            self.collegeModel = try (self.managedObject.fetch(fetchRequest)) as [CollegesEntity]
        } catch {
            fatalError("Failed to fetch Colleges")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSavedData()
    }
}
