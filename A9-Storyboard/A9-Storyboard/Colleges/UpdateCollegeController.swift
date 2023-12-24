//
//  UpdateCollegeController.swift
//  A9-Storyboard
//
//  Created by Keerthana Srinivasan on 11/18/23.
//

import UIKit
import CoreData

class UpdateCollegeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var college: CollegeEntity?
    var context: NSManagedObjectContext?
    var vcMode: ViewControllerMode = .create
    
    @IBOutlet weak var collegeID: UITextField!
    @IBOutlet weak var collegeName: UITextField!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var collegeAddress: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var updateBtn: UIButton!
    
    var imageView : String?
    var labeltext : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewForMode()
//        pageLabel?.text = labeltext
//        logo?.image = UIImage(named: imageView ?? "p0")
    }
    
    func configureViewForMode() {
        switch vcMode {
        case .create:
            pageLabel.text = "Create College"
            updateBtn.setTitle("Create", for: .normal)
            collegeID.isEnabled = true  // Assuming ID is manually entered for new colleges

        case .modify:
            pageLabel.text = "Update College"
            updateBtn.setTitle("Update", for: .normal)
            collegeID.isEnabled = false // ID should not be editable
            loadExistingCollegeData()
        }
    }
    
    func loadExistingCollegeData() {
        guard let collegeData = college else { return }
            collegeID.text = collegeData.collegeID ?? "No ID"
            collegeName.text = collegeData.collegeName
            collegeAddress.text = collegeData.collegeAddress
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

    @IBAction func selectNewImageTap(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func updateButtonTap(_ sender: Any) {
        if vcMode == .modify {
            updateCollege()
        } else {
            createCollege()
        }
    }
    
    func createCollege() {
        guard let context = self.context else { return }

        guard let collegeIdText = collegeID.text, !collegeIdText.isEmpty,
              let collegeNameText = collegeName.text, !collegeNameText.isEmpty,
              let collegeAddressText = collegeAddress.text, !collegeAddressText.isEmpty else {
            presentAlert(message: "All fields are required.")
            return
        }

        if collegeExists(withId: collegeIdText) {
            presentAlert(message: "College ID already exists.")
            return
        }

        let newCollege = CollegeEntity(context: context)
        newCollege.collegeID = collegeIdText
        newCollege.collegeName = collegeNameText
        newCollege.collegeAddress = collegeAddressText
        newCollege.image = logo.image?.jpegData(compressionQuality: 1.0)

        saveContext(context)
        clearFields()
        let alert = UIAlertController(title: "Success", message: "College created successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }

    func updateCollege() {
        guard let collegeEntity = college, let context = collegeEntity.managedObjectContext else { return }

        guard let collegeNameText = collegeName.text, !collegeNameText.isEmpty,
              let collegeAddressText = collegeAddress.text, !collegeAddressText.isEmpty else {
            presentAlert(message: "All fields are required.")
            return
        }

        if !collegeExists(withId: collegeEntity.collegeID!) {
            presentAlert(message: "Selected college does not exist.")
            return
        }
        
        collegeEntity.collegeID = collegeID.text
        collegeEntity.collegeName = collegeNameText
        collegeEntity.collegeAddress = collegeAddressText
        collegeEntity.image = logo.image?.jpegData(compressionQuality: 1.0)

        saveContext(context)
        clearFields()
        let alert = UIAlertController(title: "Success", message: "College updated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
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
    
    func collegeExists(withId id: String) -> Bool {
        let fetchRequest: NSFetchRequest<CollegeEntity> = CollegeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "collegeID == %@", id)
        
        do {
            let result = try context?.fetch(fetchRequest)
            return result?.count ?? 0 > 0
        } catch {
            print("Error checking for existing college: \(error)")
            return false
        }
    }
    
    func clearFields(){
            collegeID.text = ""
            collegeName.text = ""
            collegeAddress.text = ""
            logo.image = nil
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
