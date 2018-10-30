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
        if tile.type == .Free {
             tileImageView.image = UIImage(named: "green")
        }
        
        if tile.type == .Used {
            tileImageView.image = UIImage(named: "red")
        }
        
        if tile.type == .Start {
            tileImageView.image = UIImage(named: "pink")
        }
        
        if tile.type == .Finish{
            tileImageView.image = UIImage(named: "yellow")
        }
       
    }
}
