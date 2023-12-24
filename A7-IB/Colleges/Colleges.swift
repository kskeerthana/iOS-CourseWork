//
//  Colleges.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/6/23.
//

import Foundation
class Colleges{
    var collegeId : String
    var name : String
    var address : String
    //    var programs : [Program]
    
    static var colleges: [String: Colleges] = ["COE": Colleges(collegeId: "COE", name: "College of Engg", address: "376 Huntington")]
    
    init(collegeId: String, name: String, address: String) {
        self.collegeId = collegeId
        self.name = name
        self.address = address
        //        COEself.programs = []
    }
    
    convenience init() {
        self.init(collegeId: "", name: "", address: "")
    }
    
}
