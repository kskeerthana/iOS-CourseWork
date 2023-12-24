//
//  WindowManager.swift
//  EmptyApp
//
//  Created by Keerthana Srinivasan on 10/30/23.
//  Copyright © 2023 rab. All rights reserved.
//

import SwiftUI

class WindowManager {
    private var currentView: UIView?
    private weak var containerView: UIView?

    init(containerView: UIView) {
        self.containerView = containerView
    }

    func showView(_ view: UIView) {
        currentView?.removeFromSuperview()
        containerView?.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: containerView!.topAnchor),
            view.bottomAnchor.constraint(equalTo: containerView!.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: containerView!.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: containerView!.trailingAnchor)
        ])
        currentView = view
    }
}
