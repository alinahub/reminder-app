//
//  TaskViewController.swift
//  Reminder
//
//  Created by Alina Turbina on 30.04.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import UIKit
import os.log
import Firebase
import FirebaseDatabase

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var tasks: [Task] = []
    //var currentList: List = List(id: "example", name: "example", tasks: [])
    var currentId: String?
    var ref: DatabaseReference! = Database.database().reference()
    var user: Any?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //let circleFilled = UIImage(name: "circle.fill")
    //let circle = UIImage(systemName: "circle")
    
    let circleFilled = #imageLiteral(resourceName: "circle-filled").withTintColor(UIColor(red: 0x89/255, green: 0xBB/255, blue: 0xFE/255, alpha: 1.0))
    let circle = #imageLiteral(resourceName: "circle")
    
    override func viewWillAppear(_ animated: Bool) {
        user = Auth.auth().currentUser?.uid
        ref = Database.database().reference().child("\(user!)/list-items/\(currentId!)/tasks/")
        ref.observe(.value, with: { snapshot in
          var newItems: [Task] = []

          for child in snapshot.children {

            if let snapshot = child as? DataSnapshot,
               let taskItem = Task(snapshot: snapshot) {
              newItems.append(taskItem)
            }
          }

          self.tasks = newItems
          self.tableView.reloadData()
        })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //ref = Database.database().reference(withPath: "list-items")
        
       // DispatchQueue.global().async {
       //        do {
       //            NotificationCenter.default.addObserver(self,
       //                                                   selector: #selector(self.listReceived),
       //            name: NSNotification.Name(rawValue: listNotificationKey),
       //            object: nil)
       //        } catch {
       //            print("Failed")
       //        }
       // }
        
        
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // let notification = currentList.tasks
        
        for task in tasks {
            ref.updateChildValues([
                task.id : task.toAnyObject()
              ])
        }
        
        //NotificationCenter.default.post(name: Notification.Name(rawValue: tasksNotificationKey), object: self, userInfo: ["notification": notification])
    }
    
    @IBAction func createNewCell(_ sender: Any) {
        tasks.append(Task(id: UUID().uuidString, name: "", checked: false))
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        cell.taskNameLabel.text = tasks[indexPath.row].name
        
        if tasks[indexPath.row].checked {
            cell.checkBoxOutlet.setBackgroundImage(circleFilled, for: UIControl.State.normal)
        } else {
            cell.checkBoxOutlet.setBackgroundImage(circle, for: UIControl.State.normal)
        }
        
        cell.delegate = self
        cell.indexP = indexPath.row
        cell.tasks = tasks.sorted(by: {$0.id < $1.id})
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {

        ref.child(tasks[indexPath.row].id).removeValue()
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
      }
    }
    
    @objc func listReceived(data : Notification) -> Void {
        // guard let notification = data.userInfo!["notification"] else { return }
        //
        // if let name = (notification as! List).name as String? {
        //     currentList.name = name
        // }
        // if let tasks = (notification as! List).tasks as [Task]? {
        //     currentList.tasks = tasks
        // }
        // if let id = (notification as! List).id as String? {
        //     currentId = id
        // }
        // if let ref = (notification as! List).ref as DatabaseReference? {
        //     currentList.ref = ref
        // }
        tableView.reloadData()

    }
    
}

extension TaskViewController: EditRowProtocol {
    
    func changeCheckBox(checked: Bool, index: Int?) {
        tasks[index!].checked = checked
        tableView.reloadData()
    }
    
    func editRowLabel(text: String, index: Int?) {
        if (text == "") {
            tasks.remove(at: index!)
            tableView.reloadData()
        } else {
            tasks[index!].name = text
            tableView.reloadData()
        }
        
    }
    
}
