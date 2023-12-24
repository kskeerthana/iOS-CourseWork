//
//  DisplayCategoryViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class DisplayCategoryViewController: UIViewController {

    @IBOutlet weak var searchCategoryName: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var DisplayLabel: UILabel!
    
    var managedObject: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllColleges()
    }
    

    @IBAction func handleSearch(_ sender: UIButton) {
        if let searchQuery = searchCategoryName.text, !searchQuery.isEmpty {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "courseCatName == %@", searchQuery)
        
        do {
            let colleges = try managedObject.fetch(fetchRequest)
            
            if let college = colleges.first {
                updateLabel(with: college)
            } else {
                DisplayLabel.text = "Course Category not found."
            }
        } catch {
            // Handle the error
            DisplayLabel.text = "An error occurred while fetching data."
        }
        } else {
        // If the search query is empty, show all colleges
        loadAllColleges()
        }
    }

    func loadAllColleges() {
        let fetchRequest: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        do {
            let colleges = try managedObject.fetch(fetchRequest)
            
            if !colleges.isEmpty {
                var collegeInfo = ""
                for college in colleges {
                    let categoryIDString = "\(college.courseCatID)"
                    collegeInfo += """
                    Name: \(college.courseCatName ?? "")
                    ID: \(categoryIDString ?? "")
                    ===================\n
                    """
                }
                DisplayLabel.text = collegeInfo
            } else {
                        DisplayLabel.text = "No Course category found."
                    }
        } catch {
            // Handle the error
            DisplayLabel.text = "An error occurred while fetching data."
        }
    }
    func updateLabel(with college: CategoryEntity) {
        let categoryIDString = "\(college.courseCatID)"
        DisplayLabel.text = """
        Course category ID: \(categoryIDString ?? "")
        Course category Name: \(college.courseCatName ?? "")
        ------------------
        """
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

