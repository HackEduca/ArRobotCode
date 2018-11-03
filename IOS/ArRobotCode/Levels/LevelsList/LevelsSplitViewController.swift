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

class LevelsSplitViewController: UISplitViewController {
    // Child view controllers
    var levelsListVC: LevelsListVController?
    var levelBuilderVC: LevelBuilderViewController?
    
    // Repository with all the levels
    private var levelsRepository = LevelsRepository()
    
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
        levelsListVC?.selectedLevelObservable.subscribe(onNext: { selectedLevel in
            self.levelBuilderVC?.loadLevel(level: selectedLevel)
        }).disposed(by: disposeBag)
    }
    

    

}
