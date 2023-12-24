//
//  CategoryDetailsController.swift
//  A9-Storyboard
//
//  Created by Keerthana Srinivasan on 11/21/23.
//

import UIKit
import CoreData

class CategoryDetailsController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var category: CategoryEntity?
    var context: NSManagedObjectContext?
    var vcMode: ViewControllerMode = .create

    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var categoryId: UITextField!
    @IBOutlet weak var categoryName: UITextField!
    @IBOutlet weak var categoryLogo: UIImageView!
    @IBOutlet weak var selectImageBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewForMode()
    }
    
    func configureViewForMode() {
        switch vcMode {
        case .create:
            pageLabel.text = "Create Category"
            submitBtn.setTitle("Create", for: .normal)
            categoryId.isEnabled = true  // Assuming ID is manually entered for new colleges

        case .modify:
            pageLabel.text = "Update Category"
            submitBtn.setTitle("Update", for: .normal)
            categoryId.isEnabled = false // ID should not be editable
            loadExistingCollegeData()
        }
    }
    
    func loadExistingCollegeData() {
        guard let collegeData = category else { return }
            categoryId.text = collegeData.categoryID ?? "No ID"
            categoryName.text = collegeData.categoryName
            if let imageData = collegeData.image {
                categoryLogo.image = UIImage(data: imageData)
            } else {
                categoryLogo.image = UIImage(named: "placeholder")
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            categoryLogo.image = selectedImage
        }
        dismiss(animated: true)
    }

    @IBAction func selectImageTap(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func submitBtnTap(_ sender: Any) {
        if vcMode == .modify {
            updateCategory()
        } else {
            createCategory()
        }
    }
    
    func createCategory() {
        guard let context = self.context else { return }

        guard let categoryIdText = categoryId.text, !categoryIdText.isEmpty,
              let categoryNameText = categoryName.text, !categoryNameText.isEmpty else {
            presentAlert(message: "All fields are required.")
            return
        }

        if categoryExists(withId: categoryIdText) {
            presentAlert(message: "Category ID already exists.")
            return
        }

        let newCategory = CategoryEntity(context: context)
        newCategory.categoryID = categoryIdText
        newCategory.categoryName = categoryNameText
        newCategory.image = categoryLogo.image?.jpegData(compressionQuality: 1.0)

        saveContext(context)
        let alert = UIAlertController(title: "Success", message: "Category created successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    func updateCategory() {
        guard let categoryEntity = category, let context = categoryEntity.managedObjectContext else { return }

        guard let categoryIdText = categoryId.text, !categoryIdText.isEmpty,
              let categoryNameText = categoryName.text, !categoryNameText.isEmpty else {
            presentAlert(message: "All fields are required.")
            return
        }

        // Update the properties of the course category entity
        categoryEntity.categoryID = categoryIdText
        categoryEntity.categoryName = categoryNameText
        categoryEntity.image = categoryLogo.image?.jpegData(compressionQuality: 1.0)

        saveContext(context)
        clearFields()
        let alert = UIAlertController(title: "Success", message: "Category updated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }


    func categoryExists(withId id: String) -> Bool {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "categoryID == %@", id)
        
        do {
            let result = try context?.fetch(fetchRequest)
            return result?.count ?? 0 > 0
        } catch {
            print("Error checking for existing category: \(error)")
            return false
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func clearFields(){
            categoryId.text = ""
            categoryName.text = ""
            categoryLogo.image = nil
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
