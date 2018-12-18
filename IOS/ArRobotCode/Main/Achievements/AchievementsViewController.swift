//
//  AchievementsViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 18/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class AchievementsViewController: UIViewController {
    @IBOutlet weak var achievementsCollectionView: UICollectionView!
    
    private let viewModel = AchievementsViewModel()
    private let disposeBag = DisposeBag()
    
    private var minimumLineSpacing:      Int = 1;
    private var minimumInteritemSpacing: Int = 1;
    
    private var achievementsCount: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCollectionViewTap()
        passDataToViewModel()
        setupCollectionView()
        setupCollectionViewBinding()
    }
    
    private func passDataToViewModel() {
        AchievementsRepository.shared.achievementsObservable.subscribe({ev in
            if let elements = ev.element {
                self.achievementsCount = elements.count
                self.viewModel.input.listOfAchievements.onNext(elements)
            }
        })

        UserRepository.shared.userPropertiesObservable
            .subscribe({ev in
                self.viewModel.input.userProperties.onNext(ev.element!)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupCollectionView() {
        self.achievementsCollectionView.delegate = nil
        self.achievementsCollectionView.dataSource = nil
    }
    
    private func setupCollectionViewBinding() {
        viewModel.output.listOfCellInfo
            .bind(to: self.achievementsCollectionView.rx.items) { view, row, element in
                let cell = self.achievementsCollectionView.dequeueReusableCell(withReuseIdentifier: "AchievementCell", for: IndexPath(row: row, section: 0)) as! AchievementCell
                
                cell.setProperties(achievement: element.achievement, locked: element.locked)
                return cell;
            }
            .disposed(by: disposeBag)
        
        achievementsCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionViewTap() {
        self.achievementsCollectionView.rx
            .anyGesture(.tap())
            .when(.recognized)
            .subscribe(onNext: { gesture in
                if let index = self.achievementsCollectionView.indexPathForItem(at: gesture.location(in: self.achievementsCollectionView)) {
                    print("Tapped on: ", index.row)
                }
            })
            .disposed(by: self.disposeBag)
    }
}

extension AchievementsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sz = CGSize(width: collectionView.frame.width / CGFloat(2) - CGFloat(minimumInteritemSpacing),
                        height: collectionView.frame.height / CGFloat(self.achievementsCount / 2) - CGFloat(minimumLineSpacing) - 1)
        return sz
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimumLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimumInteritemSpacing)
    }
}
