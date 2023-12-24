//
//  DisplayCollegeViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class DisplayCollegeViewController: UIViewController {

    
    @IBOutlet weak var searchViewLabel: UILabel!
    @IBOutlet weak var collegeNameTextField: UITextField!
    @IBOutlet weak var DisplayLabel: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    var managedObject: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllColleges()
    }
    
    @IBAction func searchBtnClick(_ sender: UIButton) {
        if let searchQuery = collegeNameTextField.text, !searchQuery.isEmpty {
            let fetchRequest: NSFetchRequest<CollegesEntity> = CollegesEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "collegeName == %@", searchQuery)
            do {
                let colleges = try managedObject.fetch(fetchRequest)
                
                if let college = colleges.first {
                    updateLabel(with: college)
                } else {
                    DisplayLabel.text = "College not found."
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
        let fetchRequest: NSFetchRequest<CollegesEntity> = CollegesEntity.fetchRequest()
        
        do {
            let colleges = try managedObject.fetch(fetchRequest)
            
            if !colleges.isEmpty {
                var collegeInfo = ""
                for college in colleges {
                    collegeInfo += """
                    College ID: \(college.collegeID ?? "")
                    College Name: \(college.collegeName ?? "")
                    College Address: \(college.collegeAddress ?? "")
                    ================================\n
                    """
                }
                DisplayLabel.text = collegeInfo
            } else {
                        DisplayLabel.text = "No Colleges found."
                    }
        } catch {
            // Handle the error
            DisplayLabel.text = "An error occurred while fetching data."
        }
    }

    func updateLabel(with college: CollegesEntity) {
        DisplayLabel.text = """
        ID: \(college.collegeID ?? "")
        Name: \(college.collegeName ?? "")
        Address: \(college.collegeAddress ?? "")
        ================================
        """
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
