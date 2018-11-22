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
    private var level: DataLevel!
    private var valid: Bool = true
    private var done: Bool = false
    
    private var crtPosition: Position = Position(x: 0, y: 0)

    
    init(levelReference: ThreadSafeReference<DataLevel>, player: PlayerAR!) {
        do {
            let realm = try Realm()
            self.level = realm.resolve(levelReference)
            print(self.level)
        } catch {
            
        }
        
        self.playerController = player
        
        for i in 0...self.level.Tiles.count - 1 {
            if self.level.Tiles[i].type == TypeOfTile.Start.rawValue {
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
        
//        // If out of bounds
//        print(self.level.Height)
//        if(self.crtPosition.x < 0 || self.crtPosition.x >= self.level.Height ||
//            self.crtPosition.y < 0 || self.crtPosition.y >= self.level.Width ) {
//            self.valid = false
//            self.eventsBehaviourSubject.onNext("invalid")
//        }
//        
//        // If wrong tile
//        if self.level.Tiles[ matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y) ].type == TypeOfTile.Free.rawValue {
//            self.valid = false
//            self.eventsBehaviourSubject.onNext("invalid")
//        }
//        
//        // If final tile
//        if self.level.Tiles[ matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y) ].type == TypeOfTile.Finish.rawValue {
//            self.done = true
//            self.eventsBehaviourSubject.onNext("done")
//        }
    }
    
    func moveBack() {
        self.playerController.moveBack()
        // To do: check if valid or done
    }
    
    func turnLeft() {
        self.playerController.turnLeft()
    }
    
    func turnRight() {
        self.playerController.turnRight()
    }
    
    private func matrixCoordinatesToVector(i: Int, j: Int) -> Int {
        return i * self.level.Width + j
    }
    
    private func vectorCoordinatesToMatrix(i: Int) -> (Int, Int) {
        return (i / self.level.Width, i % self.level.Height)
    }
}
