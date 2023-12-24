//
//  CreateCollegeView.swift
//  EmptyApp
//
//  Created by Keerthana Srinivasan on 10/28/23.
//  Copyright © 2023 rab. All rights reserved.
//
import SwiftUI

class ManageCollegeView: UIView {
    // Shared UI components
    var collegeIdField: UITextField!
    var collegeNameField: UITextField!
    var collegeAddressField: UITextField!
    var actionButton: UIButton!
    let backButton = UIButton(type: .system)
    var currentAction: CRUDAction = .create

    enum CRUDAction {
        case create, update, search, delete, display
    }
    
    private let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 10
            stack.distribution = .fillEqually
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommonUI()
//        setupStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topViewController = UIApplication.shared.keyWindow?.rootViewController

        while let presentedViewController = topViewController?.presentedViewController {
            topViewController = presentedViewController
        }

        return topViewController
    }

    
    private func setupStackView() {
        addSubview(stackView)
            
            // Add Constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        // Add subviews to stackView
        stackView.addArrangedSubview(collegeIdField)
        stackView.addArrangedSubview(collegeNameField)
        stackView.addArrangedSubview(collegeAddressField)
        stackView.addArrangedSubview(actionButton)
    }
    
    func setupCommonUI() {
        collegeIdField = createTextField(placeholder: "College ID")
        collegeNameField = createTextField(placeholder: "College Name")
        collegeAddressField = createTextField(placeholder: "College Address")
        
        actionButton = UIButton(type: .system)
        actionButton.setTitle("Create College", for: .normal)
        actionButton.setTitleColor(.white, for: .normal) // Set text color to red
        actionButton.backgroundColor = .blue
//        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

         setupStackView()
    }
    
    @objc func backButtonTapped() {
            removeFromSuperview() // This will remove the ManageCollegeView from CollegeView
        }

    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }

    func configure(for action: CRUDAction) {
        currentAction = action
        actionButton.removeTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside) // Remove previoutarget
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside) // Set new target
        
        switch action {
        case .create:
            print("Create College")
            collegeNameField.isHidden = false
            collegeAddressField.isHidden = false
            actionButton.setTitle("Create College", for: .normal)
        case .update:
            // Hide or show necessary fields and set the button title
            // e.g.
            collegeNameField.isHidden = false
            collegeAddressField.isHidden = false
            actionButton.setTitle("Update College", for: .normal)
        case .search:
            collegeNameField.isHidden = true
            collegeAddressField.isHidden = true
            actionButton.setTitle("Search College", for: .normal)
        case .delete:
            collegeNameField.isHidden = true
            collegeAddressField.isHidden = true
            actionButton.setTitle("Delete College", for: .normal)
        case .display:
            // Logic for display
            actionButton.setTitle("Display Colleges", for: .normal)
        }
    }

    @objc func actionButtonTapped() {
        switch currentAction {
        case .create:
            // Handle creation logic
            print("create college action")
            let id = collegeIdField.text ?? ""
            let name = collegeNameField.text ?? ""
            let address = collegeAddressField.text ?? ""
            if id.isEmpty || name.isEmpty || address.isEmpty {
                showAlert(title: "Error", message: "All fields must be filled out for creation.")
            } else {
                // Call a method or function to create the college
                showAlert(title: "Success", message:"College Created!")
            }

        case .update:
            // Handle update logic
            let id = collegeIdField.text ?? ""
            let name = collegeNameField.text ?? ""
            let address = collegeAddressField.text ?? ""
            if id.isEmpty || (name.isEmpty && address.isEmpty) {
                showAlert(title: "Error", message:"College ID and at least one field (name or address) must be filled out for update.")
            } else {
                // Call a method or function to update the college
                showAlert(title:"Success" , message: "College Updated!")
            }

        case .search:
            // Handle search logic
            let id = collegeIdField.text ?? ""
            if id.isEmpty {
                print("College ID must be filled out for search.")
            } else {
                // Call a method or function to search for the college
                print("Search Completed!")
            }

        case .delete:
            // Handle delete logic
            let id = collegeIdField.text ?? ""
            if id.isEmpty {
                print("College ID must be filled out for deletion.")
            } else {
                // Call a method or function to delete the college
                print("College Deleted!")
            }

        case .display:
            // Handle display logic
            // Call a method or function to display all colleges
            print("Colleges Displayed!")
        }
    }
    
    func showAlert(title: String, message: String) {
        if let topViewController = getTopMostViewController() {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }

}
