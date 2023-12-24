//
//  Programs.swift
//  Assignment-5
//
//  Created by Keerthana Srinivasan on 10/20/23.
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
    
    func update(name: String, collegeId: String) {
        self.name = name
        self.collegeId = collegeId
    }
    
    func details() -> String {
        return "Program ID: \(id), Name: \(name), College ID: \(collegeId)"
    }
}


func managePrograms() {
    var shouldContinue = true
    
    while shouldContinue {
        print("""
                1. Create Program
                2. Update Program
                3. Delete Program
                4. Search Program
                5. Display Programs
                6. Back to Main Menu
                Enter your choice:
                """)
        
        guard let actionItem = readLine() , let actionChoice = Int(actionItem) else{
            print("Invalid option. Please choose again.")
            continue
        }
        
        switch actionChoice{
        case 1:
            createProgram()
        case 2:
            updateProgram()
        case 3:
            deleteProgram()
        case 4:
            searchProgram()
        case 5:
            displayPrograms()
        case 6:
            shouldContinue = false
        default:
            print("Invalid")
        }
    }
}
    
    
func displayPrograms(){
    for (programid,program) in Program.programs{
        if !programid.isEmpty && !program.name.isEmpty && !program.collegeId.isEmpty{
            print("Program ID: \(programid), Name: \(program.name), College ID: \(program.collegeId)")
        }
    }
}
    
func createProgram() {
    print("Enter Program ID, Program Name, and College ID separated by commas:")
    if let input = readLine(), !input.isEmpty {
        let inputs = input.split(separator: ",")
        if inputs.count == 3{
            let id = String(inputs[0])
            let name = String(inputs[1])
            let collegeId = String(inputs[2])
            
            guard Colleges.colleges[collegeId] != nil else {
                print("No college found with the specified College ID.")
                return
            }
            
            if Program.programs[id] == nil{
                let program = Program(id: id, name: name, collegeId: collegeId)
                Program.programs[id] = program
                print("Added program!")
                displayPrograms()
            }
            else {
                print("A program with this ID already exists.")
            }
        }
        else {
            print("Input must be in the format: Program ID, Program Name, College ID")
            
        }
    }
    else {
        print("Input cannot be empty.")
    }
}
    
    
func updateProgram() {
    print("Enter old Program ID:")
    let oldIdInput = readLine()
    
    if oldIdInput == nil || oldIdInput!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let oldId = oldIdInput!.trimmingCharacters(in: .whitespaces)
    guard let oldProgram = Program.programs[oldId] else {
        print("Program not found.")
        return
    }
    
    print("Enter new details for Program (if you want to keep the old detail, leave it as is):")
    print("New Program ID: \(oldProgram.id), Name: \(oldProgram.name), College ID: \(oldProgram.collegeId)")
    let newDetailsInput = readLine()
    
    if newDetailsInput == nil || newDetailsInput!.isEmpty {
        print("Input cannot be empty.")
        return
    }
    
    let newDetails = newDetailsInput!.trimmingCharacters(in: .whitespaces).split(separator: ",")
    
    let newId = newDetails.count > 0 ? String(newDetails[0]) : oldProgram.id
    let newName = newDetails.count > 1 ? String(newDetails[1]) : oldProgram.name
    let newCollegeId = newDetails.count > 2 ? String(newDetails[2]) : oldProgram.collegeId
    
    if newId != oldId {
        // Remove old program if the ID is changing
        Program.programs.removeValue(forKey: oldId)
    }
    
    let updatedProgram = Program(id: newId, name: newName, collegeId: newCollegeId)
    Program.programs[newId] = updatedProgram
    
    print("Program updated successfully!")
    displayPrograms()
}

    
func deleteProgram(){
    print("Enter Program ID:")
        let input = readLine()
        
        if input == nil || input!.isEmpty {
            print("Input cannot be empty.")
            return
        }
        
        let id = input!.trimmingCharacters(in: .whitespaces)
        if Program.programs[id] == nil {
            print("Program not found.")
            return
        }
        
        // Check for associated courses
        var hasAssociatedCourses = false
        for course in Courses.courses.values {
            if course.programId == id {
                hasAssociatedCourses = true
                break
            }
        }
        
        if hasAssociatedCourses {
            print("Deleting this program will also delete its associated courses. Do you want to proceed? (yes/no)")
            let confirmationInput = readLine()
            if confirmationInput?.lowercased() != "yes" {
                print("Deletion cancelled.")
                return
            }
            
            // Delete associated courses
            for course in Courses.courses.values {
                if course.programId == id {
                    Courses.courses.removeValue(forKey: course.courseId)
                }
            }
        }
        
        if let deletedP = Program.programs.removeValue(forKey: id) {
            print("Program and its associated courses deleted successfully!")
            displayPrograms()
        }
}


func searchProgram() {
    print("Enter the Program Name to search for:")
    if let name = readLine(), !name.isEmpty{
        var found = false
        for program in Program.programs.values {
            if program.name == name {
                print(program.details())
                found = true
            }
        }
        
        if !found {
            print("No programs found with the name \(name).")
        }
    }
    else {
        print("Program Name cannot be empty.")
    }
        
}

