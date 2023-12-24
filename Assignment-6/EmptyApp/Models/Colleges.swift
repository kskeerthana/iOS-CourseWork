//
//  Colleges.swift
//  EmptyApp
//
//  Created by Keerthana Srinivasan on 10/27/23.
//  Copyright © 2023 rab. All rights reserved.
//

import Foundation
class Colleges{
    var collegeId : String
    var name : String
    var address : String
    var programs : [Program]
    
    static var colleges: [String: Colleges] = ["COE": Colleges(collegeId: "COE", name: "College of Engg", address: "360 Huntington")]
    
    init(collegeId: String, name: String, address: String) {
        self.collegeId = collegeId
        self.name = name
        self.address = address
        self.programs = []
    }
    
    convenience init() {
        self.init(collegeId: "", name: "", address: "")
    }
    
    func update(id: String, name: String) {
        self.collegeId = id
        self.name = name
    }
    
    func details() -> String {
        return "College ID: \(collegeId), Name: \(name), Address: \(address)"
    }
    
}
   
func manageColleges() {
    var shouldContinue = true
    
    while shouldContinue {
        print("""
                1. Create College
                2. Update Collge
                3. Delete College
                4. Search College
                5. Display Colleges
                6. Back to Main Menu
                Enter your choice:
                """)
        
        guard let actionItem = readLine() , let actionChoice = Int(actionItem) else{
            print("Invalid option. Please choose again.")
            continue
        }
        
        switch actionChoice{
        case 1:
            createCollege()
        case 2:
            updateCollege()
        case 3:
            deleteCollege()
        case 4:
            searchCollege()
        case 5:
            displayColleges()
        case 6:
            shouldContinue = false
        default:
            print("Invalid")
        }
    }
    
}


func displayColleges(){
        for (collegeid,college) in Colleges.colleges{
            if !collegeid.isEmpty && !college.name.isEmpty && !college.address.isEmpty{
                print("College ID: \(collegeid), Name: \(college.name), Address: \(college.address)")
            }
        }
    }
    
func createCollege(){
    print("Enter College ID, College Name, and Address separated by commas:")
    if let input = readLine(), !input.isEmpty {
        let inputs = input.split(separator: ",")
        if inputs.count == 3{
            let id = String(inputs[0])
            let name = String(inputs[1])
            let address = String(inputs[2])
            
            if Colleges.colleges[id] == nil{
                let college = Colleges(collegeId: id, name: name, address: address)
                Colleges.colleges[id] = college
                print("Added College!")
                displayColleges()
            }
            else {
                print("A college with this ID already exists.")
            }
        }
        else {
            print("Input must be in the format: College ID, College Name, Address")
            
        }
    }
    else {
        print("Input cannot be empty.")
    }
}

func updateCollege() {
    print("Enter old College ID:")
    let oldIdInput = readLine()
    
    if oldIdInput == nil || oldIdInput!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let oldId = oldIdInput!.trimmingCharacters(in: .whitespaces)
    guard let oldCollege = Colleges.colleges[oldId] else {
        print("College not found.")
        return
    }
    
    print("Enter new details for College (if you want to keep the old detail, leave it as is):")
    print("New College ID: \(oldCollege.collegeId), Name: \(oldCollege.name), Address: \(oldCollege.address)")
    let newDetailsInput = readLine()
    
    if newDetailsInput == nil || newDetailsInput!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let newDetails = newDetailsInput!.trimmingCharacters(in: .whitespaces).split(separator: ",")
    
    let newId = newDetails.count > 0 ? String(newDetails[0]) : oldCollege.collegeId
    let newName = newDetails.count > 1 ? String(newDetails[1]) : oldCollege.name
    let newAddress = newDetails.count > 2 ? String(newDetails[2]) : oldCollege.address
    
    if newId != oldId {
        // Remove old college if the ID is changing
        Colleges.colleges.removeValue(forKey: oldId)
    }
    
    let updatedCollege = Colleges(collegeId: newId, name: newName, address: newAddress)
    Colleges.colleges[newId] = updatedCollege
    
    print("College updated successfully!")
    displayColleges()
}


func deleteCollege() {
    print("Enter College ID:")
    let input = readLine()
    
    if input == nil || input!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let id = input!.trimmingCharacters(in: .whitespaces)
    if Colleges.colleges[id] == nil {
        print("College not found.")
        return
    }
    
    print("Deleting this college will also delete its respective programs and courses. Do you want to proceed? (yes/no)")
    let confirmationInput = readLine()
    if confirmationInput?.lowercased() != "yes" {
        print("Deletion cancelled.")
        return
    }
    
    // Delete respective programs and courses
    for program in Program.programs.values {
        if program.collegeId == id {
            Program.programs.removeValue(forKey: program.id)
            for course in Courses.courses.values {
                if course.programId == program.id {
                    Courses.courses.removeValue(forKey: course.courseId)
                }
            }
        }
    }
    if let deletedC = Colleges.colleges.removeValue(forKey: id) {
        print("College and its respective programs and courses deleted successfully!")
        displayColleges()
    }
}



func searchCollege() {
    print("Enter the College Name to search for:")
    if let name = readLine(), !name.isEmpty{
        var found = false
        for college in Colleges.colleges.values {
            if college.name == name {
                displayColleges()
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
