//
//  DeleteProgramViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData

class DeleteProgramViewController: UIViewController {

    @IBOutlet weak var deleteViewLabel: UILabel!
    @IBOutlet weak var deleteProgramIDField: UITextField!
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var originalCollegeId: String?
    var managedObject: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func clearFields(){
        deleteProgramIDField.text = ""
    }
    
    @IBAction func handleDelete(_ sender: UIButton) {
        deleteProgram()
    }
    
    @objc func deleteProgram() {
        guard let toDeleteID = deleteProgramIDField.text, !toDeleteID.isEmpty else {
            presentErrorAlert(message: "Enter an ID please")
            return
        }
        
        let courseFetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
        courseFetchRequest.predicate = NSPredicate(format: "programID == %@", toDeleteID)

        do {
            let courses = try managedObject.fetch(courseFetchRequest)
                if !courses.isEmpty{
                    // There are associated programs, so ask for confirmation
                    let confirmationAlert = UIAlertController(title: "Warning", message: "Program has associated courses. Do you want to proceed?", preferredStyle: .alert)
                    
                    confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                        self.deleteProgramWithID(toDeleteID)
                        self.deleteAssociatedCourses(toDeleteID)
                        self.presentSuccessAlert()
                        self.clearFields()
                    }))
                    confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    present(confirmationAlert, animated: true, completion: nil)
                } else {
                    print("in else")
                    let confirmationAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete?", preferredStyle: .alert)
                    confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                        self.deleteProgramWithID(toDeleteID)
//                        self.deleteAssociatedCourses(toDeleteID)
                        self.presentSuccessAlert()
                        self.clearFields()
                    }))
//                    deleteProgramWithID(toDeleteID)
//                    presentSuccessAlert()
                    confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    present(confirmationAlert, animated: true, completion: nil)
                }
        } catch {
            // Handle the fetch error
        }
    }
    
    func deleteProgramWithID(_ programID: String) {
        let fetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "programID == %@", programID)

        do {
            let prgms = try managedObject.fetch(fetchRequest)
            
            if let programToDelete = prgms.first {
                managedObject.delete(programToDelete)
                do {
                    try managedObject.save()
                    print("Program deleted successfully.")
                } catch {
                    print("Error while saving: \(error)")
                }
            } else {
                print("Program not found.")
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

    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Program Deleted", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
