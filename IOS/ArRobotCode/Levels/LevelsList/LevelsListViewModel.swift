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

class LevelsListViewModel{

    // Private properties
    private let privateDataSource: LevelsRepository
    //private let disposeBag = DisposeBag()
    
    // Outputs
    public let dataSource: Observable<[DataLevel]>
    
    init(repo: LevelsRepository) {
        // Make the output dataSource an Observable of the privateDataSource
        self.privateDataSource = repo
        self.dataSource = privateDataSource.dataSource
    }
    
    public func addItem(item: DataLevel) {
        self.privateDataSource.add(a: item)
    }
    
    public func deleteItem(at: Int) {
        self.privateDataSource.delete(at: at)
    }

}
