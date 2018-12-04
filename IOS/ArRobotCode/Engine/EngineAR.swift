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
    private var status: UITextView!
    
    private var valid: Bool = true
    private var done: Bool = false
    
    private var startPosition: Position = Position(x: 0, y: 0)
    private var crtPosition: Position = Position(x: 0, y: 0)
    
    private var dxdy = [ Position(x: -1, y: 0), Position(x: 0, y: 1) , Position(x: 1, y: 0), Position(x: 0, y: -1)]
    private var crtDXDY = 0

    
    init(levelName: String, player: PlayerAR!, status: UITextView) {
        self.levelName = levelName
        self.playerController = player
        self.status = status
        

        let level = getLevel()!
        for i in 0...level.Tiles.count - 1 {
            if level.Tiles[i].Type == TypeOfTile.Start.rawValue {
                (self.startPosition.x, self.startPosition.y) = vectorCoordinatesToMatrix(i: i)
                self.crtPosition = self.startPosition
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
    
    func isFinished() -> Bool {
        return !self.valid || self.done
    }
    
    func moveFront() {
        // Stop moving is game is finished
        if isFinished() {
            return;
        }
        
        DispatchQueue.main.async {
            self.status.text = "Moving in front"
        }
        self.playerController.moveFront()
        
        // Move
        self.crtPosition.x += self.dxdy[self.crtDXDY].x
        self.crtPosition.y += self.dxdy[self.crtDXDY].y
       
        if self.checkIfInvalid() {
            return
        }
        checkIfDone()
    }
    
    func moveFrontIf(ifTileType: String) {
        let crtVectorPos = self.matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y)
        if self.getLevel()?.Tiles[crtVectorPos].Type == Int(ifTileType)! + 3 {
            moveFront()
        } else {
            DispatchQueue.main.async {
                self.status.text = "Not moving front, tile is of different type"
            }
        }
    }
    
    func moveBack() {
        // Stop moving is game is finished
        if isFinished() {
            return;
        }
        
        DispatchQueue.main.async {
            self.status.text = "Moving back"
        }
        self.playerController.moveBack()

        // Move
        self.crtPosition.x -= self.dxdy[self.crtDXDY].x
        self.crtPosition.y -= self.dxdy[self.crtDXDY].y
        
        if self.checkIfInvalid() {
            return
        }
        checkIfDone()
    }
    
    func moveBackIf(ifTileType: String) {
        let crtVectorPos = self.matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y)
        if self.getLevel()?.Tiles[crtVectorPos].Type == Int(ifTileType)! + 3  {
            moveBack()
        } else {
            DispatchQueue.main.async {
                self.status.text = "Not moving back, tile is of different type"
            }
        }
    }
    
    func turnLeft() {
        // Stop moving is game is finished
        if isFinished() {
            return;
        }
        
        DispatchQueue.main.async {
            self.status.text = "Moving left"
        }
        self.playerController.turnLeft()
        self.crtDXDY -= 1
        self.crtDXDY %= 4
        if self.crtDXDY == -1 {
            self.crtDXDY = 3
        }
    }
    
    func turnLeftIf(ifTileType: String) {
        let crtVectorPos = self.matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y)
        if self.getLevel()?.Tiles[crtVectorPos].Type == Int(ifTileType)! + 3  {
            turnLeft()
        } else {
            DispatchQueue.main.async {
                self.status.text = "Not turning left, tile is of different type"
            }
        }
    }
    
    func turnRight() {
        // Stop moving is game is finished
        if isFinished() {
            return;
        }
        
        DispatchQueue.main.async {
            self.status.text = "Moving right"
        }
        self.playerController.turnRight()
        self.crtDXDY += 1
        self.crtDXDY %= 4
    }
    
    func turnRightIf(ifTileType: String) {
        let crtVectorPos = self.matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y)
        if self.getLevel()?.Tiles[crtVectorPos].Type == Int(ifTileType)! + 3  {
            turnRight()
        } else {
            DispatchQueue.main.async {
                self.status.text = "Not turning right, tile is of different type"
            }
        }
    }
    
    func resetLevel() {
        DispatchQueue.main.async {
            self.status.text = "Starting..."
        }
        self.crtPosition = self.startPosition
        self.crtDXDY = 0
        self.valid = true
        self.done = false
        self.playerController.reset()
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
        var pos = matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y)
        var type = lvl.Tiles[ matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y) ].Type
        if lvl.Tiles[ matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y) ].Type == TypeOfTile.Free.rawValue {
            self.valid = false
            self.eventsBehaviourSubject.onNext("invalid")
            return true
        }
        
        return false
    }
    
    private func checkIfDone() -> Bool {
        // If final tile
        let lvl = getLevel()!
        if lvl.Tiles[ matrixCoordinatesToVector(i: self.crtPosition.x, j: self.crtPosition.y) ].Type == TypeOfTile.Finish.rawValue {
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
        return (i / lvl.Width, i % lvl.Width)
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
