//
//  College.swift
//  A9-Storyboard
//
//  Created by Keerthana Srinivasan on 11/19/23.
//

import Foundation
class College{
    var collegeId : String
    var name : String
    var address : String
    //    var programs : [Program]
    
    static var colleges: [String: College] = ["COE": College(collegeId: "COE", name: "College of Engg", address: "376 Huntington")]
    
    init(collegeId: String, name: String, address: String) {
        self.collegeId = collegeId
        self.name = name
        self.address = address
    }
    
    convenience init() {
        self.init(collegeId: "", name: "", address: "")
    }
    
}
