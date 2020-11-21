//
//  Login.swift
//  Reminder App
//
//  Created by Alina Turbina on 03.11.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import Foundation
import FirebaseUI
import FirebaseAuth

class Login: UIViewController, FUIAuthDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let authUI = FUIAuth.defaultAuthUI() {
            authUI.providers = [FUIOAuth.appleAuthProvider()]
            authUI.delegate = self
            
            let authViewController = authUI.authViewController()
            self.present(authViewController, animated: true)
            
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let user = authDataResult?.user {
            print("You signed in with \(user.uid)")
        }
    }
    
}
