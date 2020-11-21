//
//  List.swift
//  Reminder App
//
//  Created by Alina Turbina on 06.05.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import UIKit
import os.log
import Foundation
import Firebase

// class List: NSObject, NSCoding  {
//
//     //MARK: Properties
//
//     var id: UUID
//     var name: String
//     var tasks: [Task]
//
//     //MARK: Archiving Paths
//     static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//     static let ArchiveURL = DocumentsDirectory.appendingPathComponent("lists")
//
//     //MARK: Types
//
//     struct PropertyKey {
//         static let id = "id"
//         static let name = "name"
//         static let tasks = "tasks"
//     }
//
//     //MARK: Initialization
//
//     init?(id: UUID, name: String, tasks:[Task]) {
//
//         // The name must not be empty
//         guard !name.isEmpty else {
//             return nil
//         }
//
//         // Initialize stored properties.
//         self.id = id
//         self.name = name
//         self.tasks = tasks
//
//     }
//
//     //MARK: NSCoding
//
//     func encode(with aCoder: NSCoder) {
//         aCoder.encode(id, forKey: PropertyKey.id)
//         aCoder.encode(name, forKey: PropertyKey.name)
//         aCoder.encode(tasks, forKey: PropertyKey.tasks)
//     }
//
//     required convenience init?(coder aDecoder: NSCoder) {
//
//         // The name is required. If we cannot decode a name string, the initializer should fail.
//         guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
//             os_log("Unable to decode the name for a List object.", log: OSLog.default, type: .debug)
//             return nil
//         }
//
//         guard let id = aDecoder.decodeObject(forKey: PropertyKey.id) as? UUID else {
//             os_log("Unable to decode the name for a List object.", log: OSLog.default, type: .debug)
//             return nil
//         }
//
//
//         guard let tasks = aDecoder.decodeObject(forKey: PropertyKey.tasks) as? [Task] else {
//             os_log("Unable to decode the tasks for a List object.", log: OSLog.default, type: .debug)
//             return nil
//         }
//
//
//         // Must call designated initializer.
//         self.init(id: id, name: name, tasks: tasks)
//
//     }
// }

struct List {
  
var ref: DatabaseReference?
let id: String
var name: String
var tasks: [Task]
  
init(id: String, name: String, tasks:[Task]) {
    // Initialize stored properties.
    self.ref = nil
    self.id = id
    self.name = name
    self.tasks = tasks
    
}
  
init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let id = value["id"] as? String,
      let name = value["name"] as? String else {
      return nil
    }
        
    self.ref = snapshot.ref
    self.name = name
    self.id = id
    
    var tasks: [Task] = []
    
    // guard let tasks = value["tasks"] as? [Task] else {
    //     self.tasks = []
    //     return
    // }
    // self.tasks = tasks
    
    if (!(value["tasks"] == nil)) {
        for task in value["tasks"] as! NSMutableDictionary {
            guard
              let value = task.value as? [String: AnyObject],
              let id = value["id"] as? String,
              let name = value["name"] as? String,
                let checked = value["checked"] as? Bool else {
              break
            }
            let task = Task(id: id, name: name, checked: checked)
            tasks.append(task)
        }
        self.tasks = tasks
    } else {
        self.tasks = []
    }

}
  
func toAnyObject() -> Any {
return [
  "name": name,
  "tasks": tasks,
  "id": id
]
}
}
