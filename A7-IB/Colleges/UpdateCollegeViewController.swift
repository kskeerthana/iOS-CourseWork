//
//  UpdateCollegeViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class UpdateCollegeViewController: UIViewController {

    @IBOutlet weak var updateViewLabel: UILabel!
    @IBOutlet weak var updateIDField: UITextField!
    @IBOutlet weak var updatableField: UILabel!
    @IBOutlet weak var updatableNameField: UITextField!
    @IBOutlet weak var updatableAddressField: UITextField!
    
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var originalCollegeId: String?
    var managedObject: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    private func clearFields(){
        updateIDField.text = ""
        updatableNameField.text = ""
        updatableAddressField.text = ""
    }
    

    @IBAction func onFindClick(_ sender: UIButton) {
        guard let collegeId = updateIDField.text, !collegeId.isEmpty else {
            presentErrorAlert(message: "Please enter college ID.")
            return
        }
        // Search for the college by ID in Core Data
        let fetchRequest: NSFetchRequest<CollegesEntity> = CollegesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "collegeID == %@", collegeId)
        
        do {
            let colleges = try managedObject.fetch(fetchRequest)
            
            if let college = colleges.first {
                updatableNameField.text = college.collegeName
                updatableAddressField.text = college.collegeAddress
                originalCollegeId = college.collegeID
                updateIDField.isEnabled = false
            } else {
                presentErrorAlert(message: "College doesn't exist.")
            }
        } catch {
            presentErrorAlert(message: "An error occurred while fetching data.")
        }
    }
    
    @IBAction func onUpdateClick(_ sender: UIButton) {
        let collegeId = updateIDField.text!
        guard let collegeName = updatableNameField.text, !collegeName.isEmpty,
              let collegeAddress = updatableAddressField.text, !collegeAddress.isEmpty else {
            presentErrorAlert(message: "Name and address cannot be empty.")
            return
        }

        let fetchRequest: NSFetchRequest<CollegesEntity> = CollegesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "collegeID == %@", collegeId)
        
        do {
            let colleges = try managedObject.fetch(fetchRequest)
            
            if let college = colleges.first {
                college.collegeName = collegeName
                college.collegeAddress = collegeAddress
                do {
                    try managedObject.save()
                    presentSuccessAlert()
                } catch {
                    presentErrorAlert(message: "An error occurred while updating the college.")
                }
            } else {
                presentErrorAlert(message: "College doesn't exist.")
            }
        } catch {
            presentErrorAlert(message: "An error occurred while fetching data.")
        }
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "College Updated", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}
