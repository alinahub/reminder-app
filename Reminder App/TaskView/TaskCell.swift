//
//  TaskCell.swift
//  Reminder
//
//  Created by Alina Turbina on 30.04.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import UIKit

protocol EditRowProtocol {
    func changeCheckBox(checked: Bool, index: Int?)
    func editRowLabel(text: String, index: Int?)
}

class TaskCell: UITableViewCell {
    
    var delegate: EditRowProtocol?
    var indexP: Int?
    var tasks: [Task]?

    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    @IBAction func checkBoxAction(_ sender: UIButton) {
        if tasks![indexP!].checked {
            delegate?.changeCheckBox(checked: false, index: indexP!)
        } else {
            delegate?.changeCheckBox(checked: true, index: indexP!)
        }
    }
    
    @IBOutlet weak var taskNameLabel: UITextField!
    
    @IBAction func taskLabelChanged(_ sender: UITextField) {
        delegate?.editRowLabel(text: sender.text!, index: indexP!)
    }

}
