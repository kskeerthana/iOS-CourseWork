//
//  File.swift
//  
//
//  Created by Keerthana Srinivasan on 10/13/23.
//

import Foundation

class Program {
    var name: String
    
    var courses: [Courses]
        
        init(name: String) {
            self.name = name
            self.courses = []
        }
        
        func addCourse(course: Courses) {
            courses.append(course)
        }
        
        func deleteCourse(courseName: String) {
            courses.removeAll { $0.name == courseName }
        }
        
        func updateCourse(oldName: String, newName: String) {
            if let index = courses.firstIndex(where: { $0.name == oldName }) {
                courses[index].name = newName
            }
        }
}
