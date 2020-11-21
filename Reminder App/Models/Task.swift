//
//  Tasks.swift
//  Reminder App
//
//  Created by Alina Turbina on 03.11.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import Foundation

// class Task: NSObject, NSCoding {
//
//     var name: String
//     var checked: Bool
//
//     struct PropertyKey {
//         static let name = "name"
//         static let checked = "checked"
//     }
//
//     func encode(with coder: NSCoder) {
//         coder.encode(name, forKey: PropertyKey.name)
//         coder.encode(checked, forKey: PropertyKey.checked)
//     }
//
//     init?(name: String) {
//        // Initialize stored properties.
//        self.name = name
//        self.checked = false
//     }
//
//     required convenience init?(coder: NSCoder) {
//         // The name is required. If we cannot decode a name string, the initializer should fail.
//         guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {
//             os_log("Unable to decode the name for a List object.", log: OSLog.default, type: .debug)
//             return nil
//         }
//
//         guard (coder.decodeObject(forKey: PropertyKey.checked) as? Bool) != nil else {
//             os_log("Unable to decode the tasks for a List object.", log: OSLog.default, type: .debug)
//             return nil
//         }
//
//
//         // Must call designated initializer.
//         self.init(name: name)
//     }
//
// }

import UIKit
import os.log
import Firebase

struct Task {
      
    let ref: DatabaseReference?
        let id: String
    var name: String
    var checked: Bool
      
    init(id: String, name: String, checked:Bool) {
        // Initialize stored properties.
        self.ref = nil
        self.id = id
        self.name = name
        self.checked = checked
        
    }
      
    init?(snapshot: DataSnapshot) {
        guard
          let value = snapshot.value as? [String: AnyObject],
          let id = value["id"] as? String,
          let name = value["name"] as? String,
          let checked = value["checked"] as? Bool else {
          return nil
        }
            
        self.ref = snapshot.ref
        self.name = name
        self.checked = checked
        self.id = id
    }
      
    func toAnyObject() -> Any {
        return [
          "name": name,
          "checked": checked,
          "id": id
        ]
    }
}
