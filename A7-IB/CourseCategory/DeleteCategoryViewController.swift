//
//  DeleteCategoryViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData

class DeleteCategoryViewController: UIViewController {

    @IBOutlet weak var DelCategoryID: UITextField!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func handleDelete(_ sender: UIButton) {
        deleteCategory()
    }
    
    @objc func deleteCategory() {
        guard let toDeleteID = DelCategoryID.text, !toDeleteID.isEmpty,
              let DeleteID = Int32(toDeleteID) else {
            presentErrorAlert(message: "Enter an ID please")
            return
        }
        
        let courseFetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
        courseFetchRequest.predicate = NSPredicate(format: "courseCatID == %d", DeleteID)
        
        do {
            let courses = try managedObjectContext.fetch(courseFetchRequest)
            
            if !courses.isEmpty {
                let alertController = UIAlertController(title: "Warning", message: "Deleting this course category will also delete associated courses. Do you still want to proceed?", preferredStyle: .alert)
                
                // 'Yes' action
                alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
                    // Remove the course category and associated courses
                    let ccFetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
                    ccFetchRequest.predicate = NSPredicate(format: "courseCatID == %d", DeleteID)
                    
                    do {
                        let ccs = try self?.managedObjectContext.fetch(ccFetchRequest)
                        
                        if let cc = ccs?.first {
                            for course in courses {
                                self?.managedObjectContext.delete(course)
                            }
                            self?.managedObjectContext.delete(cc)
                            do {
                                try self?.managedObjectContext.save()
                                self?.presentSuccessAlert(message: "Course Category and associated courses deleted successfully.")
                            } catch {
                                // Handle the save error
                                self?.presentErrorAlert(message: "Error while saving changes: \(error)")
                            }
                        } else {
                            self?.presentErrorAlert(message: "Course Category not found.")
                        }
                    } catch {
                        // Handle the fetch error
                        self?.presentErrorAlert(message: "An error occurred while fetching data.")
                    }
                }))
                
                // 'Cancel' action
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                present(alertController, animated: true, completion: nil)
            } else {
                // No associated courses, delete only the course category
                let ccFetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
                ccFetchRequest.predicate = NSPredicate(format: "courseCatID == %d", toDeleteID)
                
                do {
                    let ccs = try managedObjectContext.fetch(ccFetchRequest)
                    
                    if let cc = ccs.first {
                        managedObjectContext.delete(cc)
                        
                        do {
                            try managedObjectContext.save()
                            presentSuccessAlert(message: "Course Category deleted successfully.")
                        } catch {
                            // Handle the save error
                            presentErrorAlert(message: "Error while saving changes: \(error)")
                        }
                    } else {
                        presentErrorAlert(message: "Course Category not found.")
                    }
                } catch {
                    // Handle the fetch error
                    presentErrorAlert(message: "An error occurred while fetching data.")
                }
            }
        } catch {
            // Handle the fetch error
            presentErrorAlert(message: "An error occurred while fetching data.")
        }
    }

    private func presentSuccessAlert(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Additional logic if needed after presenting the success alert
        }))
        self.present(alertController, animated: true, completion: nil)
    }

    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
