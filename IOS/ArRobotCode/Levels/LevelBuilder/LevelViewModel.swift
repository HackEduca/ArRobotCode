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
    private var level: BehaviorSubject<DataLevel> = BehaviorSubject(value: DataLevel())
    private var levelAt: Int = -1;
    let realm = try! Realm()
    
    public var levelObserver: Observable<DataLevel> {
        return self.level.asObservable()
    }
    
    
    init(repository: LevelsRepository, at: Int) {
        self.levelsRepository = repository
        self.levelAt = at
        self.level.onNext(repository.get(at: at))
    }
    
    public func swapTile(at: Int) {
        do {
            try! self.realm.write {
                 try self.level.value().Tiles[at].swap()
            }
            self.level.onNext(try self.level.value())
        } catch {
        
        }
    }
    
    public func setToStartTile(at: Int) {
        do {
            try! self.realm.write {
                try self.level.value().Tiles[at].setToStart()
            }
            self.level.onNext(try self.level.value())
        } catch {
        }
    }
    
    public func setName(newName: String) {
        do {
            try! self.realm.write {
                try self.level.value().Name = newName
            }
            self.level.onNext(try self.level.value())
            self.levelsRepository.update(at: self.levelAt, newDataLevel: try self.level.value())
        } catch {
            
        }
    }
    
    public func setHeight(newHeight: String) {
        do {
            if try self.level.value().Height != Int(newHeight) {
                try! self.realm.write {
                    try self.level.value().Height = Int(newHeight)!
                    self.reAssignTiles()
                }
                
                self.level.onNext(try self.level.value())
            }
        } catch {
            
        }
    }
    
    
    public func setWidth(newWidth: String) {
        do {
            if try self.level.value().Width != Int(newWidth) {
                try! self.realm.write {
                    try self.level.value().Width = Int(newWidth)!
                    self.reAssignTiles()
                }
                self.level.onNext(try self.level.value())
            }
        } catch {
            
        }
    }
    
    private func reAssignTiles() {
        do {
            // Generate a new array of tiles
            var tiles: List<DataTile> = List<DataTile>()
            for i in 0..<(try self.level.value().Width * self.level.value().Height) {
                var newTile = DataTile()
                newTile.type = TypeOfTile.Free.rawValue
                tiles.append(newTile)
            }
            
            try self.level.value().Tiles = tiles
            self.level.onNext(try self.level.value())
        } catch {
            
        }
    }
}
