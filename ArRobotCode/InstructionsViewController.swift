//
//  InstructionsViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 19/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController{
    @IBOutlet weak var instructionsCollectionView: UICollectionView!
    @IBOutlet weak var runningInstructionsCollectionView: UICollectionView!
    
    var instructionsArray = [UIImage(named: "up"), UIImage(named: "down"), UIImage(named: "left"), UIImage(named: "right")]
    
    var runningInstructionsArray =  [UIImage(named: "up"), UIImage(named: "up"), UIImage(named: "left"), UIImage(named: "up"), UIImage(named: "right"), UIImage(named: "right")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension InstructionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.instructionsCollectionView {
             return instructionsArray.count
        }
        else if collectionView == self.runningInstructionsCollectionView {
            return runningInstructionsArray.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.instructionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstructionsCollectionViewCell", for:  indexPath) as! InstructionsCollectionViewCell
            
            cell.Instruction.image = instructionsArray[indexPath.row]
            return cell
        }
            
        else if collectionView == self.runningInstructionsCollectionView {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RunningInstructionsCollectionViewCell",
                                                         for: indexPath) as! RunningInstructionsCollectionViewCell
            
            cell.Instruction.image = instructionsArray[0]
            cell.Status.image = instructionsArray[0]
            return cell
        }
        
       return UICollectionViewCell()
    }
}

extension InstructionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
}

extension InstructionsViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.instructionsArray[indexPath.row]
        let itemProvider = NSItemProvider(object: "instruction" as NSString)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}
