//
//  DeleteCourseViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData

class DeleteCourseViewController: UIViewController {

    @IBOutlet weak var DelCourseField: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleDelete(_ sender: UIButton) {
        guard let courseId = DelCourseField.text, !courseId.isEmpty else {
                presentErrorAlert(message: "Enter a Course ID, please.")
                return
            }

        if let courseToDelete = fetchCourse(withID: courseId) {
            let confirmationAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this course?", preferredStyle: .alert)
            
            confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
                if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                    context.delete(courseToDelete)
                    
                    do {
                        try context.save()
                        self?.presentSuccessAlert()
                    } catch {
                        self?.presentErrorAlert(message: "Error while deleting the course.")
                    }
                }
            }))
            
            confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel))
            present(confirmationAlert, animated: true, completion: nil)
        } else {
            presentErrorAlert(message: "Course ID not found")
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
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }

    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Course Deleted", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
