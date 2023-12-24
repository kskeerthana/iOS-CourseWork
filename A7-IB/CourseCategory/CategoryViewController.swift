//
//  CategoryViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var addCCBtn: UIButton!
    @IBOutlet weak var updateCCBtn: UIButton!
    @IBOutlet weak var deleteCCBtn: UIButton!
    @IBOutlet weak var displayCCBtn: UIButton!
    @IBOutlet weak var BackBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func handleAddCC(_ sender: UIButton) {
        let viewController = AddCategoryViewController(nibName: "AddCategoryView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    
    @IBAction func handleUpdateCC(_ sender: UIButton) {
        let viewController = UpdateCategoryViewController(nibName: "UpdateCategoryView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    
    @IBAction func handledeleteCC(_ sender: UIButton) {
        let viewController = DeleteCategoryViewController(nibName: "DeleteCategoryView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleDisplayCC(_ sender: Any) {
        let viewController = DisplayCategoryViewController(nibName: "DisplayCategoryView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    @IBAction func handleBackBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
