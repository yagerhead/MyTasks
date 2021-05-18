//
//  DataModel.swift
//  MyTasks
//
//  Created by Manu Safarov on 18.05.2021.
//

import Foundation

class DataModel {
    var lists = [Tasks]()
    
    var indexOfSelectedTask: Int {
        get {
            return UserDefaults.standard.integer(forKey: "TaskIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TaskIndex")
        }
    }
    
    init() {
        loadTasks()
        registerDefaults()
        handleFirstTime()
    }
    
    /*
     To prevent the app from crashing in the absence of data.
     When the index of the dataModel array is zero, the application crashes.
     */
    func registerDefaults() {
        let dictionary = ["TaskIndex": -1, "FirstTime": true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Tasks(name: "List")
            lists.append(checklist)
            indexOfSelectedTask = 0
            
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("MyTasks.plist")
    }
    
    func saveTasks() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }
    
    func loadTasks() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Tasks].self, from: data)
            } catch {
                print("Error decoding list array: \(error.localizedDescription)")
            }
        }
    }
}
