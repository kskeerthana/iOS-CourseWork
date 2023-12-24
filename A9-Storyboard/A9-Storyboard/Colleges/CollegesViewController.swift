//
//  CollegesViewController.swift
//  A9-Storyboard
//
//  Created by Keerthana Srinivasan on 11/17/23.
//

import UIKit
import CoreData

class CollegesViewController: UITableViewController {
    
//    var colleges : [String] = ["COE","CPS","Bouve","CAMD","NUCL"]
//    var filteredObjects : [String] = [String]()
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var colleges: [CollegeEntity] = []
    
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
    
    @IBAction func insertNewCollege(_sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let collegeDetailVC = storyboard.instantiateViewController(withIdentifier: "UpdateCollegeController") as? UpdateCollegeController {
            collegeDetailVC.vcMode = .create
            collegeDetailVC.context = self.context
            self.navigationController?.pushViewController(collegeDetailVC, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return colleges.count
    }

    func loadColleges() {
            let request: NSFetchRequest<CollegeEntity> = CollegeEntity.fetchRequest()
            do {
                colleges = try self.context.fetch(request)
                self.tableView.reloadData()
            } catch {
                print("Error fetching data from context \(error)")
            }
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        let college = colleges[indexPath.row]
        cell.textLabel?.text = college.collegeName
        if let imageData = college.image {
            cell.imageView?.image = UIImage(data: imageData)
        }
        else {
            cell.imageView?.image = UIImage(named: "placeholder")
        }
        return cell
    }
    
    

    
    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    
    func saveColleges() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let collegeToDelete = colleges[indexPath.row]
            context.delete(collegeToDelete)
            saveColleges()

            colleges.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //            let vc = CollegeDetailsController()
        //            self.navigationController?.show(vc, sender: self)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let collegeDetailVC = storyboard.instantiateViewController(withIdentifier: "UpdateCollegeController") as? UpdateCollegeController {
            collegeDetailVC.vcMode = .modify
            collegeDetailVC.college = colleges[indexPath.row]
            collegeDetailVC.context = self.context
            navigationController?.pushViewController(collegeDetailVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let object = colleges[indexPath.row]
        let vc = UpdateCollegeController()
        self.navigationController?.show(vc, sender: self)
    }
    
    @IBAction func onReset(segue : UIStoryboardSegue){
        //give the reset connection to this function from storyboard
        loadColleges()
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
        if let vc = segue.destination as? UpdateCollegeController{
//            vc.labeltext = colleges[row ?? 0]
//            vc.imageView = "p\(row!).jpg"
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedCollege = colleges[indexPath.row]
                vc.college = selectedCollege
            }
        }
    }
    

}
