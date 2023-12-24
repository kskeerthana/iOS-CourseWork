//
//  CategoryViewController.swift
//  A9-Storyboard
//
//  Created by Keerthana Srinivasan on 11/21/23.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var categories: [CategoryEntity] = []

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
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        let category = categories[indexPath.row]
        cell.textLabel?.text = category.categoryName
        if let imageData = category.image {
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
            let categoryToDelete = categories[indexPath.row]
            if hasAssociatedCourses(categoryId: categoryToDelete.categoryID!) {
                presentAlert(message: "This category has associated courses and cannot be deleted.")
                return
            }
            context.delete(categoryToDelete)
            saveCategories()
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func hasAssociatedCourses(categoryId: String) -> Bool {
        // Check for associated courses
        let courseFetch: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
        courseFetch.predicate = NSPredicate(format: "categoryID == %@", categoryId)

        do {
            let courseResults = try context.fetch(courseFetch)
            return !courseResults.isEmpty
        } catch {
            print("Error checking for associated courses: \(error)")
            return true
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let categoryDetailVC = storyboard.instantiateViewController(withIdentifier: "CategoryDetails") as? CategoryDetailsController {
            categoryDetailVC.vcMode = .modify
            categoryDetailVC.category = categories[indexPath.row]
            categoryDetailVC.context = context
            navigationController?.pushViewController(categoryDetailVC, animated: true)
        }
    }

    @IBAction func addCategoryTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let collegeDetailVC = storyboard.instantiateViewController(withIdentifier: "CategoryDetails") as? CategoryDetailsController {
            collegeDetailVC.vcMode = .create
            collegeDetailVC.context = self.context
            self.navigationController?.pushViewController(collegeDetailVC, animated: true)
        }
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadColleges() {
            let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
            do {
                categories = try self.context.fetch(request)
                self.tableView.reloadData()
            } catch {
                print("Error fetching data from context \(error)")
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let row = self.tableView.indexPathForSelectedRow?.row
        if let vc = segue.destination as? CategoryDetailsController{
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedCategory = categories[indexPath.row]
                vc.category = selectedCategory
            }
        }
    }

}
