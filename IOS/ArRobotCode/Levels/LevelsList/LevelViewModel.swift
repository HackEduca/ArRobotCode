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

class LevelViewModel{
    private var level: BehaviorSubject<DataLevel> = BehaviorSubject(value: DataLevel())
    
    public var levelObserver: Observable<DataLevel> {
        return self.level.asObservable()
    }
    
    
    init(level: DataLevel) {
        self.level.onNext(level)
    }
    
    public func swapTile(at: Int) {
        do {
            try self.level.value().Tiles[at].swap()
            self.level.onNext(try self.level.value())
        } catch {
        
        }
    }
    
    public func setToStartTile(at: Int) {
        do {
            try self.level.value().Tiles[at].setToStart()
            self.level.onNext(try self.level.value())
        } catch {
        }
    }
    
    public func setName(newName: String) {
        do {
            try self.level.value().Name = newName
            self.level.onNext(try self.level.value())
        } catch {
            
        }
    }
    
    public func setHeight(newHeight: String) {
        do {
            // To do: make it safe
            try self.level.value().Height = Int(newHeight)!
            self.level.onNext(try self.level.value())
        } catch {
            
        }
    }
    
    
    public func setWidth(newWidth: String) {
        do {
            // To do: make it safe
            try self.level.value().Width = Int(newWidth)!
            self.level.onNext(try self.level.value())
        } catch {
            
        }
    }
    
    
}
