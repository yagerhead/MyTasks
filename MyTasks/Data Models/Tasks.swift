//
//  AllTasks.swift
//  MyTasks
//
//  Created by Manu Safarov on 18.05.2021.
//

import UIKit

class Tasks: NSObject, Codable {
    var name = ""
    var items = [TasksListItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
