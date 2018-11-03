//
//  LevelBuilderViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 26/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

class LevelBuilderViewController: UIViewController {
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var tilesCollectionView: UICollectionView!
    
    var tiles: [DataTile] = []
    private var minimumLineSpacing:      Int = 5;
    private var minimumInteritemSpacing: Int = 5;
    private var itemsPerLineOrColumn: Int = 0;
    
    private let disposeBag = DisposeBag()
    public var levelsListVController: LevelsListVController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tiles = createArray()
        
        // Add all the callbacks from UI
        heightTextField.addTarget(self, action: #selector(fieldTextChanged), for: .editingChanged)
        widthTextField.addTarget(self, action: #selector(fieldTextChanged), for: .editingChanged)
        
        tilesCollectionView.delegate = self
        tilesCollectionView.dataSource = self
        // Create long tap recognizer
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = false
        lpgr.delegate = self
        tilesCollectionView.addGestureRecognizer(lpgr)
    }
    
    public func loadLevel(level: DataLevel) {
        print("Loading level: ", level)
        
    }
    
    func createArray() -> [DataTile] {
        var tmpDataTiles: [DataTile] = []
        
        // To do: make this responsive !
        for i in Range(1...100) {
            tmpDataTiles.append(DataTile())
        }
        itemsPerLineOrColumn = 10
        
        return tmpDataTiles
    }
}

extension LevelBuilderViewController: UITextFieldDelegate {
    @objc func fieldTextChanged(_ sender: UITextField) {
        print(sender.text!)
    }
}

extension LevelBuilderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tiles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tile = tiles[indexPath.item]
        let cell = tilesCollectionView.dequeueReusableCell(withReuseIdentifier: "TileCell", for: indexPath) as! TileCell
        
        cell.setTile(tile: tile)
        return cell
    }
    

    // Handle TAP
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print(indexPath.row)
        tiles[indexPath.row].swap()
        collectionView.reloadItems(at: [indexPath])
    }
    
    // Handle Long TAP
    @objc func handleLongTap(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
        
        let point = gestureReconizer.location(in: self.tilesCollectionView)
        let indexPath = self.tilesCollectionView.indexPathForItem(at: point)
        
        if let index = indexPath {
            var cell = self.tilesCollectionView.cellForItem(at: index)
            tiles[index.row].setToStart()
            self.tilesCollectionView.reloadItems(at: [index])
        } else {
            print("Could not find index path")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(itemsPerLineOrColumn) - CGFloat(minimumInteritemSpacing),
                      height: collectionView.frame.height / CGFloat(itemsPerLineOrColumn) - CGFloat(minimumLineSpacing) - 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimumLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimumInteritemSpacing)
    }
    
}
