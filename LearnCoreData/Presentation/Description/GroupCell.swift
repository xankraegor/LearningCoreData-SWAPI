//
//  GroupCell.swift
//  LearnCoreData
//
//  Created by Алексей Кудрявцев on 27/11/2017.
//  Copyright © 2017 Алексей Кудрявцев. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel?
    
    var name: String? {
        didSet {
            nameLabel?.text = name
        }
    }
}
