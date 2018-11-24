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
import RealmSwift
import PopupDialog

class GameUISplitViewController: UISplitViewController {
    public var levelsRepository: LevelsRepository!
    public var crtLevelAt: Int = -1
    
    public var sideVC: SidePageViewController!
    public var instructionsVC: InstructionsViewController!
    public var arVC: ARViewController!
    
    public var engineAR: EngineAR!
    
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
        
        // Instantiate engine ar
        let levelName = self.levelsRepository.get(at: self.crtLevelAt).Name
        self.engineAR = EngineAR(levelName: levelName, player: self.arVC.sceneController.playerController, status: self.instructionsVC.statusTextView)
        
        // Events from Instructions WebView
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
                    self.engineAR.resetLevel()
                case "moveFront":
                    self.engineAR.moveFront()
                    break
                case "moveBack":
                    self.engineAR.moveBack()
                    break
                case "turnLeft":
                    self.engineAR.turnLeft()
                    break
                case "turnRight":
                    self.engineAR.turnRight()
                    break
                default:
                    print("Invalid response from WebKit")
                }
                sleep(1)
                
                DispatchQueue.main.async {
                     self.instructionsVC.statusTextView.text = ""
                }
               
        })
        .disposed(by: self.disposeBag)
        
        // Events from AR Engine
        self.engineAR.eventsBehaviourSubject
            .asObserver()
            .subscribe({ (ev) in
                print(ev.event)
                
                switch ev.element {
                case "invalid":
                    let popUP = PopupDialog(title: "Sorry", message: "You can try again")
                    self.present(popUP, animated: true, completion: nil)
                case "done":
                    let popUP = PopupDialog(title: "Congrats", message: "Well done, you can advance to the next level")
                    self.present(popUP, animated: true, completion: nil)
                default :
                    print("Invalid event received")
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    public func setLevelData(levelsVC: UIViewController, repo: LevelsRepository, at: Int) {
        self.levelsVC = levelsVC
        self.levelsRepository = repo
        self.crtLevelAt = at
    }
}
