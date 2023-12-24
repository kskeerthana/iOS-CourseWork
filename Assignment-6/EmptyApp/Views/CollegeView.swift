//
//  CollegeView.swift
//  EmptyApp
//
//  Created by Keerthana Srinivasan on 10/28/23.
//  Copyright © 2023 rab. All rights reserved.
//

import SwiftUI

@available(iOS 11.0, *)

protocol CollegeViewDelegate: AnyObject {
    func didTapBackButton(in collegeView: CollegeView)
}

@available(iOS 11.0, *)
class CollegeView: UIView {
    
    var currentActiveView: UIView?
    let manageView = ManageCollegeView()
    let backButton = UIButton(type: .system)
    weak var delegate: CollegeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMenu()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupMenu() {
        let buttonTitles = ["Create College", "Update College", "Delete College", "Search College", "Display Colleges"]
        let buttonActions: [Selector] = [#selector(createButtonTapped), #selector(updateButtonTapped), #selector(deleteButtonTapped), #selector(searchButtonTapped), #selector(displayButtonTapped)]

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: buttonActions[index], for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let topStackView = UIStackView(arrangedSubviews: [backButton, stackView])
        topStackView.axis = .vertical
        topStackView.spacing = 10
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topStackView)

        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
//            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            topStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            topStackView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            topStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8)
])
    }
    
    private func navigateToManageView(for action: ManageCollegeView.CRUDAction) {
            if let currentController = self.findViewController() {
                let manageCollegeController = ManageCollegeViewController(action: action)
                currentController.present(manageCollegeController, animated: true, completion: nil)
            }
        }

        // Helper method to get the view's view controller
    private func findViewController() -> UIViewController? {
            var nextResponder: UIResponder? = self
            while nextResponder != nil {
                if let viewController = nextResponder as? UIViewController {
                    return viewController
                }
                nextResponder = nextResponder?.next
            }
            return nil
        }

    @objc func createButtonTapped() {
//        removeCurrentActiveView()
//        manageView.configure(for: .create)
//        addSubview(manageView)
//        currentActiveView = manageView
        navigateToManageView(for: .create)
    }
    
    @objc func updateButtonTapped() {
//        removeCurrentActiveView()
//        manageView.configure(for: .create)
//        addSubview(manageView)
//        currentActiveView = manageView
        navigateToManageView(for: .update)
    }
    
    @objc func deleteButtonTapped() {
//        removeCurrentActiveView()
//        manageView.configure(for: .create)
//        addSubview(manageView)
//        currentActiveView = manageView
        navigateToManageView(for: .delete)
    }
    
    @objc func searchButtonTapped() {
//        removeCurrentActiveView()
//        manageView.configure(for: .create)
//        addSubview(manageView)
//        currentActiveView = manageView
        navigateToManageView(for: .search)
        
    }
    
    @objc func displayButtonTapped() {
//        removeCurrentActiveView()
//        manageView.configure(for: .create)
//        addSubview(manageView)
//        currentActiveView = manageView
        navigateToManageView(for: .display)
    }

    func removeCurrentActiveView() {
            currentActiveView?.removeFromSuperview()
            currentActiveView = nil
        }
    
    @objc func backButtonTapped() {
        delegate?.didTapBackButton(in: self)
    }
    
    


    
}
