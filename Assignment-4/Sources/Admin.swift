//
//  File.swift
//  Assignment-4
//
//  Created by Keerthana Srinivasan on 10/13/23.
//

import Foundation

class Admin {
    private var email: String
    private var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func validateCredentials(inputEmail: String, inputPassword: String) -> Bool {
        return email == inputEmail && password == inputPassword
    }
}
