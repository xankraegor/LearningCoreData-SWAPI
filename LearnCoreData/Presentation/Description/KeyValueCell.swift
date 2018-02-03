//
//  KeyValueCell.swift
//  LearnCoreData
//
//  Created by Алексей Кудрявцев on 27/11/2017.
//  Copyright © 2017 Алексей Кудрявцев. All rights reserved.
//

import UIKit

class KeyValueCell: UITableViewCell {

    @IBOutlet private weak var keyLabel: UILabel?
    @IBOutlet private weak var valueLabel: UILabel?
    
    func setData(key: String, value: String) {
        keyLabel?.text = key
        valueLabel?.text = value
    }
}
