//
//  CourseCategory.swift
//  EmptyApp
//
//  Created by Keerthana Srinivasan on 10/27/23.
//  Copyright © 2023 rab. All rights reserved.
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
    
    func update(name: String) {
            self.name = name
        }
        
    func details() -> String {
        return "Course Category ID: \(CourseCatId), Name: \(name)"
    }
}

func manageCourseCategory() {
    var shouldContinue = true
    
    while shouldContinue {
        print("""
                1. Create CourseCategory
                2. Update CourseCategory
                3. Delete CourseCategory
                4. Search CourseCategory
                5. Display course categories
                6. Back to Main Menu
                Enter your choice:
                """)
        
        guard let actionItem = readLine() , let actionChoice = Int(actionItem) else{
            print("Invalid option. Please choose again.")
            continue
        }
        
        switch actionChoice{
        case 1:
            createCourseCategory()
        case 2:
            updateCourseCategory()
        case 3:
            deleteCourseCategory()
        case 4:
            searchCourseCategory()
        case 5:
            print("Display all Course Categories")
            displayCourseCategory()
        case 6:
            shouldContinue = false
        default:
            print("Invalid")
        }
    }
    
}

func displayCourseCategory() {
    for (courseid,course) in CourseCategory.courseCategories{
        if !courseid.isEmpty && !course.name.isEmpty {
            print("Course Category ID: \(courseid), Name: \(course.name)")
        }
    }
}

func createCourseCategory() {
    print("Enter Course Category ID and Name separated by a comma:")
    let input = readLine()
    
    if let input = input, !input.isEmpty {
        let inputs = input.split(separator: ",")
        if inputs.count == 2 {
            let courseCatId = String(inputs[0].trimmingCharacters(in: .whitespaces))
            if CourseCategory.courseCategories[courseCatId] != nil {
                    print("A course category with this ID already exists.")
                    return
                }
            
            let name = String(inputs[1].trimmingCharacters(in: .whitespaces))
            let courseCategory = CourseCategory(CourseCatId: courseCatId, name: name)
            CourseCategory.courseCategories[courseCatId] = courseCategory
            print("Course category created successfully!")
        } else {
            print("Input must be in the format: Course Category ID, Name")
        }
    } else {
        print("Input cannot be empty.")
    }
}
    
func updateCourseCategory() {
    print("Enter old Course Category ID:")
    let oldIdInput = readLine()
    
    if oldIdInput == nil || oldIdInput!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let oldId = oldIdInput!.trimmingCharacters(in: .whitespaces)
    guard let oldCourseCategory = CourseCategory.courseCategories[oldId] else {
        print("Course category not found.")
        return
    }
    
    print("Enter new Course Category ID and Name separated by a comma:")
    let newDetailsInput = readLine()
    
    if newDetailsInput == nil || newDetailsInput!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let newDetails = newDetailsInput!.split(separator: ",")
    if newDetails.count != 2 {
        print("Input must be in the format: new Course Category ID, Name")
        return
    }
    
    let newId = String(newDetails[0].trimmingCharacters(in: .whitespaces))
    let newName = String(newDetails[1].trimmingCharacters(in: .whitespaces))
    
    if newId != oldId {
        // Remove old course category if the ID is changing
        CourseCategory.courseCategories.removeValue(forKey: oldId)
    }
    
    let updatedCourseCategory = CourseCategory(CourseCatId: newId, name: newName)
    CourseCategory.courseCategories[newId] = updatedCourseCategory
    
    print("Course category updated successfully!")
}



func deleteCourseCategory() {
    print("Enter Course Category ID:")
    let input = readLine()
    
    if input == nil || input!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let courseCatId = input!.trimmingCharacters(in: .whitespaces)
    if CourseCategory.courseCategories.removeValue(forKey: courseCatId) != nil {
        // Iterate through the courses and delete the courses associated with the deleted course category
        var courseIdsToDelete = [String]()
        for (courseId, course) in Courses.courses {
            if course.courseCatId == courseCatId {
                courseIdsToDelete.append(courseId)
            }
        }
        
        for courseId in courseIdsToDelete {
            Courses.courses.removeValue(forKey: courseId)
        }
        
        print("Course category and associated courses deleted successfully!")
    } else {
        print("Course category not found.")
    }
}


func searchCourseCategory() {
    print("Enter Course Category Name:")
    let input = readLine()
    
    if input == nil || input!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let name = input!.trimmingCharacters(in: .whitespaces)
    var found = false
    for courseCategory in CourseCategory.courseCategories.values {
        if courseCategory.name.lowercased() == name.lowercased() {
            print(courseCategory.details())
            found = true
        }
    }
    
    if !found {
        print("No course category found with the specified name.")
    }
}
