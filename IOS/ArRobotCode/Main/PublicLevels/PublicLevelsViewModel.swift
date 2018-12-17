//
//  PublicLevelsViewModel.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 15/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

//
//  CharactersMVVM.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 13/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import RxSwift

final class PublicLevelsViewModel {
    // Public members
    let input: Input
    struct Input {
        let listOfLevels: AnyObserver<[DataLevel]>
    }
    
    let output: Output
    struct Output {
        let listOfCellInfo: Observable<[CellInfo]>
    }
    
    struct CellInfo {
        let level: DataLevel?
        let sectionNumber: Int
    }
    
    // Private members
    private let listOfLevelsSubject     = ReplaySubject<[DataLevel]>.create(bufferSize: 1)
    private let outputSubject           = ReplaySubject<[CellInfo]>.create(bufferSize: 1)
    private let disposeBag              = DisposeBag()
    
    init() {
        self.input = Input(listOfLevels: self.listOfLevelsSubject.asObserver())
    
        let out = self.listOfLevelsSubject.map { (levels) -> [CellInfo] in
            var lvls: [DataLevel] = levels
            if lvls.count == 0 {
                return []
            }
            
            // Sort by Chapter Name
            lvls.sort(by: { (levelA, levelB) -> Bool in
                return levelA.Chapter < levelB.Chapter
            })
            
            // Form the CellInfo
            var cells: [CellInfo] = []
            var sectionNumber = 0
            var i = 0
            while i < lvls.count {
                if i > 0 && lvls[i].Chapter != lvls[i - 1].Chapter {
                    sectionNumber += 1
                }
                
                cells.append(CellInfo(level: lvls[i], sectionNumber: sectionNumber))
                i += 1
            }
            
            return cells
        }
        
        self.output = Output(listOfCellInfo: out)
    }
    
}

