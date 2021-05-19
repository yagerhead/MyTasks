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
    
    init(text: String) {
        self.text = text
        super.init()
    }
    
    func toggleChecked() {
        checked.toggle()
    }
}
