//
//  CoursesViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit

class CoursesViewController: UIViewController {

    @IBOutlet weak var addCourseBtn: UIButton!
    @IBOutlet weak var updateCourseBtn: UIButton!
    @IBOutlet weak var deleteCourseBtn: UIButton!
    @IBOutlet weak var searchCourseBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func handleAddCourse(_ sender: UIButton) {
        let viewController = AddCourseViewController(nibName: "AddCoursesView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleUpdateCourse(_ sender: UIButton) {
        let viewController = UpdateCourseViewController(nibName: "UpdateCoursesView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleDeleteCourse(_ sender: UIButton) {
        let viewController = DeleteCourseViewController(nibName: "DeleteCourseView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleCoursesDisplay(_ sender: Any) {
        let viewController = DisplayCoursesViewController(nibName: "DisplayCoursesView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
