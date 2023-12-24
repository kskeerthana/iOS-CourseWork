//
//  ProgramViewController.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import UIKit

class ProgramViewController: UIViewController {

    @IBOutlet weak var programView: UILabel!
    
    @IBOutlet weak var addProgramBtn: UIButton!
    @IBOutlet weak var updateProgramBtn: UIButton!
    @IBOutlet weak var deleteProgramBtn: UIButton!
    @IBOutlet weak var searchProgramBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func handleAdd(_ sender: UIButton) {
        let viewController = CreateProgramViewController(nibName: "CreateProgramView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }

    @IBAction func handleUpdate(_ sender: UIButton) {
        let viewController = UpdateProgramViewController(nibName: "UpdateProgramView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    
    @IBAction func handleDelete(_ sender: UIButton) {
        let viewController = DeleteProgramViewController(nibName: "DeleteProgramView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    
    @IBAction func handleSearchDisplay(_ sender: UIButton) {
        let viewController = DisplayProgramViewController(nibName: "DisplayProgramView", bundle: nil)
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    @IBAction func handleBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
