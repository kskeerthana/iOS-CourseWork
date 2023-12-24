//
//  MainViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/5/23.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var manageCollegeButton: UIButton!
    @IBOutlet weak var manageProgramButton: UIButton!
    @IBOutlet weak var manageCourseCatButton: UIButton!
    @IBOutlet weak var manageCourseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func handleColleges(_ sender: UIButton) {
        let viewController = CollegeViewController(nibName: "CollegeView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handlePrograms(_ sender: UIButton) {
        let viewController = ProgramViewController(nibName: "ProgramView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleCourses(_ sender: UIButton) {
        let viewController = CoursesViewController(nibName: "CoursesView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleCategory(_ sender: UIButton) {
        let viewController = CategoryViewController(nibName: "CategoryView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}
