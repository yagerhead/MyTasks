//
//  TasksListItem.swift
//  MyTasks
//
//  Created by Manu Safarov on 15.05.2021.
//

import Foundation

class TasksListItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked.toggle()
    }
}
