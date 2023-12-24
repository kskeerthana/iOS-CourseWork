//
//  CollegeViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/5/23.
//

import UIKit

class CollegeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handleCreate(_ sender: UIButton) {
        let viewController = CreateCollegeViewController(nibName: "CreateCollegeView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleUpdate(_ sender: UIButton) {
        let viewController = UpdateCollegeViewController(nibName: "UpdateCollegeView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleDelete(_ sender: UIButton) {
        let viewController = DeleteCollegeViewController(nibName: "DeleteCollegeView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleView(_ sender: UIButton) {
        let viewController = DisplayCollegeViewController(nibName: "DisplayCollegeView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    
    @IBAction func handleClose(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
