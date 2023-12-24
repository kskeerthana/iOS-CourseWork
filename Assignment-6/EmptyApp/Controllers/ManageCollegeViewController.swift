//
//  ManageCollegeViewController.swift
//  EmptyApp
//
//  Created by Keerthana Srinivasan on 10/29/23.
//  Copyright © 2023 rab. All rights reserved.
//

import SwiftUI

import UIKit

class ManageCollegeViewController: UIViewController {
    
    private var manageView: ManageCollegeView!
    var action: ManageCollegeView.CRUDAction!
    
    init(action: ManageCollegeView.CRUDAction) {
        super.init(nibName: nil, bundle: nil)
        self.action = action
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageView = ManageCollegeView(frame: self.view.bounds)
        manageView.configure(for: action)
        self.view.addSubview(manageView)
    }
    
    // Add other necessary methods if needed.
}


