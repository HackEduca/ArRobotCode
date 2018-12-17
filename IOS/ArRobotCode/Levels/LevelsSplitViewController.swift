//
//  LevelsSplitViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 03/11/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

class LevelsSplitViewController: UISplitViewController {
    // Child view controllers
    var levelsListVC: LevelsListVController?
    var levelBuilderVC: LevelBuilderViewController?
    
    // Repository with all the levels
    private var levelsRepository = LevelsRepository.shared
    public var at: Int = 0
    
    // For disposing rx
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign the child view controllers
        levelsListVC = (viewControllers.first as! LevelsListVController)
        levelBuilderVC = (viewControllers.last as! LevelBuilderViewController)
        
        // Setup LevelsListVC
        levelsListVC?.setupRepository(repository: levelsRepository)
        
        // Setup selectedLevel Observable
        self.levelBuilderVC?.loadLevel(repository: self.levelsRepository, at: -1)
        levelsListVC?.selectedLevelObservable.subscribe(onNext: { selectedLevel in
            self.at = self.levelsRepository.getAt(ID: selectedLevel.UUID)
            self.levelBuilderVC?.loadLevel(repository: self.levelsRepository, at: self.at)
        }).disposed(by: disposeBag)
        
        // Observe when level is played
        levelBuilderVC?.playLevelButton
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe({_ in
                self.navigateToGameInterface()
            })
            .disposed(by: disposeBag)
    }
    
    func navigateToGameInterface() {
        // Get the storyboard
        let gameStoryboard = UIStoryboard(name: "Game", bundle: Bundle.main)
        
        // Instantiate the VC
        guard let gameUISplitViewController = gameStoryboard.instantiateInitialViewController() as? GameUISplitViewController else {
            return
        }
    
        // Send data
        self.navigationItem.title = "Very here"
        gameUISplitViewController.setLevelData(levelsVC: self, repo: self.levelsRepository, at: self.at)
        
        // Show
        present(gameUISplitViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.levelsRepository
            .dataSource
            .take(1)
            .subscribe({ev in
             self.levelBuilderVC?.loadLevel(repository: self.levelsRepository, at: self.at)
        }).disposed(by: self.disposeBag)
       
    }
}
