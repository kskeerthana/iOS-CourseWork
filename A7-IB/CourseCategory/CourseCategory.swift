//
//  CourseCategory.swift
//  A7-IB
//
//  Created by Keerthana Srinivasan on 11/7/23.
//

import Foundation
class CourseCategory{
    var CourseCatId : String
    var name : String
    static var courseCategories : [String: CourseCategory] = [
            "CSYE": CourseCategory(CourseCatId: "CSYE", name: "Software Engineering"),
            "INFO": CourseCategory(CourseCatId: "INFO", name: "Information Systems")
            ]
    
    init(CourseCatId: String, name: String) {
        self.CourseCatId = CourseCatId
        self.name = name
    }
}
