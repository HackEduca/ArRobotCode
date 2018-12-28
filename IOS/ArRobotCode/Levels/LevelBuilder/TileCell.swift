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
            tileImageView.contentMode = .scaleToFill
        }
        
        if tile.Type == TypeOfTile.Used.rawValue {
            tileImageView.image = UIImage(named: "TileA.png")
             tileImageView.contentMode = .scaleToFill
        }
        
        if tile.Type == TypeOfTile.Start.rawValue {
            tileImageView.image = UIImage(named: "start.png")
            tileImageView.contentMode = .scaleAspectFit
            self.backgroundColor = UIColor(red: 220 / 255.0, green: 220 / 255.0, blue: 218 / 255.0, alpha: 1.0)
        }
        
        if tile.Type == TypeOfTile.Finish.rawValue {
            tileImageView.image = UIImage(named: "finish.png")
            tileImageView.contentMode = .scaleAspectFit
            self.backgroundColor = UIColor(red: 220 / 255.0, green: 220 / 255.0, blue: 218 / 255.0, alpha: 1.0)
        
        }
        
        if tile.Type == TypeOfTile.UsedA.rawValue {
            tileImageView.image = UIImage(named: "TileB.png")
             tileImageView.contentMode = .scaleToFill
        }
        
        if tile.Type == TypeOfTile.UsedB.rawValue {
            tileImageView.image = UIImage(named: "TileC.png")
             tileImageView.contentMode = .scaleToFill
        }
        
        if tile.Type == TypeOfTile.UsedC.rawValue {
            tileImageView.image = UIImage(named: "TileD.png")
             tileImageView.contentMode = .scaleToFill
        }
        
        if tile.Type == TypeOfTile.UsedD.rawValue {
            tileImageView.image = UIImage(named: "TileE.png")
             tileImageView.contentMode = .scaleToFill
        }
        
        if tile.Type == TypeOfTile.UsedE.rawValue {
            tileImageView.image = UIImage(named: "TileF.png")
             tileImageView.contentMode = .scaleToFill
        }
        
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
