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
    
    public var levelsVC : UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideVC = (viewControllers.first as! SidePageViewController)
        arVC = (viewControllers.last as! ARViewController)
//
//        self.sidePageNavController.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.bordered, target: self, action: Selector("back:"))
//
//        self.sidePageNavController.navigationItem.leftBarButtonItem = newBackButton
//        self.sidePageNavController.viewControllers = [ self.sidePageNavController.viewControllers.first] as! [UIViewController]
    }
    
    public func setLevelData(levelsVC: UIViewController, repo: LevelsRepository, at: Int) {
        self.levelsVC = levelsVC
        self.levelsRepository = repo
        self.crtLevelAt = at
        
        print("Working: ", at)
    }
    

}
