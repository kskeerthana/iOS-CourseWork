//
//  Courses.swift
//  EmptyApp
//
//  Created by Keerthana Srinivasan on 10/27/23.
//  Copyright © 2023 rab. All rights reserved.
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
    
    func update(name: String, collegeId: String, programId: String, courseCategoryId: String) {
            self.name = name
            self.collegeId = collegeId
            self.programId = programId
            self.courseCatId = courseCategoryId
        }
        
    func details() -> String {
        return "Course ID: \(courseId), Name: \(name), College ID: \(collegeId), Program ID: \(programId), Course Category ID: \(courseCatId)"
    }
}


func manageCourses() {
    var shouldContinue = true
    
    while shouldContinue {
        print("""
                1. Create Course
                2. Update Course
                3. Delete Course
                4. Search Course
                5. Display Courses
                6. Back to Main Menu
                Enter your choice:
                """)
        
        guard let actionItem = readLine() , let actionChoice = Int(actionItem) else{
            print("Invalid option. Please choose again.")
            continue
        }
        
        switch actionChoice{
        case 1:
            createCourse()
        case 2:
            updateCourse()
        case 3:
            deleteCourse()
        case 4:
            searchcourses()
        case 5:
            displayCourses()
        case 6:
            shouldContinue = false
        default:
            print("Invalid")
        }
    }
    
}

func displayCourses(){
    for (courseid,course) in Courses.courses{
        if !courseid.isEmpty && !course.name.isEmpty && !course.collegeId.isEmpty && !course.programId.isEmpty && !course.courseCatId.isEmpty && !course.courseId.isEmpty{
            print("Course ID: \(courseid), Name: \(course.name), College ID: \(course.collegeId)","Program ID: \(course.programId)","Course Category ID: \(course.courseCatId)")
        }
    }
}
   
        
func createCourse() {
    print("Enter Course ID, Name, Program ID, and Course Category ID separated by commas:")
    let input = readLine()
    
    if input == nil || input!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let inputs = input!.split(separator: ",")
    if inputs.count != 4 {
        print("Input must be in the format: Course ID, Name, Program ID, Course Category ID")
        return
    }
    
    let courseId = String(inputs[0].trimmingCharacters(in: .whitespaces))
    if Courses.courses[courseId] != nil {
        print("A course with this ID already exists.")
        return
    }
    
    let name = String(inputs[1].trimmingCharacters(in: .whitespaces))
    let programId = String(inputs[2].trimmingCharacters(in: .whitespaces))
    let courseCategoryId = String(inputs[3].trimmingCharacters(in: .whitespaces))
    
    // Getting collegeId from ProgramManager
    let program = Program.programs[programId]
    if program == nil {
        print("Program not found.")
        return
    }
    let collegeId = program!.collegeId
    
    let course = Courses(courseId: courseId, name: name, programId: programId, collegeId: collegeId, courseCatId: courseCategoryId)
    Courses.courses[courseId] = course
}

func updateCourse() {
    print("Enter old Course ID:")
    let oldIdInput = readLine()
    
    if oldIdInput == nil || oldIdInput!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let oldId = oldIdInput!.trimmingCharacters(in: .whitespaces)
    guard let oldCourse = Courses.courses[oldId] else {
        print("Course not found.")
        return
    }
    
    print("Enter new details for Course (if you want to keep the old detail, leave it as is):")
    print("New Course ID: \(oldCourse.courseId), Name: \(oldCourse.name), College ID: \(oldCourse.collegeId), Program ID: \(oldCourse.programId), Course Category ID: \(oldCourse.courseCatId)")
    let newDetailsInput = readLine()
    
    if newDetailsInput == nil || newDetailsInput!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let newDetails = newDetailsInput!.trimmingCharacters(in: .whitespaces).split(separator: ",")
    
    let newId = newDetails.count > 0 ? String(newDetails[0]) : oldCourse.courseId
    let newName = newDetails.count > 1 ? String(newDetails[1]) : oldCourse.name
    let newCollegeId = newDetails.count > 2 ? String(newDetails[2]) : oldCourse.collegeId
    let newProgramId = newDetails.count > 3 ? String(newDetails[3]) : oldCourse.programId
    let newCourseCatId = newDetails.count > 4 ? String(newDetails[4]) : oldCourse.courseCatId
    
    if newId != oldId {
        // Remove old course if the ID is changing
        Courses.courses.removeValue(forKey: oldId)
    }
    
    let updatedCourse = Courses(courseId: newId, name: newName, programId: newProgramId, collegeId: newCollegeId, courseCatId: newCourseCatId)
    Courses.courses[newId] = updatedCourse
    
    print("Course updated successfully.")
}


func deleteCourse() {
    print("Enter Course ID:")
    let input = readLine()
    
    if input == nil || input!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let id = input!.trimmingCharacters(in: .whitespaces)
    if Courses.courses[id] == nil {
        print("Course not found.")
        return
    }
    
    let courseCategoryId = Courses.courses[id]!.courseCatId
    if CourseCategory.courseCategories[courseCategoryId] == nil {
        print("Associated course category not found.")
        return
    }
    
    print("Deleting this course will also delete its associated course category. Do you want to proceed? (yes/no)")
    let confirmationInput = readLine()
    if confirmationInput?.lowercased() != "yes" {
        print("Deletion cancelled.")
        return
    }
    // Delete course
    if let deletedCourse = Courses.courses.removeValue(forKey: id) {
        print("Course \(deletedCourse.name) deleted successfully!")
    }
}

func searchcourses() {
    print("Enter the Course Name to search for:")
    if let name = readLine(), !name.isEmpty{
        var found = false
        for course in Courses.courses.values {
            if course.name == name {
                print("Course ID: \(course.courseId), Course name :\(course.name), Program ID :\(course.programId), College ID: \(course.collegeId), Course Category : \(course.courseCatId)")
                found = true
            }
        }
        
        if !found {
            print("No colleges found with the name \(name).")
        }
    }
    else {
        print("Program Name cannot be empty.")
    }
        
}
