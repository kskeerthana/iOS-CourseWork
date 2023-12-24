// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

let initialCourse = Courses(name: "Smart Contract Engineering")
let initialProgram = Program(name: "SES")
initialProgram.courses.append(initialCourse)
let initialCollege = College(name: "Bentlee")
initialCollege.programs.append(initialProgram)

var colleges: [College] = [initialCollege]

let admin = Admin(email: "admin@bentlee.edu", password: "admin123")

while true {
    print("1. Login")
    print("2. Exit")
    
    guard let choice = readLine(), let option = Int(choice) else {
        print("Invalid option. Please choose again.")
        continue
    }
    
    switch option {
    case 1:
        print("Enter email:")
        guard let email = readLine(), email.isEmail else {
            print("Invalid email format! Try again.")
            continue
        }
        
        print("Enter password:")
        guard let password = readLine(), admin.validateCredentials(inputEmail: email, inputPassword: password) else {
            print("Incorrect credentials! Try again.")
            continue
        }
        
        while true {
            print("1. Display All Colleges")
            print("2. Add a College")
            print("3. Update a College")
            print("4. Delete a College")
            print("5. Manage Programs for a College")
            print("6. Logout")
            
            guard let adminChoice = readLine(), let adminOption = Int(adminChoice) else {
                print("Invalid option. Please choose again.")
                continue
            }
            
            switch adminOption {
            case 1:
                for college in colleges {
                    print(college.name)
                }

            case 2:
                print("Enter college name:")
                if let name = readLine() {
                    let college = College(name: name)
                    colleges.append(college)
                }

            case 3:
                print("Enter old college name:")
                if let oldName = readLine() {
                    print("Enter new college name:")
                    if let newName = readLine(), let index = colleges.firstIndex(where: { $0.name == oldName }) {
                        colleges[index].name = newName
                    }
                }

            case 4:
                print("Enter college name to delete:")
                if let name = readLine() {
                    if let college = colleges.first(where: { $0.name == name }), college.programs.count > 0 {
                        print("Can't delete college with programs.")
                    } else {
                        colleges.removeAll { $0.name == name }
                    }
                }

            case 5:
                print("Enter the college name:")
                if let collegeName = readLine(), let college = colleges.first(where: { $0.name == collegeName }) {
                    while true {
                        print("1. Display All Programs")
                        print("2. Add a Program")
                        print("3. Update a Program")
                        print("4. Delete a Program")
                        print("5. Manage Courses for a Program")
                        print("6. Go back to previous menu")

                        guard let programChoice = readLine(), let programOption = Int(programChoice) else {
                            print("Invalid option. Please choose again.")
                            continue
                        }
                        
                        switch programOption {
                        case 1:
                            for program in college.programs {
                                print(program.name)
                            }

                        case 2:
                            print("Enter program name:")
                            if let programName = readLine() {
                                let program = Program(name: programName)
                                college.programs.append(program)
                            }

                        case 3:
                            print("Enter old program name:")
                            if let oldName = readLine() {
                                print("Enter new program name:")
                                if let newName = readLine() {
                                    college.programs.first(where: { $0.name == oldName })?.name = newName
                                }
                            }

                        case 4:
                            print("Enter program name to delete:")
                            if let programName = readLine() {
                                if let program = college.programs.first(where: { $0.name == programName }), program.courses.count > 0 {
                                    print("Can't delete program with courses.")
                                } else {
                                    college.programs.removeAll { $0.name == programName }
                                }
                            }

                        case 5:
                            print("Enter the program name:")
                            if let programName = readLine(), let program = college.programs.first(where: { $0.name == programName }) {
                                while true {
                                    print("1. Display All Courses")
                                    print("2. Add a Course")
                                    print("3. Update a Course")
                                    print("4. Delete a Course")
                                    print("5. Go back to previous menu")

                                    guard let courseChoice = readLine(), let courseOption = Int(courseChoice) else {
                                        print("Invalid option. Please choose again.")
                                        continue
                                    }

                                    switch courseOption {
                                    case 1:
                                        for course in program.courses {
                                            print(course.name)
                                        }

                                    case 2:
                                        print("Enter course name:")
                                        if let courseName = readLine() {
                                            let course = Courses(name: courseName)
                                            program.courses.append(course)
                                        }

                                    case 3:
                                        print("Enter old course name:")
                                        if let oldName = readLine() {
                                            print("Enter new course name:")
                                            if let newName = readLine() {
                                                program.courses.first(where: { $0.name == oldName })?.name = newName
                                            }
                                        }

                                    case 4:
                                        print("Enter course name to delete:")
                                        if let courseName = readLine() {
                                            program.courses.removeAll { $0.name == courseName }
                                        }

                                    case 5:
                                        break

                                    default:
                                        print("Invalid option")
                                    }

                                    if courseOption == 5 {
                                        break
                                    }
                                }
                            } else {
                                print("Program not found!")
                            }

                        case 6:
                            break

                        default:
                            print("Invalid option")
                        }

                        if programOption == 6 {
                            break
                        }
                    }
                } else {
                    print("College not found!")
                }

            case 6:
                break

            default:
                print("Invalid option")
            }

            if adminOption == 6 {
                break
            }
        }

    case 2:
        exit(0)

    default:
        print("Invalid option. Please choose again.")
    }
}
