//
//  PublicLevelCollectionViewCell.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 15/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
class PublicLevelCell: UICollectionViewCell {
    @IBOutlet weak var tilesCollectionView: UICollectionView!
    @IBOutlet weak var levelNameLabel: UILabel!

    let disposeBag = DisposeBag()
    private var minimumLineSpacing:      Int = 1;
    private var minimumInteritemSpacing: Int = 1;
    private var level: DataLevel!
    
    func setProperties(lvl: DataLevel) {
        self.level = lvl
        
        // Setup Label
        self.levelNameLabel.text = level.Name
        
        // Setup Collection View
        self.setupCollectionView()
        let ds = RxCollectionViewSectionedReloadDataSource<SectionModel<String,DataTile>>(configureCell: { (ds, cv, indexPath, element)-> UICollectionViewCell in
            let cell = self.tilesCollectionView.dequeueReusableCell(withReuseIdentifier: "TileCell", for: indexPath ) as! TileCell
            
            cell.setTile(tile: element)
            return cell
        })
        Observable.just([SectionModel(model: "", items: level.Tiles)]).bind(to: self.tilesCollectionView.rx.items(dataSource: ds))
    }
    
    private func setupCollectionView() {
        self.tilesCollectionView.delegate = nil
        self.tilesCollectionView.dataSource = nil
        
        tilesCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension PublicLevelCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sz = CGSize(width: collectionView.frame.width / CGFloat(self.level.Width) - CGFloat(minimumInteritemSpacing),
                        height: collectionView.frame.height / CGFloat(self.level.Height) - CGFloat(minimumLineSpacing))
        
        return sz
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimumLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimumInteritemSpacing)
    }
}
