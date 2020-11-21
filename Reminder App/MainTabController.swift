//
//  MainTabController.swift
//  Reminder App
//
//  Created by Alina Turbina on 09.11.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import Foundation
import UIKit
import os.log

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.present(calenderVC, animated: false, completion: nil)
        //let calendarVC = CalendarViewController.init(nibName: "CalendarViewController", bundle: nil)
        //self.navigationController?.pushViewController(calendarVC, animated: true)

        let calenderVC = CalendarViewController.init(nibName: "CalendarViewController", bundle: nil)

        calenderVC.tabBarItem = UITabBarItem(tabBarSystemItem: .none, tag: 1)
        
        self.viewControllers?.append(calenderVC)

    }
}
