//
//  DeleteCollegeViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class DeleteCollegeViewController: UIViewController {

    @IBOutlet weak var deleteViewLabel: UILabel!
    @IBOutlet weak var deleteIDTextField: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var originalCollegeId: String?
    var managedObject: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onDeleteClick(_ sender: UIButton) {
        deleteCollege()
    }
    
    @IBAction func backBtnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteCollege(){
        guard let toDeleteID = deleteIDTextField.text, !toDeleteID.isEmpty else {
            presentErrorAlert(message: "Please enter ID")
            return
        }
        
        // Check for associated programs
        let programFetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
        programFetchRequest.predicate = NSPredicate(format: "collegeID == %@", toDeleteID)
        let courseFetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
        courseFetchRequest.predicate = NSPredicate(format: "collegeID == %@", toDeleteID)

        do {
            let programs = try managedObject.fetch(programFetchRequest)
            let courses = try managedObject.fetch(courseFetchRequest)
            if !programs.isEmpty || !courses.isEmpty{
                    // There are associated programs, so ask for confirmation
                    let confirmationAlert = UIAlertController(title: "Warning", message: "There are associated programs, courses. Do you still want to proceed with deletion?", preferredStyle: .alert)
                    
                    confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                        self.deleteAssociatedPrograms(toDeleteID)
                        self.deleteAssociatedCourses(toDeleteID)
                        self.deleteClgByID(toDeleteID)
                        self.presentSuccessAlert()
                    }))
                    confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    
                    present(confirmationAlert, animated: true, completion: nil)
                } else {
                    deleteClgByID(toDeleteID)
                    presentSuccessAlert()
                }
        } catch {
            // Handle the fetch error
        }
        
    }
    
    func deleteClgByID(_ collegeID: String) {
        let fetchRequest: NSFetchRequest<CollegesEntity> = CollegesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "collegeID == %@", collegeID)

        do {
            let colleges = try managedObject.fetch(fetchRequest)
            
            if let collegeToDelete = colleges.first {
                managedObject.delete(collegeToDelete)
                do {
                    try managedObject.save()
                    print("College deleted successfully.")
                } catch {
                    print("Error while saving: \(error)")
                }
            } else {
                print("College not found.")
            }
        } catch {
            print("Error while fetching: \(error)")
        }
    }
    func deleteAssociatedPrograms(_ collegeID: String) {
        let fetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "collegeID == %@", collegeID)

        do {
            let colleges = try managedObject.fetch(fetchRequest)
            
            if let prgmToDelete = colleges.first {
                managedObject.delete(prgmToDelete)
                do {
                    try managedObject.save()
                } catch {
                    print("Error while saving while deleting programs : \(error)")
                }
            } else {
                print("Not found")
            }
        } catch {
            print("Error while fetching: \(error)")
        }
    }
    func deleteAssociatedCourses(_ collegeID: String) {
        let fetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "collegeID == %@", collegeID)

        do {
            let colleges = try managedObject.fetch(fetchRequest)
            
            if let courseToDelete = colleges.first {
                managedObject.delete(courseToDelete)
                do {
                    try managedObject.save()
                } catch {
                    print("Error while saving while deleting courses : \(error)")
                }
            } else {
                print("Not found")
            }
        } catch {
            print("Error while fetching: \(error)")
        }
    }
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "College Deleted", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

    

}
