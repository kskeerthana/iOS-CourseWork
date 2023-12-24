//
//  UpdateViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData

class UpdateCourseViewController: UIViewController {

    @IBOutlet weak var updateCourseID: UITextField!
    @IBOutlet weak var updateCourseName: UITextField!
    @IBOutlet weak var updateProgramID: UITextField!
    @IBOutlet weak var updateCollegeID: UITextField!
    @IBOutlet weak var updateCourseCatID: UITextField!
    
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleFind(_ sender: UIButton) {
        guard let courseId = updateCourseID.text, !courseId.isEmpty else {
                presentErrorAlert(message: "Please enter a course ID.")
                return
            }
        if let course = fetchCourse(withID: courseId) {
                // Populate fields with course details
                updateCourseName.text = course.courseName
                updateProgramID.text = course.programID
                updateCollegeID.text = course.collegeID
                updateCourseCatID.text = String(course.courseCatID)
                // Disable the Course ID field to prevent editing
                updateCourseID.isEnabled = false
            } else {
                presentErrorAlert(message: "Course doesn't exist.")
            }
        
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        let courseId = updateCourseID.text! // As the ID field is disabled, it holds the original ID value
            guard let courseName = updateCourseName.text, !courseName.isEmpty,
                  let programId = updateProgramID.text, !programId.isEmpty,
                  let collegeId = updateCollegeID.text, !collegeId.isEmpty,
                  let courseCatId = updateCourseCatID.text, !courseCatId.isEmpty else {
                presentErrorAlert(message: "All fields must be filled in.")
                return
            }
        guard let existingCourse = fetchCourse(withID: courseId) else {
            presentErrorAlert(message: "The course ID does not exist.")
            return
        }
        
        // Check the college ID for the provided program ID
        if let college_ID = getCollegeID(forProgram: programId) {
            // Check if Course Category ID exists
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let fetchCCRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
                fetchCCRequest.predicate = NSPredicate(format: "courseCatID == %@", courseCatId)
                
                do {
                    let courseCategories = try context.fetch(fetchCCRequest)
                    if let cc = courseCategories.first {
                        // Attempt to convert ccID to Int32
                        if let ccIDInt = Int32(courseCatId) {
                            // Update the Course entity
                            existingCourse.courseName = courseName
                            existingCourse.programID = programId
                            existingCourse.collegeID = collegeId
                            existingCourse.courseCatID = ccIDInt
                            
                            do {
                                try context.save()
                                presentSuccessAlert()
                            } catch {
                                presentErrorAlert(message: "Error while saving Course data.")
                            }
                        } else {
                            presentErrorAlert(message: "Invalid Course Category ID. Please enter a valid integer.")
                        }
                    }
                } catch {
                    presentErrorAlert(message: "Error checking for existing Course Category ID.")
                }
            }
        }
 else {
            presentErrorAlert(message: "Please check the Program ID.")
        }
           
    }
    
    
    func fetchCourse(withID courseID: String) -> CourseEntity? {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let fetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "courseID == %@", courseID)
            
            do {
                let courses = try context.fetch(fetchRequest)
                return courses.first
            } catch {
                presentErrorAlert(message: "An error occurred while fetching data.")
            }
        }
        return nil
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
                presentErrorAlert(message: "An error occurred while fetching data.")
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

