//
//  File.swift
//  
//
//  Created by Keerthana Srinivasan on 10/13/23.
//

import Foundation

import Foundation

extension String {
    var isEmail: Bool {
        return self.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .regularExpression) != nil
    }
}
