//
//  UpdateProgramViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class UpdateProgramViewController: UIViewController {

    @IBOutlet weak var updateViewLabel: UILabel!
    @IBOutlet weak var UpdatableFields: UILabel!
    
    @IBOutlet weak var updateProgramID: UITextField!
    @IBOutlet weak var updateCollegeIDFIeld: UITextField!
    @IBOutlet weak var updateProgramNameField: UITextField!
    
    @IBOutlet weak var findBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var programsModel = [ProgramEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func clearFields(){
        updateProgramID.text = ""
        updateCollegeIDFIeld.text = ""
        updateProgramNameField.text = ""
    }
    
    @IBAction func handleFind(_ sender: UIButton) {
        guard let prgmID = updateProgramID.text, !prgmID.isEmpty else {
            presentErrorAlert(message: "Please enter program ID.")
            return
        }

        let fetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "programID == %@", prgmID)
        
        do {
            let programs = try managedObjectContext.fetch(fetchRequest)
            
            if let program = programs.first {
                // Populate fields
                updateProgramNameField.text = program.programName
                updateCollegeIDFIeld.text = program.collegeID
                updateProgramID.isEnabled = false
            } else {
                presentErrorAlert(message: "Program doesn't exist.")
            }
        } catch {
            // Handle the fetch error
            print("Error \(error)")
        }
    }
    
    @IBAction func handleUpdate(_ sender: Any) {
        updateProgram()
    }
    
    @objc func updateProgram() {
        let prgmId = updateProgramID.text!
        guard let programName = updateProgramNameField.text, !programName.isEmpty,
              let collegeID = updateCollegeIDFIeld.text, !collegeID.isEmpty else {
            presentErrorAlert(message: "Name and college ID cannot be empty.")
            return
        }

        // Update the college
        let fetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "programID == %@", prgmId)
        
        if collegeWithIDExists(id: collegeID) {
            do {
                let programs = try managedObjectContext.fetch(fetchRequest)
                if let program = programs.first {
                    program.programName = programName
                    program.colleges?.collegeID = collegeID
                    
                    do {
                        try managedObjectContext.save()
                        presentSuccessAlert()
                        clearFields()
                    } catch {
                        // Handle the save error
                        print("Error while saving: \(error)")
                    }
                } else {
                    presentErrorAlert(message: "Program doesn't exist.")
                }
            } catch {
                print("Error \(error)")
            }
        }
        else {
            presentErrorAlert(message: "College ID Doesn't exist. Updation cancelled")
        }
    }
    
    private func collegeWithIDExists(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<CollegesEntity> = CollegesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "collegeID == %@", id)
        
        do {
            let count = try managedObjectContext.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    @IBAction func handleBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Program Updated", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}
