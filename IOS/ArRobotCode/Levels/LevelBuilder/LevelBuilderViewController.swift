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
    
    var crtLevel: DataLevel!
    private var minimumLineSpacing:      Int = 5;
    private var minimumInteritemSpacing: Int = 5;
    private var itemsPerLineOrColumn: Int = 10;
    
    private var viewModel: LevelViewModel!
    private let cellIdentifier = "LevelTile"
    private let disposeBag = DisposeBag()
    
    public var levelsListVController: LevelsListVController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func loadLevel(level: DataLevel) {
        self.crtLevel = level
        setupViewModel()
        setupCollectionView()
        setupCollectionViewBinding()
        setupCollectionViewTap()
        setupCollectionViewLongTap()
    }
    
    private func setupViewModel() {
        self.viewModel = LevelViewModel(tiles: self.crtLevel.Tiles)
    }
    
    private func setupCollectionView() {
        self.tilesCollectionView.delegate = nil
        self.tilesCollectionView.dataSource = nil
    }
    
    private func setupCollectionViewBinding() {
        viewModel.dataSource
            .bind(to: self.tilesCollectionView.rx.items) { view, row, element in
                let cell = self.tilesCollectionView.dequeueReusableCell(withReuseIdentifier: "TileCell", for: IndexPath(row: row, section: 0)) as! TileCell
                
                cell.setTile(tile: element)
                return cell;
                
            }
            .disposed(by: disposeBag)
        
        tilesCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionViewTap() {
        self.tilesCollectionView.rx
            .tapGesture(configuration: { gestureRecognizer, delegate in
                delegate.simultaneousRecognitionPolicy = .never
                })
            .subscribe(onNext: { gesture in
                if let indexPath = self.tilesCollectionView?.indexPathForItem(at: gesture.location(in: self.tilesCollectionView)) {
                    self.viewModel.swapTile(at: indexPath.row)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupCollectionViewLongTap() {
        self.tilesCollectionView.rx
            .longPressGesture()
            .when(.recognized)
            .subscribe(onNext: { gesture in
                if let indexPath = self.tilesCollectionView?.indexPathForItem(at: gesture.location(in: self.tilesCollectionView)) {
                    self.viewModel.setToStartTile(at: indexPath.row)
                    print("Intrat si aici")
                }
            })
            .disposed(by: self.disposeBag)
    }
}

extension LevelBuilderViewController: UITextFieldDelegate {
    @objc func fieldTextChanged(_ sender: UITextField) {
        print(sender.text!)
    }
}

extension LevelBuilderViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sz = CGSize(width: collectionView.frame.width / CGFloat(itemsPerLineOrColumn) - CGFloat(minimumInteritemSpacing),
                      height: collectionView.frame.height / CGFloat(itemsPerLineOrColumn) - CGFloat(minimumLineSpacing) - 1)
        
        return sz
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
