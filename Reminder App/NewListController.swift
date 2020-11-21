//
//  NewListController.swift
//  Reminder AppUITests
//
//  Created by Alina Turbina on 01.05.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import UIKit



class NewListController: UIViewController {

    var delegate: AddList?
    
    @IBOutlet weak var listNameOutlet: UITextField!
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.isToolbarHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

