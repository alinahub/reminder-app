//
//  LauchController.swift
//  Reminder App
//
//  Created by Alina Turbina on 09.11.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import Foundation
import UIKit
import os.log
import Firebase
import FirebaseAuth

class LauchController: UIViewController {
    
    var user: Any?
    
    override func viewDidLoad(){
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
            self.user = user.uid
        }
    
    }
    
}

