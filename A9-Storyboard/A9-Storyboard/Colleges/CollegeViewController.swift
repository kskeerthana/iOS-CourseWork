import UIKit
import CoreData

class CollegesViewController: UITableViewController {
    
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

//    func loadColleges() {
//            let request: NSFetchRequest<CollegeEntity> = CollegeEntity.fetchRequest()
//            do {
//                colleges = try self.context.fetch(request)
//                self.tableView.reloadData()
//            } catch {
//                print("Error fetching data from context \(error)")
//            }
//        }
    
    func loadColleges() {
//            let request: NSFetchRequest<CollegeEntity> = CollegeEntity.fetchRequest()
//            do {
//                colleges = try self.context.fetch(request)
//                self.tableView.reloadData()
//            } catch {
//                print("Error fetching data from context \(error)")
//            }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext

            let url = URL(string: "https://6567cb979927836bd973d24b.mockapi.io/api/colleges")!

            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                do {
                    // Parse JSON data
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        for collegeDict in jsonResult {
                            guard let collegeId = collegeDict["collegeId"] as? String,
                                  !self.collegeExists(withId: collegeId, context: managedContext) else {
                                continue
                            }

                            // Create a new CollegeEntity
                            let newCollege = CollegeEntity(context: managedContext)
                            newCollege.collegeID = collegeId
                            newCollege.collegeName = collegeDict["collegeName"] as? String ?? ""
                            newCollege.collegeAddress = collegeDict["collegeAddress"] as? String ?? ""
                            // Handle the college logo image here (fetch from URL or similar)
                            if let logoURLString = collegeDict["logo"] as? String,
                               let logoURL = URL(string: logoURLString) {
                                self.downloadAndStoreImage(url: logoURL, for: newCollege, in: managedContext)
                            }

                            // Save the context
                            try managedContext.save()
                        }
                    }

//                    // Reload the table view on the main thread
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
                } catch let error as NSError {
                    print("Could not fetch or save data. \(error), \(error.userInfo)")
                }
            }.resume()

            let request: NSFetchRequest<CollegeEntity> = CollegeEntity.fetchRequest()
            do {
                colleges = try managedContext.fetch(request)
                // Update the table view on the main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error fetching data from context \(error)")
            }
        
    }
    
    func collegeExists(withId id: String, context: NSManagedObjectContext) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CollegeEntity")
        fetchRequest.predicate = NSPredicate(format: "collegeID == %@", id)
        let result = try? context.fetch(fetchRequest)
        return result?.count ?? 0 > 0
    }
    
    func downloadAndStoreImage(url: URL, for collegeEntity: CollegeEntity, in context: NSManagedObjectContext) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            DispatchQueue.main.async {
                collegeEntity.image = data
                do {
                    try context.save()
                } catch {
                    print("Failed to save image to Core Data: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

    
//    func collegeExists(withId id : Int64, context: NSManagedObjectContext) -> Bool {
//        print("here in the college exists",id)
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CollegeEntity")
//        print("Fine till here")
//        fetchRequest.predicate = NSPredicate(format: "id == %lld", String(id))
//        print("Not able to fetch ")
//        let result = try? context.fetch(fetchRequest)
//        return result?.count ?? 0 > 0
//        }
    
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
            if hasDependencies(collegeId: collegeToDelete.collegeID ?? "No ID") {
                presentAlert(message: "This college has associated programs or courses and cannot be deleted.")
                return
            }
                    // Proceed with deletion
            context.delete(collegeToDelete)
            saveColleges()
            colleges.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let collegeDetailVC = storyboard.instantiateViewController(withIdentifier: "UpdateCollegeController") as? UpdateCollegeController {
            collegeDetailVC.vcMode = .modify
            collegeDetailVC.college = colleges[indexPath.row]
            collegeDetailVC.context = context
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
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedCollege = colleges[indexPath.row]
                vc.college = selectedCollege
            }
        }
    }
    
    
    func hasDependencies(collegeId: String) -> Bool {
        // Check for associated programs or courses
        let programFetch: NSFetchRequest<ProgramEntity> = ProgramEntity.fetchRequest()
        programFetch.predicate = NSPredicate(format: "collegeID == %@", collegeId)
        let courseFetch: NSFetchRequest<CourseEntity> = CourseEntity.fetchRequest()
        courseFetch.predicate = NSPredicate(format: "collegeID == %@", collegeId)

        do {
            let programResults = try context.fetch(programFetch)
            let courseResults = try context.fetch(courseFetch)
            return !programResults.isEmpty || !courseResults.isEmpty
        } catch {
            print("Error checking for dependencies: \(error)")
            return true
        }
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}
