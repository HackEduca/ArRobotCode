//
//  LevelsListViewModel.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 29/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
class LevelViewModel{
    private var levelsRepository: LevelsRepository;
    private var levelAt: Int = -1;
    
    private var level: BehaviorSubject<DataLevel> = BehaviorSubject(value: DataLevel())
    public var levelObserver: Observable<DataLevel> {
        return self.level.asObservable()
    }
    
    
    init(repository: LevelsRepository, at: Int) {
        self.levelsRepository = repository
        self.levelAt = at
        self.level.onNext(repository.get(at: at))
    }
    
    public func swapTile(at: Int) {
        self.levelsRepository.get(at: self.levelAt).Tiles[at].swap()
        self.level.onNext(self.levelsRepository.get(at: self.levelAt))
        self.levelsRepository.triggerUpdate(at: self.levelAt)
    }
    
    public func swipeLeftTile(at: Int) {
        self.levelsRepository.get(at: self.levelAt).Tiles[at].cycleRight()
        self.level.onNext(self.levelsRepository.get(at: self.levelAt))
        self.levelsRepository.triggerUpdate(at: self.levelAt)
    }
    
    public func swipeRightTile(at: Int) {
        self.levelsRepository.get(at: self.levelAt).Tiles[at].cycleLeft()
        self.level.onNext(self.levelsRepository.get(at: self.levelAt))
        self.levelsRepository.triggerUpdate(at: self.levelAt)
    }
    
    public func setToStartTile(at: Int) {
        self.levelsRepository.get(at: self.levelAt).Tiles[at].setToStart()
        self.level.onNext(self.levelsRepository.get(at: self.levelAt))
        self.levelsRepository.triggerUpdate(at: self.levelAt)
    }
    
    public func setName(newName: String) {
        if newName == "" {
            return;
        }
        
        self.levelsRepository.get(at: self.levelAt).setName(newName: newName)
        self.level.onNext(self.levelsRepository.get(at: self.levelAt))
        self.levelsRepository.triggerUpdate(at: self.levelAt)
    }
    
    public func setHeight(newHeight: String) {
        if self.levelsRepository.get(at: self.levelAt).Height == Int(newHeight) {
            return
        }
        
        self.levelsRepository.get(at: self.levelAt).setHeight(newHeight: Int(newHeight)!)
        self.level.onNext(self.levelsRepository.get(at: self.levelAt))
        self.levelsRepository.triggerUpdate(at: self.levelAt)
    }
    
    public func setWidth(newWidth: String) {
        if self.levelsRepository.get(at: self.levelAt).Width == Int(newWidth) {
            return
        }
        
        self.levelsRepository.get(at: self.levelAt).setWidth(newWidth: Int(newWidth)!)
        self.level.onNext(self.levelsRepository.get(at: self.levelAt))
        self.levelsRepository.triggerUpdate(at: self.levelAt)
    }

}
