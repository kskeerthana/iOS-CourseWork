//
//  Courses.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import Foundation
class Courses{
    var courseId : String
    var name : String
    var collegeId : String
    var programId : String
    var courseCatId : String
    var programs : [Program]
    
    static var courses: [String: Courses] = ["INFO7500": Courses(courseId: "INFO7500", name: "Smart Contracts", programId: "IS", collegeId:"COE", courseCatId: "INFO")]
    
    init(courseId: String, name: String, programId: String, collegeId: String,courseCatId: String) {
        self.courseId = courseId
        self.name = name
        self.programId = programId
        self.collegeId = collegeId
        self.courseCatId = courseCatId
        self.programs = []
    }
    
    convenience init(){
        self.init(courseId:"",name: "",programId: "", collegeId:"",courseCatId: "")
    }
    
}
