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
    private let privateDataSource: Variable<[DataLevel]> = Variable([])
    //private let disposeBag = DisposeBag()
    
    // Outputs
    public let dataSource: Observable<[DataLevel]>
    
    init() {
        // Make the output dataSource an Observable of the privateDataSource
        self.dataSource = privateDataSource.asObservable()
    }
    
    public func addItem(item: DataLevel) {
        self.privateDataSource.value.append(item)
    }
    
    public func deleteItem(at: Int) {
        self.privateDataSource.value.remove(at: at)
    }

}
