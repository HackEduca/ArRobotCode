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
    
    public func setTile(tile: DataTile) {
        if tile.type == TypeOfTile.Free.rawValue{
             tileImageView.image = UIImage(named: "green")
        }
        
        if tile.type == TypeOfTile.Used.rawValue {
            tileImageView.image = UIImage(named: "red")
        }
        
        if tile.type == TypeOfTile.Start.rawValue {
            tileImageView.image = UIImage(named: "pink")
        }
        
        if tile.type == TypeOfTile.Finish.rawValue {
            tileImageView.image = UIImage(named: "yellow")
        }
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
