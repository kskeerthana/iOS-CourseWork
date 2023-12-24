//
//  CourseDetailsController.swift
//  A9-Storyboard
//
//  Created by Keerthana Srinivasan on 11/21/23.
//

import UIKit
import CoreData

class CourseDetailsController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var course: CourseEntity?
    var context: NSManagedObjectContext?
    var vcMode: ViewControllerMode = .create

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var courseId: UITextField!
    @IBOutlet weak var courseName: UITextField!
    @IBOutlet weak var programId: UITextField!
    @IBOutlet weak var categoryId: UITextField!
    @IBOutlet weak var collegeId: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var selectImageBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewForMode()
        // Do any additional setup after loading the view.
    }
    
    func configureViewForMode() {
        switch vcMode {
        case .create:
            pageLabel.text = "Create Course"
            submitBtn.setTitle("Create", for: .normal)
            courseId.isEnabled = true  // Assuming ID is manually entered for new colleges

        case .modify:
            pageLabel.text = "Update Course"
            submitBtn.setTitle("Update", for: .normal)
            courseId.isEnabled = false // ID should not be editable
            loadExistingCollegeData()
        }
    }
    func loadExistingCollegeData() {
        guard let collegeData = course else { return }
            courseId.text = collegeData.courseID ?? "No ID"
            courseName.text = collegeData.courseName
            programId.text = collegeData.programID
            categoryId.text = collegeData.categoryID
            collegeId.text = collegeData.collegeID
            if let imageData = collegeData.image {
                logo.image = UIImage(data: imageData)
            } else {
                logo.image = UIImage(named: "placeholder")
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            logo.image = selectedImage
        }
        dismiss(animated: true)
    }
    
    func clearFields(){
        courseName.text = ""
        courseId.text = ""
        programId.text = ""
        categoryId.text = ""
        collegeId.text = ""
        logo.image = nil
        }

    @IBAction func imageSelectTap(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    @IBAction func submitBtnTap(_ sender: Any) {
        if vcMode == .modify {
            updateCourse()
        } else {
            createCourse()
        }
    }
    
    func createCourse() {
        guard let context = self.context else { return }

        guard let courseIdText = courseId.text, !courseIdText.isEmpty,
              let courseNameText = courseName.text, !courseNameText.isEmpty,
              let programIdText = programId.text, !programIdText.isEmpty,
              let categoryIdText = categoryId.text, !categoryIdText.isEmpty,
              let collegeIdText = collegeId.text, !collegeIdText.isEmpty else {
            presentAlert(message: "All fields are required.")
            return
        }

        var errorMessage = ""

        if !entityExists(entityName: "CollegeEntity", idKey: "collegeID", idValue: collegeIdText) {
            errorMessage += "College ID does not exist. "
        }
        if !entityExists(entityName: "ProgramEntity", idKey: "programID", idValue: programIdText) {
            errorMessage += "Program ID does not exist. "
        }
        if !entityExists(entityName: "CategoryEntity", idKey: "categoryID", idValue: categoryIdText) {
            errorMessage += "Category ID does not exist. "
        }
        if entityExists(entityName: "CourseEntity", idKey: "courseID", idValue: courseIdText) {
            errorMessage += "Course ID already exists. "
        }

        if !errorMessage.isEmpty {
            presentAlert(message: errorMessage)
            return
        }

        let newCourse = CourseEntity(context: context)
        newCourse.courseID = courseIdText
        newCourse.courseName = courseNameText
        newCourse.programID = programIdText
        newCourse.categoryID = categoryIdText
        newCourse.collegeID = collegeIdText
        newCourse.image = logo.image?.jpegData(compressionQuality: 1.0)

        saveContext(context)
        clearFields()
        let alert = UIAlertController(title: "Success", message: "Course added successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    func updateCourse() {
        guard let courseEntity = course, let context = courseEntity.managedObjectContext else { return }

        guard let courseIdText = courseId.text, !courseIdText.isEmpty,
              let courseNameText = courseName.text, !courseNameText.isEmpty,
              let programIdText = programId.text, !programIdText.isEmpty,
              let categoryIdText = categoryId.text, !categoryIdText.isEmpty,
              let collegeIdText = collegeId.text, !collegeIdText.isEmpty else {
            presentAlert(message: "All fields are required.")
            return
        }

        var errorMessage = ""

        if !entityExists(entityName: "CollegeEntity", idKey: "collegeID", idValue: collegeIdText) {
            errorMessage += "College ID does not exist. "
        }
        if !entityExists(entityName: "ProgramEntity", idKey: "programID", idValue: programIdText) {
            errorMessage += "Program ID does not exist. "
        }
        if !entityExists(entityName: "CategoryEntity", idKey: "categoryID", idValue: categoryIdText) {
            errorMessage += "Category ID does not exist. "
        }

        if !errorMessage.isEmpty {
            presentAlert(message: errorMessage)
            return
        }

        // Update the properties of the course entity
        courseEntity.courseID = courseIdText
        courseEntity.courseName = courseNameText
        courseEntity.programID = programIdText
        courseEntity.categoryID = categoryIdText
        courseEntity.collegeID = collegeIdText
        courseEntity.image = logo.image?.jpegData(compressionQuality: 1.0)

        saveContext(context)
        clearFields()
        let alert = UIAlertController(title: "Success", message: "Course updated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    func entityExists(entityName: String, idKey: String, idValue: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", idKey, idValue)
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context?.fetch(fetchRequest)
            return result?.count ?? 0 > 0
        } catch {
            print("Error checking for existing entity: \(error)")
            return false
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}
