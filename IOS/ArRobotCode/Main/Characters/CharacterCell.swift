//
//  CharacterCell.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 13/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxGesture

class CharacterCell : UICollectionViewCell{
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var SelectedSwitch: UISwitch!
    
    func setProperties(charact: Character, isSelected: Bool) {
        self.Image.image = UIImage(named: charact.Picture)
        self.NameLabel.text = charact.Name
        self.SelectedSwitch.isOn = isSelected
    }
}

