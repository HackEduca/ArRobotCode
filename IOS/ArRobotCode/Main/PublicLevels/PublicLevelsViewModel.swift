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
import RxDataSources

final class PublicLevelsViewModel {
    // Public members
    let input: Input
    struct Input {
        let listOfLevels: AnyObserver<[DataLevel]>
        let userProperties: AnyObserver<UserProperties>
    }
    
    let output: Output
    struct Output {
        let listOfCells: Observable<[SectionModel<String, CellInfo>]>
    }
    
    struct CellInfo {
        let level: DataLevel
        let isCompleted: Bool
    }
    
    // Private members
    private let listOfLevelsSubject     = ReplaySubject<[DataLevel]>.create(bufferSize: 1)
    private let userPropertiesSubject   = ReplaySubject<UserProperties>.create(bufferSize: 1)
    private let disposeBag              = DisposeBag()
    
    init() {
        self.input = Input(listOfLevels: self.listOfLevelsSubject.asObserver(), userProperties: self.userPropertiesSubject.asObserver())
        
        let out =  Observable
            .combineLatest(self.listOfLevelsSubject.asObservable(),
                           self.userPropertiesSubject.asObservable(),
                           resultSelector: { value1, value2 in (value1, value2)}
            )
            .take(1)
            .map { (element) -> [SectionModel<String, CellInfo>] in
                let levels = element.0
                let userProperties = element.1
                
                
                if levels.count == 0 {
                    return []
                }

                // Sort by Chapter Name
                var lvlsByChapter: [DataLevel] = levels
                lvlsByChapter.sort(by: { (levelA, levelB) -> Bool in
                    return levelA.Chapter < levelB.Chapter
                })
                
                // Form the CellInfo
                var cells: [SectionModel<String, CellInfo>] = []
                var sectionNumber = -1
                
                var i = 0
                while i < lvlsByChapter.count {
                    if i == 0 || lvlsByChapter[i].Chapter != lvlsByChapter[i - 1].Chapter {
                        sectionNumber += 1
                        cells.append(SectionModel<String, CellInfo>(model: lvlsByChapter[i].Chapter, items: []))
                    }
                    
                    if lvlsByChapter[i].Public == true {
                        var isCompleted = false
                        
                        for lvlCompleted in userProperties.CompletedLevels {
                            if lvlCompleted == lvlsByChapter[i].UUID {
                                isCompleted = true
                                break
                            }
                        }
                        cells[sectionNumber].items.append(CellInfo(level: lvlsByChapter[i], isCompleted: isCompleted))
                    }
                
                    i += 1
                }
                
                return cells
        }
        
        self.output = Output(listOfCells: out)
    }
    
    func getLevel(atSection: Int, atRow: Int) -> Observable<CellInfo> {
        return self.output.listOfCells.asObservable().map({ (cells) -> CellInfo in
            return cells[atSection].items[atRow]
        })
    }
}

