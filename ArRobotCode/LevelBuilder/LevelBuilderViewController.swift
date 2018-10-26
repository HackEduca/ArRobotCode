//
//  LevelBuilderViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 26/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

class LevelBuilderViewController: UIViewController {
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var tilesCollectionView: UICollectionView!
    
    var tiles: [DataTile] = []
    private var minimumLineSpacing:      Int = 5;
    private var minimumInteritemSpacing: Int = 5;
    private var itemsPerLineOrColumn: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tiles = createArray()
        
        // Add all the callbacks from UI
        heightTextField.addTarget(self, action: #selector(fieldTextChanged), for: .editingChanged)
        widthTextField.addTarget(self, action: #selector(fieldTextChanged), for: .editingChanged)
        
        tilesCollectionView.delegate = self
        tilesCollectionView.dataSource = self
    }
    
    func createArray() -> [DataTile] {
        var tmpDataTiles: [DataTile] = []
        
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

extension LevelBuilderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tiles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tile = tiles[indexPath.item]
        let cell = tilesCollectionView.dequeueReusableCell(withReuseIdentifier: "TileCell", for: indexPath) as! TileCell
        
        cell.setTile(tile: tile)
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print(indexPath.row)
        tiles[indexPath.row].swap()
        collectionView.reloadItems(at: [indexPath])
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
