//
//  GameUISplitViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 14/11/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameUISplitViewController: UISplitViewController {
    public var levelsRepository: LevelsRepository!
    public var crtLevelAt: Int = -1
    
    public var sideVC: SidePageViewController!
    public var instructionsVC: InstructionsViewController!
    public var arVC: ARViewController!
    
    // The parent
    public var levelsVC : UIViewController?
    
    // Others
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create references to child controllers
        sideVC = (viewControllers.first as! SidePageViewController)
        instructionsVC = (sideVC.viewControllers?.first as! InstructionsViewController)
        arVC = (viewControllers.last as! ARViewController)
        
        // Set the selected level of child AR VC
        arVC.level = levelsRepository!.get(at: self.crtLevelAt)
        
        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        self.instructionsVC.instructionsBehaviourSubject.asObserver()
            .observeOn(concurrentScheduler)
            .subscribeOn(concurrentScheduler)
            .subscribe({ (ev) in
                guard let event = ev.element else {
                    return
                }
                
                 print("Processing: ", event)
                var evSplit = event.split(separator: " ")
                if evSplit.count == 0 {
                    return;
                }

                switch evSplit[0] {
                case "run":
                    print("")
                case "moveFront":
                    self.arVC.sceneController.playerController.moveFront()
                    break
                case "moveBack":
                    self.arVC.sceneController.playerController.moveBack()
                    break
                case "turnLeft":
                    self.arVC.sceneController.playerController.turnLeft()
                    break
                case "turnRight":
                    self.arVC.sceneController.playerController.turnRight()
                    break
                default:
                    print("Invalid response from WebKit")
                }
                sleep(1)
        })
        .disposed(by: self.disposeBag)
        
//        _ = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
//            .debug("interval")
//            .subscribe({_ in
//                self.instructionsVC.instructionsBehaviourSubject.asObserver().take(1).subscribe({ (ev) in
//                    print("Processing: ", ev)
//                    guard let event = ev.element else {
//                        return
//                    }
//                    var evSplit = event.split(separator: " ")
//                    if evSplit.count == 0 {
//                        return;
//                    }
//
//                    switch evSplit[0] {
//                    case "run":
//                        print("")
//                    case "moveFront":
//                        self.arVC.sceneController.playerController.moveFront()
//                        break
//                    case "moveBack":
//                        self.arVC.sceneController.playerController.moveBack()
//                        break
//                    case "turnLeft":
//                        self.arVC.sceneController.playerController.turnLeft()
//                        break
//                    case "turnRight":
//                        self.arVC.sceneController.playerController.turnRight()
//                        break
//                    default:
//                        print("Invalid response from WebKit")
//                    }
//                })
//            })
//            .disposed(by: disposeBag)
//

//        // Subscribe to commands from instructions web kit
//        Observable<String>.zip(self.instructionsVC.instructionsBehaviourSubject.asObserver() as Observable<String>, Observable<Int>.interval(1, scheduler: MainScheduler.init())) {a,b in
//                a
//            }.subscribe { (ev) in
//                print("Processing: ", ev)
//                var evSplit = ev.element!.split(separator: " ")
//                if evSplit.count == 0 {
//                    return;
//                }
//
//                switch evSplit[0] {
//                case "run":
//                    print("")
//                case "moveFront":
//                    self.arVC.sceneController.playerController.moveFront()
//                    break
//                case "moveBack":
//                    self.arVC.sceneController.playerController.moveBack()
//                    break
//                case "turnLeft":
//                    self.arVC.sceneController.playerController.turnLeft()
//                    break
//                case "turnRight":
//                    self.arVC.sceneController.playerController.turnRight()
//                    break
//                default:
//                    print("Invalid response from WebKit")
//                }
//            }
//            .disposed(by: self.disposeBag)
    }
    
    public func setLevelData(levelsVC: UIViewController, repo: LevelsRepository, at: Int) {
        self.levelsVC = levelsVC
        self.levelsRepository = repo
        self.crtLevelAt = at
    }
}
