//
//  GameUISplitViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 14/11/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

class GameUISplitViewController: UISplitViewController {
    public var levelsRepository: LevelsRepository!
    public var crtLevelAt: Int = -1
    
    public var sideVC: SidePageViewController!
    public var arVC: ARViewController!
    
    // The parent
    public var levelsVC : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideVC = (viewControllers.first as! SidePageViewController)
        arVC = (viewControllers.last as! ARViewController)
        arVC.level = levelsRepository!.get(at: self.crtLevelAt)
    }
    
    public func setLevelData(levelsVC: UIViewController, repo: LevelsRepository, at: Int) {
        self.levelsVC = levelsVC
        self.levelsRepository = repo
        self.crtLevelAt = at
    }
}
