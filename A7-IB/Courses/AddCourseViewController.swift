//
//  AddCourseViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData

class AddCourseViewController: UIViewController {

    @IBOutlet weak var addCourseView: UILabel!
    
    
    @IBOutlet weak var courseIDField: UITextField!
    @IBOutlet weak var courseNameField: UITextField!
    @IBOutlet weak var programIDField: UITextField!
    @IBOutlet weak var courseCatIDField: UITextField!
    @IBOutlet weak var collegeIDField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func clearFields(){
        courseIDField.text = ""
        courseNameField.text = ""
        programIDField.text = ""
        courseCatIDField.text = ""
        collegeIDField.text = ""
    }
    
    @IBAction func handleAdd(_ sender: UIButton) {
        addCollege()
    }
    
    @objc func addCollege() {
        guard let cid = courseIDField.text, !cid.isEmpty,
          let cname = courseNameField.text, !cname.isEmpty,
          let pId = programIDField.text, !pId.isEmpty,
          let clgId = collegeIDField.text, !clgId.isEmpty, // This might be a typo as you're adding a course, not a college.
          let courseCatId = courseCatIDField.text, !courseCatId.isEmpty else {
        presentErrorAlert(message: "All fields are required.")
            return
        }
            
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            // Check if Course ID already exists
            let fetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "courseID == %@", cid)
            
            do {
                let courses = try context.fetch(fetchRequest)
                if !courses.isEmpty {
                    presentErrorAlert(message: "Course ID already exists.")
                    return
                }
            } catch {
                presentErrorAlert(message: "Error checking for existing Course ID.")
                return
            }
            
            // Check if Program ID exists and get college ID
            if let collegeID = getCollegeID(forProgram: pId) {
                let fetchCCRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
                fetchCCRequest.predicate = NSPredicate(format: "courseCatID == %@", courseCatId)
                
                do {
                    let courseCategories = try context.fetch(fetchCCRequest)
                    if let cc = courseCategories.first {
                        // Create a new Course entity and set its attributes
                        let newCourse = CourseEntity(context: context)
                        
                        if let ccIDInt = Int32(courseCatId) {
                            newCourse.courseCatID = ccIDInt
                            newCourse.courseID = cid
                            newCourse.courseName = cname
                            newCourse.programID = pId
                            newCourse.collegeID = clgId
                        } else {
                            presentErrorAlert(message: "Invalid Course Category ID. Please enter a valid integer.")
                            return
                        }
                        
                        do {
                            try context.save()
                            presentSuccessAlert()
                            clearFields()
                        } catch {
                            presentErrorAlert(message: "Error while saving Course data.")
                        }
                    } else {
                        presentErrorAlert(message: "The Course Category ID does not exist. Please check the Course Category ID value.")
                    }
                } catch {
                    presentErrorAlert(message: "Error checking for existing Course Category ID.")
                }
            } else {
                presentErrorAlert(message: "The college ID does not exist for this program. Please check the Program ID value.")
            }
        }
        
    }
    
    func getCollegeID(forProgram programID: String) -> String? {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "programID == %@", programID)
            
            do {
                let programs = try context.fetch(fetchRequest)
                if let program = programs.first {
                    return program.collegeID
                }
            } catch {
                print("Error fetching Program data: \(error)")
            }
        }
        return nil
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
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
