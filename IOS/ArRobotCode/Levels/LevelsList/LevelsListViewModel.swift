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
        
        // Filter the levels that are showed
        self.dataSource = privateDataSource.dataSource.map({ (data) -> [DataLevel] in
            var filteredLevels: [DataLevel] = []
            
            for level in data {
                if UserRepository.shared.getUserProperties()?.Role == "admin" ||  UserRepository.shared.getUser()!.uid == level.ByUserID {
                    filteredLevels.append(level)
                }
            }
            
            return filteredLevels
        })
    }
    
    public func addItem(item: DataLevel) {
        self.privateDataSource.add(a: item)
    }
    
    public func deleteItem(at: Int) {
        self.privateDataSource.delete(at: at)
    }

}
