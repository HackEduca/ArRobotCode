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
import PopupDialog
import RxGesture

class GameUISplitViewController: UISplitViewController {
    public var levelsRepository: LevelsRepository!
    public var crtLevelAt: Int = -1
    
    public var sideVC: SidePageViewController!
    public var instructionsVC: InstructionsViewController!
    public var arVC: ARViewController!
    
    public var isBackMain = false
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
        self.engineAR = EngineAR(level: self.levelsRepository.get(at: self.crtLevelAt), player: self.arVC.sceneController.playerController, status: self.instructionsVC.statusTextView)
        
        // Reset the level initially
        self.engineAR.resetLevel()
        
        // Events
        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        self.instructionsVC.eventsBehaviourSubject.asObserver()
            .observeOn(concurrentScheduler)
            .subscribeOn(concurrentScheduler)
            .subscribe({ (ev) in
                guard let event = ev.element else {
                    return
                }
                print("Processing event: ", event)
                
                var evSplit = event.split(separator: " ")
                if evSplit.count == 0 {
                    return;
                }
                
                switch evSplit[1] {
                case "stop":
                    self.engineAR.stopLevel()

                default:
                    print(evSplit)
                    print("Invalid response from WebKit")
                }

            })
            .disposed(by: self.disposeBag)
        
        // Instructions
        self.instructionsVC.instructionsBehaviourSubject.asObserver()
            .observeOn(concurrentScheduler)
            .subscribeOn(concurrentScheduler)
            .subscribe({ (ev) in
                guard let event = ev.element else {
                    return
                }
                
                print("Processing instruction: ", event)
                var evSplit = event.split(separator: " ")
                if evSplit.count == 0 {
                    return;
                }
                
                if self.engineAR.isFinished() && evSplit[1] != "run" {
                    print("Finished -> fast")
                    return
                }
                
                // Make block glow
                DispatchQueue.main.async {
                    self.instructionsVC.sendToJS(message: "Blockly.getMainWorkspace().glowBlock(\"" + evSplit[0] + "\", true);")
                }
                
                switch evSplit[1] {
                case "run":
                    self.engineAR.resetLevel()
                    print("Game started")
                case "moveFront":
                    self.engineAR.moveFront()
                    break
                case "moveFrontIf":
                    self.engineAR.moveFrontIf(ifTileType: String(evSplit[2]))
                    break
                case "moveBack":
                    self.engineAR.moveBack()
                    break
                case "moveBackIf":
                    self.engineAR.moveBackIf(ifTileType: String(evSplit[2]))
                    break
                case "turnLeft":
                    self.engineAR.turnLeft()
                    break
                case "turnLeftIf":
                    self.engineAR.turnLeftIf(ifTileType: String(evSplit[2]))
                    break
                case "turnRight":
                    self.engineAR.turnRight()
                    break
                case "turnRightIf":
                    self.engineAR.turnRightIf(ifTileType: String(evSplit[2]))
                    break
                default:
                    print(evSplit)
                    print("Invalid response from WebKit")
                }
                
                // To do: move this inside of each instruction
                sleep(1)
                
                // Stop glowing
                DispatchQueue.main.async {
                    self.instructionsVC.sendToJS(message: "Blockly.getMainWorkspace().glowBlock(\"" + evSplit[0] + "\", false);")
                }
                
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
                    // Mark level as completed
                    UserRepository.shared.addCompletedLevel(levelID: self.levelsRepository.get(at: self.crtLevelAt).UUID)
                    
                    let popUP = PopupDialog(title: "Congrats", message: "Well done, you can advance to the next level")
                    self.present(popUP, animated: true, completion: nil)
                default :
                    print("Invalid event received")
                }
            })
            .disposed(by: self.disposeBag)
        
        // Back button click
        self.instructionsVC.backButton.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                if self.isBackMain == true {
                    self.navigateToMainInterface()
                } else {
                    self.navigateToLevelsInterface()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    public func setLevelData(levelsVC: UIViewController, repo: LevelsRepository, at: Int) {
        self.levelsVC = levelsVC
        self.levelsRepository = repo
        self.crtLevelAt = at
    }
    
    func navigateToLevelsInterface() {
        // Get the storyboard
        let gameStoryboard = UIStoryboard(name: "Levels", bundle: Bundle.main)
        
        // Instantiate the VC
        guard let levelsSplitViewController = gameStoryboard.instantiateInitialViewController() as? LevelsSplitViewController else {
            return
        }
        
        // Configure the initial level to be showed
        levelsSplitViewController.at = self.crtLevelAt
        
        // Show
        present(levelsSplitViewController, animated: true, completion: nil)
    }
    
    func navigateToMainInterface() {
        // Get the storyboard
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate the VC
        guard let mainController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
            return
        }
        
        // Show
        present(mainController, animated: true, completion: nil)
    }
}
