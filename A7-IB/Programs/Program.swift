//
//  Programs.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import Foundation
class Program {
    var id: String
    var name: String
    var collegeId: String
    static var programs: [String: Program] = [
        "IS": Program(id: "IS", name: "Information Systems", collegeId: "COE"),
        "SES": Program(id: "SES", name: "Software Engg", collegeId: "COE")
        ]
    
    init(id: String, name: String, collegeId: String) {
        self.id = id
        self.name = name
        self.collegeId = collegeId
    }
}
