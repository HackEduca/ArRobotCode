//
//  InstructionsCollectionViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 21/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class InstructionsCollectionViewController: UICollectionView,  UICollectionViewDragDelegate  {
     var instructionsArray = [UIImage(named: "up"), UIImage(named: "down"), UIImage(named: "left"), UIImage(named: "right")]
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.instructionsArray[indexPath.row]
        let itemProvider = NSItemProvider(object: "instruction" as NSString)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return instructionsArray.count
    }
}
