//
//  CreateProgramViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class CreateProgramViewController: UIViewController {
    
    @IBOutlet weak var addProgramLabel: UILabel!
    @IBOutlet weak var programNameTextField: UITextField!
    @IBOutlet weak var programIDTextField: UITextField!
    @IBOutlet weak var collegeIDTextField: UITextField!
    
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var managedObjectContext: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var ProgramModel = [ProgramEntity]()
    
    private func clearFields(){
        programNameTextField.text = ""
        programIDTextField.text = ""
        programNameTextField.text = ""
    }
    
    @IBAction func handleAddBtn(_ sender: UIButton) {
        addProgram()
    }
    
    @objc func addProgram() {
            guard let id = programIDTextField.text, !id.isEmpty,
                  let name = programNameTextField.text, !name.isEmpty,
                  let clgID = collegeIDTextField.text, !clgID.isEmpty else {
                presentErrorAlert(message: "All fields are required.")
                return
            }
        let fetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "programID == %@", id)
        
        do {
            let programs = try managedObjectContext.fetch(fetchRequest)
            if !programs.isEmpty {
                presentErrorAlert(message: "Program ID already exists.")
                return
            }
        } catch {
            print("Error \(error)")
        }
        
        // Check if the college with the specified clgID exists in Core Data
        let collegeFetchRequest: NSFetchRequest<CollegesEntity> = CollegesEntity.fetchRequest()
        collegeFetchRequest.predicate = NSPredicate(format: "collegeID == %@", clgID)
        
        do {
            let colleges = try managedObjectContext.fetch(collegeFetchRequest)
            if let college = colleges.first {
                // College with the specified clgID exists, you can create the new program entity
                let newProgram = ProgramEntity(context: managedObjectContext)
                newProgram.programID = id
                newProgram.programName = name
                newProgram.collegeID = clgID
                
                do {
                    try managedObjectContext.save()
                    presentSuccessAlert()
                    clearFields()
                } catch {
                    // Handle the save error
                    print("Error while saving: \(error)")
                }
            } else {
                presentErrorAlert(message: "College doesn't exist.")
            }
        } catch {
            print("Error \(error)")
        }
    }
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func presentSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Program Added", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func handleBackBtn(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
