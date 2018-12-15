//
//  CharactersViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 13/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class CharactersViewController: UIViewController {
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    private let viewModel = CharactersViewModel()
    private let disposeBag = DisposeBag()
    
    private var minimumLineSpacing:      Int = 5;
    private var minimumInteritemSpacing: Int = 5;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionViewTap()
        passDataToViewModel()
        setupCollectionView()
        setupCollectionViewBinding()
    }
    
    private func passDataToViewModel() {
        CharacterRepository.shared.charactersObservable
            .subscribe({ev in
                self.viewModel.input.listOfCharacters.onNext(ev.element!)
            })
            .disposed(by: self.disposeBag)
        
        UserRepository.shared.userPropertiesObservable
            .subscribe({ev in
                self.viewModel.input.userProperties.onNext(ev.element!)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupCollectionView() {
        self.charactersCollectionView.delegate = nil
        self.charactersCollectionView.dataSource = nil
    }
    
    private func setupCollectionViewBinding() {
        viewModel.output.listOfCellInfo
            .bind(to: self.charactersCollectionView.rx.items) { view, row, element in
                let cell = self.charactersCollectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: IndexPath(row: row, section: 0)) as! CharacterCell
                cell.setProperties(charact: element.character, isSelected: element.chosen)
                return cell;
                
            }
            .disposed(by: disposeBag)
        
        charactersCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionViewTap() {
        self.charactersCollectionView.rx
            .anyGesture(.tap())
            .when(.recognized)
            .subscribe(onNext: { gesture in
                if let index = self.charactersCollectionView!.indexPathForItem(at: gesture.location(in: self.charactersCollectionView)) {
                    self.viewModel.selectCharacter(at: index.row)
                }
            })
            .disposed(by: self.disposeBag)
    }
}

extension CharactersViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sz = CGSize(width: collectionView.frame.width / CGFloat(2) - CGFloat(minimumInteritemSpacing),
                        height: collectionView.frame.height / CGFloat(CharacterRepository.shared.getCharcters().count / 2) - CGFloat(minimumLineSpacing) - 1)
        
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
