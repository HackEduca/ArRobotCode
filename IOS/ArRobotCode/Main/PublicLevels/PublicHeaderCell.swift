//
//  PublicHeaderCollectionViewCell.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 15/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

class PublicHeaderCell: UICollectionReusableView {
    @IBOutlet weak var chapterNameLabel: UILabel!
    
    func setProperties(chapterName: String) {
        self.chapterNameLabel.text = chapterName
    }
}
