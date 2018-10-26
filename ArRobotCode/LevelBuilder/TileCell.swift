//
//  TileCell.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 26/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

class TileCell: UICollectionViewCell {
    @IBOutlet weak var tileImageView: UIImageView!
    
    func setTile(tile: DataTile) {
        if tile.state == .Free {
             tileImageView.image = UIImage(named: "green")
        }
        
        if tile.state == .Used {
            tileImageView.image = UIImage(named: "red")
        }
       
    }
}
