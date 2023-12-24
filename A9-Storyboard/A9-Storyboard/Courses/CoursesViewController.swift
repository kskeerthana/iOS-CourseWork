//
//  CoursesViewController.swift
//  A9-Storyboard
//
//  Created by Keerthana Srinivasan on 11/21/23.
//

import UIKit
import CoreData

class CoursesViewController: UITableViewController {
    
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var courses: [CourseEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadColleges()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadColleges() // This will refresh the data every time the view appears
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath)
        
        let course = courses[indexPath.row]
        cell.textLabel?.text = course.courseName
        if let imageData = course.image {
            cell.imageView?.image = UIImage(data: imageData)
        }
        else {
            cell.imageView?.image = UIImage(named: "placeholder")
        }
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let courseToDelete = courses[indexPath.row]
            //            context.delete(courseToDelete)
            //            saveColleges()
            //            courses.remove(at: indexPath.row)
            //            tableView.deleteRows(at: [indexPath], with: .fade)
            let alert = UIAlertController(title: "Delete Course", message: "Are you sure you want to delete this course?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                // Proceed with deletion
                self?.context.delete(courseToDelete)
                self?.saveCourses()
                self?.courses.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(alert, animated: true)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let collegeDetailVC = storyboard.instantiateViewController(withIdentifier: "CourseDetails") as? CourseDetailsController {
            collegeDetailVC.vcMode = .modify
            collegeDetailVC.course = courses[indexPath.row]
            collegeDetailVC.context = context
            navigationController?.pushViewController(collegeDetailVC, animated: true)
        }
    }
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    @IBAction func addCourseTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let collegeDetailVC = storyboard.instantiateViewController(withIdentifier: "CourseDetails") as? CourseDetailsController {
            collegeDetailVC.vcMode = .create
            collegeDetailVC.context = self.context
            self.navigationController?.pushViewController(collegeDetailVC, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let row = self.tableView.indexPathForSelectedRow?.row
        if let vc = segue.destination as? CourseDetailsController{
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedCollege = courses[indexPath.row]
                vc.course = selectedCollege
            }
        }
    }
    
    func saveCourses() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadColleges() {
        let request: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
        do {
            courses = try self.context.fetch(request)
            self.tableView.reloadData()
        } catch {
            print("Error fetching data from context \(error)")
        }

    }
        
}
