//
//  LevelTableViewCell.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 29/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {

    @IBOutlet weak var levelNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
