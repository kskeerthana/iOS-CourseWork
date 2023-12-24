//
//  ProgramDetailsController.swift
//  A9-Storyboard
//
//  Created by Keerthana Srinivasan on 11/20/23.
//

import UIKit
import CoreData

class ProgramDetailsController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var program: ProgramEntity?
    var context: NSManagedObjectContext?
    var vcMode: ViewControllerMode = .create
    
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var programId: UITextField!
    @IBOutlet weak var programName: UITextField!
    @IBOutlet weak var collegeId: UITextField!
    @IBOutlet weak var programLogo: UIImageView!
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewForMode()
        // Do any additional setup after loading the view.
    }
    
    func configureViewForMode() {
        switch vcMode {
        case .create:
            programLabel.text = "Create Program"
            submitBtn.setTitle("Create", for: .normal)
            programId.isEnabled = true  // Assuming ID is manually entered for new colleges

        case .modify:
            programLabel.text = "Update Program"
            submitBtn.setTitle("Update", for: .normal)
            programId.isEnabled = false // ID should not be editable
            loadExistingCollegeData()
        }
    }
    
    func loadExistingCollegeData() {
        guard let programData = program else { return }
            programId.text = programData.programID ?? "No ID"
            programName.text = programData.programName
            collegeId.text = programData.collegeID
            if let imageData = programData.image {
                programLogo.image = UIImage(data: imageData)
            } else {
                programLogo.image = UIImage(named: "placeholder")
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            programLogo.image = selectedImage
        }
        dismiss(animated: true)
    }
    
    
    @IBAction func imageBtnTap(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    
    @IBAction func submitBtnTap(_ sender: Any) {
        if vcMode == .modify {
            updateProgram()
        } else {
            createProgram()
        }
    }
    
    func createProgram() {
        guard let context = self.context else { return }

        guard let programIdText = programId.text, !programIdText.isEmpty,
              let programNameText = programName.text, !programNameText.isEmpty,
              let collegeIdText = collegeId.text, !collegeIdText.isEmpty else {
            presentAlert(message: "All fields are required.")
            return
        }

        if !collegeExists(withId: collegeIdText) {
            presentAlert(message: "College ID does not exist.")
            return
        }

        let newProgram = ProgramEntity(context: context)
        newProgram.programID = programIdText
        newProgram.programName = programNameText
        newProgram.collegeID = collegeIdText
        newProgram.image = programLogo.image?.jpegData(compressionQuality: 1.0)

        saveContext(context)
        let alert = UIAlertController(title: "Success", message: "Program created successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    func updateProgram() {
        guard let programEntity = program, let context = programEntity.managedObjectContext else { return }

        guard let programIdText = programId.text, !programIdText.isEmpty,
              let programNameText = programName.text, !programNameText.isEmpty,
              let collegeIdText = collegeId.text, !collegeIdText.isEmpty else {
            presentAlert(message: "All fields are required.")
            return
        }

        if !collegeExists(withId: collegeIdText) {
            presentAlert(message: "College ID does not exist.")
            return
        }

        // Update the properties of the program entity
        programEntity.programID = programIdText
        programEntity.programName = programNameText
        programEntity.collegeID = collegeIdText
        programEntity.image = programLogo.image?.jpegData(compressionQuality: 1.0)

        saveContext(context)
        clearFields()
        let alert = UIAlertController(title: "Success", message: "Program updated successfully.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
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
    func clearFields(){
            programId.text = ""
            programName.text = ""
            collegeId.text = ""
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
