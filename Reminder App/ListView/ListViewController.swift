//
//  ListViewController.swift
//  Reminder App
//
//  Created by Alina Turbina on 01.05.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseDatabase
import FirebaseAuth

let listNotificationKey = "listNotification"
let tasksNotificationKey = "taskNotification"

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var lists: [List] = []
    var currentIndex: Int?
    var user: Any?
    var ref: DatabaseReference! = Database.database().reference()

    override func viewWillAppear(_ animated: Bool) {
        
        user = Auth.auth().currentUser?.uid
        ref.child("\(user!)/list-items/").observe(.value, with: { snapshot in
          var newItems: [List] = []

          for child in snapshot.children {

            if let snapshot = child as? DataSnapshot,
               let listItem = List(snapshot: snapshot) {
              newItems.append(listItem)
            }
          }

          self.lists = newItems
          self.tableView.reloadData()
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // DispatchQueue.global().async {
       //        do {
       //            NotificationCenter.default.addObserver(self,
       //                                                   selector: #selector(self.tasksReceived),
       //            name: NSNotification.Name(rawValue: tasksNotificationKey),
       //            object: nil)
       //        } catch {
       //            print("Failed")
       //        }
       // }
        
        //if let savedLists = loadList() {
        //    lists += savedLists
        //}
        //else {
        //    // Load the sample data.
        //    loadSampleList()
        //}
        
    }
    
    
    @IBOutlet weak var addListButton: UIButton!
    
    @IBOutlet weak var editModeButton: UIButton!
    
    @IBAction func openEditMode(_ sender: Any) {
        if editModeButton.backgroundImage(for: .normal) == UIImage(systemName: "ellipsis") {
            editModeButton.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
            tableView.isEditing = true
        } else {
            editModeButton.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
            tableView.isEditing = false
        }
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editModeButton.setBackgroundImage(UIImage(systemName: "ellipsis"), for: .normal)
        tableView.isEditing = false
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListCell
        
        cell.listLabelName.text = lists[indexPath.row].name
        cell.listCountNumber.text = String(lists[indexPath.row].tasks.count)
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = lists[sourceIndexPath.row]
        lists.remove(at: sourceIndexPath.row)
        lists.insert(movedObject, at: destinationIndexPath.row)
        //saveLists()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        lists.remove(at: indexPath.row)                         // ---- ?
        tableView.deleteRows(at: [indexPath], with: .automatic) // ---- ?
        let listItem = lists[indexPath.row]
        listItem.ref?.removeValue()
        //saveLists()
      }
    }
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //    if segue.destination is NewListController {
    //        let vc = segue.destination as! NewListController
    //        vc.delegate = self
    //    }
    //}
    
    @objc func tasksReceived(data : Notification) -> Void {
        guard let notification = data.userInfo!["notification"] else { return }
        if let tasks = notification as? [Task] {
            lists[currentIndex!].tasks = tasks
        }
        //saveLists()
        // self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TaskViewController {
            let taskController = segue.destination as! TaskViewController
            taskController.currentId = lists[currentIndex!].id
        }
    }
    
     //MARK: Private Methods
    
    // private func loadSampleList() {
//
    //     guard let list1 = Optional(List(id: UUID().uuidString, name: "Todos today", tasks: [])) else {
    //         fatalError("Unable to instantiate list1")
    //     }
    //
    //     lists += [list1]
    // }
    
    // private func loadList() -> [List]?  {
    //     do {
    //         // let data = try Data(contentsOf: URL.init(fileURLWithPath: List.ArchiveURL.path))
    //         // let result = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self], from: data) as? // [List]
    //         print("lists loaded")
    //         return NSKeyedUnarchiver.unarchiveObject(withFile: List.ArchiveURL.path) as? [List]
    //     } catch {
    //         print("load list failed")
    //         return nil
    //     }
    // }

}

extension ListViewController: ListCellDelegate {
    
    func buttonTapped(cell: ListCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        currentIndex = indexPath.row
        // var notification: List = List(id: lists[currentIndex!].id, name: lists[currentIndex!].name, tasks: // lists[currentIndex!].tasks)
        // notification.ref = lists[currentIndex!].ref
        //
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:  "TaskViewController") as! TaskViewController
        
        vc.currentId = lists[currentIndex!].id
        self.present(vc, animated: true, completion: nil)
        //
        // NotificationCenter.default.post(name: Notification.Name(rawValue: listNotificationKey), object: self, userInfo: ["notification": notification])
        
      }
}

// add new list implementation
extension ListViewController {
    
    @IBAction func addNewList(_ sender: Any) {
        initAddNewListView()
    }
    
    // private func saveLists() {
    //     let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(lists, toFile: // getDocumentsDirectory().appendingPathComponent(ListViewController))
    //     if isSuccessfulSave {
    //         os_log("Lists successfully saved.", log: OSLog.default, type: .debug)
    //     } else {
    //         os_log("Failed to save list...", log: OSLog.default, type: .error)
    //     }
    // }
    
    func addList(name: String) {
        let newList = List(id: UUID().uuidString, name: name, tasks: [])
        print(newList as Any)
        
        // save to database
        let listItemRef = self.ref.child("\(user!)/list-items/\(newList.id)/")
        listItemRef.setValue(newList.toAnyObject())
        
        
        // save to list
        self.lists.append(newList)
        print(lists)
        // saveLists()
        self.tableView.reloadData()
    }
    
    func initAddNewListView() {
        // Create the alert controller
        let alertController = UIAlertController(title: "Add New List", message: "", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "List Name"
        }
        
        // Create the actions
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) {
            UIAlertAction in
            guard let textField = alertController.textFields?.first,
                  let text = textField.text else { return }
            if (!text.isEmpty) {
                self.addList(name: text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }

        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
}

struct ListData {
    let id: String
    let name: String
    let tasks: [Task]
}

struct PropertyKey {
    static let name = "name"
    static let tasks = "tasks"
}

