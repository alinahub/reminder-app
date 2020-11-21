//
//  ListCell.swift
//  Reminder App
//
//  Created by Alina Turbina on 01.05.20.
//  Copyright © 2020 Alina Turbina. All rights reserved.
//

import UIKit

protocol ListCellDelegate {
    func buttonTapped(cell: ListCell)
}

class ListCell: UITableViewCell {

    
    @IBOutlet weak var listButton: UIButton!
    
    @IBOutlet weak var listLabelName: UILabel!
    
    @IBOutlet weak var listCountNumber: UILabel!
    
    var delegate : ListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @IBAction func listButtonTapped(_ sender: Any) {
        self.delegate?.buttonTapped(cell: self)
    }
}
