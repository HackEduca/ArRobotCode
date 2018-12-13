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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var tilesCollectionView: UICollectionView!
    @IBOutlet weak var playLevelButton: UIButton!
    @IBOutlet weak var levelsOptionsStackView: UIStackView!
    
    private var levelPublicSwitch: UISwitch!
    private var levelOrderLabel: UILabel!
    private var levelOrderSlider: UISlider!
    private var levelChapterTextField: UITextField!
    
    private var levelsRepository: LevelsRepository!
    private var crtLevelAt: Int = -1
    private var firstLevelLoaded: Bool = false
    
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
    
    public func loadLevel(repository: LevelsRepository, at: Int) {
        self.levelsRepository = repository
        self.crtLevelAt = at
        setupViewModel()
        setupCollectionView()
        setupCollectionViewBinding()
        setupCollectionViewTap()
        setupCollectionViewLongTap()
        setupTextFieldBinding()
        setupCollectionViewSwipe()
        if(!firstLevelLoaded) {
            firstLevelLoaded = true
            addExtraOptionsIfAdmin()
        }
        setupExtraOptionsIfAdmin()
    }
    
    private func setupViewModel() {
        self.viewModel = LevelViewModel(repository: levelsRepository, at: self.crtLevelAt)
    }
    
    private func setupCollectionView() {
        self.tilesCollectionView.delegate = nil
        self.tilesCollectionView.dataSource = nil
    }
    
    private func setupCollectionViewBinding() {
        viewModel.levelObserver
            .map({ (dl) ->[DataTile] in
                Array(dl.Tiles)
            })
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
            .subscribe(onNext: { gesture in
                if let indexPath = self.tilesCollectionView?.indexPathForItem(at: gesture.location(in: self.tilesCollectionView)) {
                    self.viewModel.setToStartTile(at: indexPath.row)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupCollectionViewSwipe() {
        self.tilesCollectionView.rx
            .swipeGesture([.left, .right], configuration: { gestureRecognizer, delegate in
                delegate.simultaneousRecognitionPolicy = .never
            })
            .when(.recognized)
            .subscribe(onNext: { gesture in
                if let indexPath = self.tilesCollectionView?.indexPathForItem(at: gesture.location(in: self.tilesCollectionView)) {
                    if(gesture.direction == .left) {
                        self.viewModel.swipeLeftTile(at: indexPath.row)
                    }
                    if(gesture.direction == .right) {
                        self.viewModel.swipeRightTile(at: indexPath.row)
                    }
                }
               
                
            })
            .disposed(by: self.disposeBag)
    }

    
    func setupTextFieldBinding() {
        // titleTextField:
        self.viewModel.levelObserver
            .map({ (DataLevel) -> String in
                DataLevel.Name
            })
            .bind(to:  self.titleTextField.rx.text)
            .disposed(by: self.disposeBag)
        
        self.titleTextField.rx
            .observe(String.self, "text")
            .subscribe(onNext: { s in
                self.viewModel.setName(newName: s!)
            })
            .disposed(by: disposeBag)
        
        // heightTextField:
        self.viewModel.levelObserver
            .map({ (DataLevel) -> String in
                String(DataLevel.Height)
            })
            .bind(to:  self.heightTextField.rx.text)
            .disposed(by: self.disposeBag)
        
        self.heightTextField.rx
            .observe(String.self, "text")
            .subscribe(onNext: { s in
                self.viewModel.setHeight(newHeight: s!)
            })
            .disposed(by: disposeBag)
        
        // widthTextField
        self.viewModel.levelObserver
            .map({ (DataLevel) -> String in
                String(DataLevel.Width)
            })
            .bind(to:  self.widthTextField.rx.text)
            .disposed(by: self.disposeBag)
        
        self.widthTextField.rx
            .observe(String.self, "text")
            .subscribe(onNext: { s in
                self.viewModel.setWidth(newWidth: s!)
            })
            .disposed(by: disposeBag)
    }
    
    private func addExtraOptionsIfAdmin() {
        if UserRepository.shared.getUserProperties()?.Role == "admin" {
            // Level Public Switch
            self.levelPublicSwitch = UISwitch()
            self.levelPublicSwitch.isOn = false
            self.levelsOptionsStackView.insertArrangedSubview(levelPublicSwitch, at: self.levelsOptionsStackView.subviews.count - 1)
            
            // Level Order Label
            self.levelOrderLabel = UILabel()
            self.levelOrderLabel.text = "Order: 1"
            self.levelsOptionsStackView.insertArrangedSubview(levelOrderLabel, at: self.levelsOptionsStackView.subviews.count - 1)
            
            // Level Order Slider
            self.levelOrderSlider = UISlider()
            self.levelOrderSlider.minimumValue = 1
            self.levelOrderSlider.maximumValue = 25
            self.levelOrderSlider.value = 1
            self.levelsOptionsStackView.insertArrangedSubview(self.levelOrderSlider, at: self.levelsOptionsStackView.subviews.count - 1)
          
            // Level Chapter Text Field
            self.levelChapterTextField = UITextField()
            self.levelChapterTextField.placeholder = "Chapter"
            self.levelChapterTextField.borderStyle = .roundedRect
            self.levelsOptionsStackView.insertArrangedSubview(levelChapterTextField, at: self.levelsOptionsStackView.subviews.count - 1)
        }
    }
    
    private func setupExtraOptionsIfAdmin() {
        if UserRepository.shared.getUserProperties()?.Role == "admin" && self.levelPublicSwitch != nil {
            // Level Public Switch
            self.viewModel.levelObserver
                .map({ (DataLevel) -> Bool in
                    DataLevel.Public
                })
                .bind(to:  levelPublicSwitch.rx.isOn)
                .disposed(by: self.disposeBag)
            
            self.levelPublicSwitch.rx
                .isOn
                .subscribe(onNext: { s in
                    self.viewModel.setPublic(newPublic: s)
            })
            
            // Level Order Label
            self.viewModel.levelObserver
                .map({ (DataLevel) -> String in
                    "Ord: " + String( DataLevel.Order )
                })
                .bind(to: levelOrderLabel.rx.text)
                .disposed(by: self.disposeBag)
            
            // Level Order Slider
            self.viewModel.levelObserver
                .map({ (DataLevel) -> Float in
                    Float(DataLevel.Order)
                })
                .bind(to: levelOrderSlider.rx.value)
                .disposed(by: self.disposeBag)
            
            self.levelOrderSlider
                .rx
                .value
                .subscribe({value in
                    self.levelOrderLabel.text = "Ord: " + String( Int(value.element!) )
                    self.viewModel.setOrder(newOrder: Int(value.element!))
                })
                .disposed(by: self.disposeBag)
            
            // Level Chapter Text Field
            self.viewModel.levelObserver
                .map({ (DataLevel) -> String in
                    DataLevel.Chapter
                })
                .bind(to:  levelChapterTextField.rx.text)
                .disposed(by: self.disposeBag)
            
            self.levelChapterTextField.rx
                .observe(String.self, "text")
                .subscribe(onNext: { s in
                    if let text = s {
                        if text != "" {
                            self.viewModel.setChapter(newChapter:text)
                        }
                    }
                })
                .disposed(by: disposeBag)
        
        }
    }
}

extension LevelBuilderViewController: UITextFieldDelegate {
    @objc func fieldTextChanged(_ sender: UITextField) {
        print(sender.text!)
    }
}

extension LevelBuilderViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sz = CGSize(width: collectionView.frame.width / CGFloat(self.levelsRepository.get(at: self.crtLevelAt).Width) - CGFloat(minimumInteritemSpacing),
                      height: collectionView.frame.height / CGFloat(self.levelsRepository.get(at: self.crtLevelAt).Height) - CGFloat(minimumLineSpacing) - 1)
        
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
