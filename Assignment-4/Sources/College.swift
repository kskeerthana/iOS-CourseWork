//
//  File.swift
//  
//
//  Created by Keerthana Srinivasan on 10/13/23.
//

import Foundation

class College {
    var name: String
    var programs: [Program]
    
    init(name: String) {
        self.name = name
        self.programs = []
    }
    
    func addProgram(program: Program) {
        programs.append(program)
    }
    
    func deleteProgram(programName: String) {
        programs.removeAll { $0.name == programName }
    }
    
    func updateProgram(oldName: String, newName: String) {
        if let index = programs.firstIndex(where: { $0.name == oldName }) {
            programs[index].name = newName
        }
    }
}
