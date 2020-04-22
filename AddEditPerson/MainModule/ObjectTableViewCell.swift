//
//  ObjectTableViewCell.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 21.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit

class ObjectTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fillCell(title: String, other: String) {
        titleLabel.text = title
        otherLabel.text = other
    }
    
}
