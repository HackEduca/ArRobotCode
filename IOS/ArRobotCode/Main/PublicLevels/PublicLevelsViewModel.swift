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
    }
    
    let output: Output
    struct Output {
        let listOfCells: Observable<[SectionModel<String, DataLevel>]>
    }
    
    struct CellInfo {
        let level: DataLevel?
        let sectionNumber: Int
    }
    
    // Private members
    private let listOfLevelsSubject     = ReplaySubject<[DataLevel]>.create(bufferSize: 1)
    private let disposeBag              = DisposeBag()
    private var listOfCells: [SectionModel<String, DataLevel>]  = []
    
    init() {
        self.input = Input(listOfLevels: self.listOfLevelsSubject.asObserver())
        self.listOfCells = []
        
        let out = self.listOfLevelsSubject.map { (levels) -> [SectionModel<String, DataLevel>] in
            if levels.count == 0 {
                return []
            }

            // Sort by Chapter Name
            var lvlsByChapter: [DataLevel] = levels
            lvlsByChapter.sort(by: { (levelA, levelB) -> Bool in
                return levelA.Chapter < levelB.Chapter
            })
            
            // Form the CellInfo
            var cells: [SectionModel<String, DataLevel>] = []
            var sectionNumber = -1
                
            var i = 0
            while i < lvlsByChapter.count {
                if i == 0 || lvlsByChapter[i].Chapter != lvlsByChapter[i - 1].Chapter {
                    sectionNumber += 1
                    cells.append(SectionModel<String, DataLevel>(model: lvlsByChapter[i].Chapter, items: []))
                }
                
                if lvlsByChapter[i].Public == true {
                    cells[sectionNumber].items.append(lvlsByChapter[i])
                }
            
                i += 1
            }
            
            return cells
        }
        
        self.output = Output(listOfCells: out)
        
        // Keep a non observable copy
        self.output.listOfCells.subscribe({ ev in
            self.listOfCells = ev.element!
        }).disposed(by: self.disposeBag)
    }
    
    func getLevel(atSection: Int, atRow: Int) -> DataLevel {
        return self.listOfCells[atSection].items[atRow]
    }
    
}

