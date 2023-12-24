//
//  DisplayCoursesViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit
import CoreData
class DisplayCoursesViewController: UIViewController {

    @IBOutlet weak var DisplayCourseName: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var DisplayLabel: UILabel!
    
    var managedObject: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllColleges()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSearch(_ sender: UIButton) {
        if let searchQuery = DisplayCourseName.text, !searchQuery.isEmpty {
            let fetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "courseName == %@", searchQuery)
            
            do {
                let colleges = try managedObject.fetch(fetchRequest)
                
                if let college = colleges.first {
                    updateLabel(with: college)
                } else {
                    DisplayLabel.text = "Course not found."
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
        let fetchRequest: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
        
        do {
            let colleges = try managedObject.fetch(fetchRequest)
            
            if !colleges.isEmpty {
                var collegeInfo = ""
                for college in colleges {
                    let ccIDString = "\(college.courseCatID)"
                    collegeInfo += """
                    Course Name: \(college.courseName ?? "")
                    Course ID: \(college.courseID ?? "")
                    Program ID: \(college.programID ?? "")
                    College ID : \(college.collegeID ?? "")
                    Course Category: \(ccIDString ?? "")
                    =====================\n
                    """
                }
                DisplayLabel.text = collegeInfo
            } else {
                        DisplayLabel.text = "No Courses found."
                    }
        } catch {
            // Handle the error
            DisplayLabel.text = "An error occurred while fetching data."
        }
    }
    func updateLabel(with college: CourseEntity) {
        let ccIDString = "\(college.courseCatID)"
        DisplayLabel.text = """
        Course Name: \(college.courseName ?? "")
        Course ID: \(college.courseID ?? "")
        Program ID: \(college.programID ?? "")
        College ID : \(college.collegeID ?? "")
        Course Category: \(ccIDString ?? "")
        ------------------
        """
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
