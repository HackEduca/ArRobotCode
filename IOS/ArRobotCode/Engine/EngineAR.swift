//
//  EngineAR.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 22/11/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

struct Position {
    var x: Int
    var y: Int
}

class EngineAR: EngineInterface {
    public var eventsBehaviourSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    private var playerController: PlayerAR!
    private var levelName: String!
    private var valid: Bool = true
    private var done: Bool = false
    
    private var crtPosition: Position = Position(x: 0, y: 0)

    
    init(levelName: String, player: PlayerAR!) {
        self.levelName = levelName
        self.playerController = player
        

        let level = getLevel()!
        for i in 0...level.Tiles.count - 1 {
            if level.Tiles[i].type == TypeOfTile.Start.rawValue {
                (self.crtPosition.x, self.crtPosition.y) = vectorCoordinatesToMatrix(i: i)
                break
            }
        }
    }
    
    func isValid() -> Bool {
        return self.valid
    }
    
    func isDone() -> Bool {
        return self.done
    }
    
    func moveFront() {
        self.playerController.moveFront()
        var vertical = false
        
        // UP
        if(self.playerController.player.simdWorldFront[2] == 1) {
            self.crtPosition.x -= 1
            vertical = true
        }
        
        // DOWN
        if(self.playerController.player.simdWorldFront[2] == -1) {
            self.crtPosition.x += 1
            vertical = true
        }
        
        // LEFT
        if(!vertical && self.playerController.player.simdWorldFront[0] < 0) {
            self.crtPosition.y -= 1
        }
        
        // RIGHT
        if(!vertical && self.playerController.player.simdWorldFront[0] > 0) {
            self.crtPosition.y += 1
        }
        
       
        if self.checkIfInvalid() {
            return
        }
        checkIfDone()
    }
    
    func moveBack() {
        self.playerController.moveBack()
       
        var vertical = false
        
        // UP
        if(self.playerController.player.simdWorldFront[2] == -1) {
            self.crtPosition.x -= 1
            vertical = true
        }
        
        // DOWN
        if(self.playerController.player.simdWorldFront[2] == 1) {
            self.crtPosition.x += 1
            vertical = true
        }
        
        // LEFT
        if(!vertical && self.playerController.player.simdWorldFront[0] > 0) {
            self.crtPosition.y -= 1
        }
        
        // RIGHT
        if(!vertical && self.playerController.player.simdWorldFront[0] < 0) {
            self.crtPosition.y += 1
        }
        
        if self.checkIfInvalid() {
            return
        }
        checkIfDone()
    }
    
    func turnLeft() {
        self.playerController.turnLeft()
    }
    
    func turnRight() {
        self.playerController.turnRight()
    }
    
    private func checkIfInvalid() -> Bool {
        // If out of bounds
        let lvl = getLevel()!
        if(self.crtPosition.x < 0 || self.crtPosition.x >= lvl.Height ||
            self.crtPosition.y < 0 || self.crtPosition.y >= lvl.Width ) {
            self.valid = false
            self.eventsBehaviourSubject.onNext("invalid")
            return true
        }
        
        // If wrong tile
        if lvl.Tiles[ matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y) ].type == TypeOfTile.Free.rawValue {
            self.valid = false
            self.eventsBehaviourSubject.onNext("invalid")
            return true
        }
        
        return false
    }
    
    private func checkIfDone() -> Bool {
        // If final tile
        let lvl = getLevel()!
        if lvl.Tiles[ matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y) ].type == TypeOfTile.Finish.rawValue {
            self.done = true
            self.eventsBehaviourSubject.onNext("done")
            return true
        }
        
        return false
    }
    
    private func matrixCoordinatesToVector(i: Int, j: Int) -> Int {
        let lvl = getLevel()!
        
        // The actual computation
        return i * lvl.Width + j
    }
    
    private func vectorCoordinatesToMatrix(i: Int) -> (Int, Int) {
        let lvl = getLevel()!
        
        // The actual computation
        return (i / lvl.Width, i % lvl.Height)
    }
    
    private func getLevel() -> DataLevel? {
        do {
            let realm = try Realm()
            let pred = NSPredicate(format: "Name = %@", self.levelName)
            guard let level = realm.objects(DataLevel.self).filter(pred).first else {
                print("Error at resolving object")
                return nil
            }
            
            return level
        } catch {
            return nil
        }
    }
}
