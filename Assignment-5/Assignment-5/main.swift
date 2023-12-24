//
//  main.swift
//  Assignment-5
//
//  Created by Keerthana Srinivasan on 10/20/23.
//


var shouldContinue = true
while shouldContinue {
    print("""
        1. Manage Programs
        2. Manage Courses
        3. Manage Course Categories
        4. Manage Colleges
        5. Exit
        Enter your choice:
        """)
    
    if let choice = readLine(), let option = Int(choice) {
        switch option {
            case 1:
                managePrograms()
            case 2:
                manageCourses()
            case 3:
                manageCourseCategory()
            case 4:
                manageColleges()
            case 5:
                shouldContinue = false
            default:
                print("Invalid choice. Please try again.")
        }
    } else {
        print("Invalid input. Please enter a number.")
    }
}
