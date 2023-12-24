//
//  AddCategoryViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class AddCategoryViewController: UIViewController {

    @IBOutlet weak var CategoryIDTxtField: UITextField!
    @IBOutlet weak var CategoryNameTxtField: UITextField!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var CategoryModel = [CategoryEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    private func clearFields(){
        CategoryIDTxtField.text = ""
        CategoryNameTxtField.text = ""
    }
    
    @IBAction func handleAdd(_ sender: UIButton) {
        addCategory()
    }
    
    @objc func addCategory() {
            guard let id = CategoryIDTxtField.text, !id.isEmpty,
                  let name = CategoryNameTxtField.text, !name.isEmpty,
                  let categoryID = Int32(id) else{
                presentErrorAlert(message: "All fields are required and ID must be integer")
                return
            }
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseCatID == %d", categoryID)
        
        do {
            let programs = try managedObjectContext.fetch(fetchRequest)
            if !programs.isEmpty {
                presentErrorAlert(message: "ID already exists.")
                return
            }
        } catch {
            print("Error \(error)")
        }
        let newEntry = CategoryEntity(context: self.managedObjectContext)
        newEntry.courseCatID = categoryID
        newEntry.courseCatName = name
        
        self.CategoryModel.append(newEntry)
        
        do {
            try managedObjectContext.save()
            presentSuccessAlert()
            clearFields()
        } catch {
            
        }
    }
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Course Category Added", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
