//
//  UpdateCategoryViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class UpdateCategoryViewController: UIViewController {

    @IBOutlet weak var UpdateCategoryID: UITextField!
    @IBOutlet weak var UpdateCategoryName: UITextField!
    
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var originalCollegeId: String?
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    private func clearFields(){
        UpdateCategoryID.text = ""
        UpdateCategoryName.text = ""
    }
    
    @IBAction func handleFind(_ sender: UIButton) {
        guard let ccID = UpdateCategoryID.text, !ccID.isEmpty,
            let categoryID = Int32(ccID) else{
            presentErrorAlert(message: "Please enter a course category ID.")
            return
        }

        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseCatID == %d", categoryID)

        do {
            let ccs = try managedObjectContext.fetch(fetchRequest)

            if let cc = ccs.first {
                UpdateCategoryName.text = cc.courseCatName
                UpdateCategoryID.isEnabled = false
            } else {
                presentErrorAlert(message: "Course Category doesn't exist.")
            }
        } catch {
            presentErrorAlert(message: "An error occurred while fetching data.")
        }
    }
    
    @IBAction func handleUpdate(_ sender: UIButton) {
        updateProgram()
    }
    
    @objc func updateProgram() {
        
        guard let ccID = UpdateCategoryID.text, !ccID.isEmpty,
              let categoryID = Int32(ccID),
            let categoryName = UpdateCategoryName.text, !categoryName.isEmpty else {
            presentErrorAlert(message: "Name cannot be empty.")
            return
        }

        // Fetch the course category by ID in Core Data
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseCatID == %d", categoryID)

        do {
            let ccs = try managedObjectContext.fetch(fetchRequest)

            if let cc = ccs.first {
                // Update the CC in Core Data
                print("looping through categories",cc)
                cc.courseCatName = categoryName

                do {
                    try managedObjectContext.save()
                    presentSuccessAlert()
                    clearFields()
                } catch {
                    // Handle the save error
                    print("Error while saving: \(error)")
                }
            } else {
                print("looping through categories",ccs.first ?? "")
                presentErrorAlert(message: "Course Category doesn't exist.")
            }
        } catch {
            presentErrorAlert(message: "An error occurred while fetching data.")
        }
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Course Category Updated", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}
