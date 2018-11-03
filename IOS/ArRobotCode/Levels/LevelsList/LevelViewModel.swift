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
    private let privateDataSource: Variable<[DataTile]> = Variable([])
    //private let disposeBag = DisposeBag()
    
    // Outputs
    public var dataSource: Observable<[DataTile]> {
        return self.privateDataSource.asObservable()
    }
    
    init(tiles: [DataTile]) {
        self.privateDataSource.value = tiles
    }
    
    public func changeTile(at: Int, newTile: DataTile ) {
        self.privateDataSource.value[at] = newTile
    }
    
}
