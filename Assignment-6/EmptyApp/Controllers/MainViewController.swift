//
//  MainViewController.swift
//  EmptyApp
//
//  Created by Keerthana Srinivasan on 10/29/23.
//  Copyright © 2023 rab. All rights reserved.
//
import SwiftUI
@available(iOS 11.0, *)
class MainViewController: UIViewController {
    private var windowManager: WindowManager!
    

    init() {
        super.init(nibName: nil, bundle: nil)
        self.windowManager = WindowManager(containerView: self.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Other setup code
    }
}
