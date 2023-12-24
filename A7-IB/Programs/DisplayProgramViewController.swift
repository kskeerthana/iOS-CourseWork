//
//  DisplayProgramViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class DisplayProgramViewController: UIViewController {

    @IBOutlet weak var searchProgramView: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var programNameTxtField: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var DisplayLabel: UILabel!
    
    var managedObject: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    
    @IBAction func handleSearchBtn(_ sender: UIButton) {
        if let searchQuery = programNameTxtField.text, !searchQuery.isEmpty {
        let fetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "programName == %@", searchQuery)
        
        do {
            let programs = try managedObject.fetch(fetchRequest)
            
            if let program = programs.first {
                updateLabel(with: program)
            } else {
                DisplayLabel.text = "Program not found."
            }
        } catch {
            // Handle the error
            DisplayLabel.text = "An error occurred while fetching data."
        }
    } else {
        loadAllColleges()
    }
    }
    
    func loadAllColleges() {
        let fetchRequest: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
        
        do {
            let programs = try managedObject.fetch(fetchRequest)
            
            if !programs.isEmpty {
                var programInfo = ""
                for program in programs {
                    print("""
                          Program ID: \(program.programID ?? "")
                          Program Name: \(program.programName ?? "")
                          College ID: \(program.collegeID ?? "")
                          """)
                    programInfo += """
                    Program ID: \(program.programID ?? "")
                    Program Name: \(program.programName ?? "")
                    College ID: \(program.collegeID ?? "")
                    ==============================\n
                    """
                }
                DisplayLabel.text = programInfo
            } else {
                DisplayLabel.text = "No Programs found."
                    }
        } catch {
            // Handle the error
            DisplayLabel.text = "An error occurred while fetching data."
        }
    }
    
    func updateLabel(with program: ProgramEntity) {
        DisplayLabel.text = """
        Program ID: \(program.programID ?? "")
        Program Name: \(program.programName ?? "")
        College ID: \(program.collegeID ?? "")
        ==================================
        """
    }
    
    @IBAction func handleBackBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllColleges()

    }
}
