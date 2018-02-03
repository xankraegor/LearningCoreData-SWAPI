//
//  SingleValueCell.swift
//  LearnCoreData
//
//  Created by Алексей Кудрявцев on 27/11/2017.
//  Copyright © 2017 Алексей Кудрявцев. All rights reserved.
//

import UIKit

class SingleValueCell: UITableViewCell {

    @IBOutlet private weak var valueLabel: UILabel?
    
    var value: String? {
        didSet {
            valueLabel?.text = value
        }
    }
}
