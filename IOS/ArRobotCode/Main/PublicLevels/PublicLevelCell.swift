//
//  PublicLevelCollectionViewCell.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 15/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

class PublicLevelCell: UICollectionViewCell {
    @IBOutlet weak var levelNameLabel: UILabel!
    
    
    func setProperties(levelName: String) {
        self.levelNameLabel.text = levelName
    }
}
