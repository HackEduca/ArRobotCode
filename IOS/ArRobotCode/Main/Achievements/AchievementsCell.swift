//
//  AchievementsCell.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 18/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxGesture

class AchievementCell : UICollectionViewCell{
    @IBOutlet weak var achievementImage: UIImageView!
    
    func setProperties(achievement:Achievement, locked: Bool) {
        self.achievementImage.image = UIImage(named: achievement.Picture)
        
        if locked == true {
            self.achievementImage.alpha = CGFloat(0.2)
        } else {
            self.achievementImage.alpha = CGFloat(1.0)
        }
    }
}
