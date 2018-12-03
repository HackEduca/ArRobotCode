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
        if tile.Type == TypeOfTile.Free.rawValue{
             tileImageView.image = UIImage(named: "gray")
        }
        
        if tile.Type == TypeOfTile.Used.rawValue {
            tileImageView.image = UIImage(named: "green")
        }
        
        if tile.Type == TypeOfTile.Start.rawValue {
            tileImageView.image = UIImage(named: "pink")
        }
        
        if tile.Type == TypeOfTile.Finish.rawValue {
            tileImageView.image = UIImage(named: "yellow")
        }
        
        if tile.Type == TypeOfTile.UsedA.rawValue {
            tileImageView.image = UIImage(named: "greenA")
        }
        
        if tile.Type == TypeOfTile.UsedB.rawValue {
            tileImageView.image = UIImage(named: "greenB")
        }
        
        if tile.Type == TypeOfTile.UsedC.rawValue {
            tileImageView.image = UIImage(named: "greenC")
        }
        
        if tile.Type == TypeOfTile.UsedD.rawValue {
            tileImageView.image = UIImage(named: "greenD")
        }
        
        if tile.Type == TypeOfTile.UsedE.rawValue {
            tileImageView.image = UIImage(named: "greenE")
        }
        
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
