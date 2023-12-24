//
//  ProgramsViewController.swift
//  A9-Storyboard
//
//  Created by Keerthana Srinivasan on 11/20/23.
//

import UIKit
import CoreData

class ProgramsViewController: UITableViewController {
    
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
    var programs : [ProgramEntity] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPrograms() // This will refresh the data every time the view appears
    }
    
    func loadPrograms() {
            let request: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
            do {
                programs = try self.context.fetch(request)
                self.tableView.reloadData()
            } catch {
                print("Error fetching data from context \(error)")
            }
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return programs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "programCell", for: indexPath)
        let program = programs[indexPath.row]
        cell.textLabel?.text = program.programName
        if let imageData = program.image {
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
            let programToDelete = programs[indexPath.row]
            if hasAssociatedCourses(programId: programToDelete.programID!) {
                presentAlert(message: "This program has associated courses and cannot be deleted.")
                return
            }

            context.delete(programToDelete)
            savePrograms()
            programs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func hasAssociatedCourses(programId: String) -> Bool {
        // Check for associated courses
        let courseFetch: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
        courseFetch.predicate = NSPredicate(format: "programID == %@", programId)

        do {
            let courseResults = try context.fetch(courseFetch)
            return !courseResults.isEmpty
        } catch {
            print("Error checking for associated courses: \(error)")
            return true
        }
    }
    
    func savePrograms() {
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

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let programDetailVC = storyboard.instantiateViewController(withIdentifier: "ProgramDetails") as? ProgramDetailsController {
            programDetailVC.vcMode = .modify
            programDetailVC.program = programs[indexPath.row]
            programDetailVC.context = context
            navigationController?.pushViewController(programDetailVC, animated: true)
        }
    }
    
    
    @IBAction func addProgramTap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let programDetailVC = storyboard.instantiateViewController(withIdentifier: "ProgramDetails") as? ProgramDetailsController {
            programDetailVC.vcMode = .create
            programDetailVC.context = self.context
            self.navigationController?.pushViewController(programDetailVC, animated: true)
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
        let row = self.tableView.indexPathForSelectedRow?.row
        if let vc = segue.destination as? ProgramDetailsController{
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedProgram = programs[indexPath.row]
                vc.program = selectedProgram
            }
        }
    }
    

}
