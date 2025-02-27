//
//  InstructionsViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 19/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

class AlternativeInstructionsViewController: UIViewController{
    @IBOutlet weak var instructionsCollectionView: UICollectionView!
    @IBOutlet weak var runningInstructionsCollectionView: UICollectionView!
    
    var instructionsArray = [UIImage(named: "up"), UIImage(named: "down"), UIImage(named: "left"), UIImage(named: "right")]
    
    var runningInstructionsImgArray =  [UIImage(named: "up"), UIImage(named: "up"), UIImage(named: "left"), UIImage(named: "up"), UIImage(named: "right"), UIImage(named: "right")]
    
    var runningInstructionsStatusArray =  [UIImage(named: "done"), UIImage(named: "done"), UIImage(named: "waiting"), UIImage(named: "waiting"), UIImage(named: "waiting"), UIImage(named: "waiting")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension AlternativeInstructionsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.instructionsCollectionView {
             return instructionsArray.count
        }
        else if collectionView == self.runningInstructionsCollectionView {
            return runningInstructionsImgArray.count
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
            
            cell.Status.image = runningInstructionsStatusArray[indexPath.row]
            cell.Instruction.image = runningInstructionsImgArray[indexPath.row]
            return cell
        }
        
       return UICollectionViewCell()
    }
}

extension AlternativeInstructionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
}

extension AlternativeInstructionsViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let item = self.instructionsArray[indexPath.row]
        let itemProvider = NSItemProvider(object: "instruction" as NSString)
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}
