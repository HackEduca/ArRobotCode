//
//  AchievementsViewModel.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 18/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import RxSwift

final class AchievementsViewModel {
    // Public members
    let input: Input
    struct Input {
        let listOfAchievements: AnyObserver<[Achievement]>
        let userProperties: AnyObserver<UserProperties>
    }
    
    let output: Output
    struct Output {
        let listOfCellInfo: Observable<[CellInfo]>
    }
    
    struct CellInfo {
        let achievement: Achievement
        let locked: Bool
    }
    
    // Private members
    private let listOfAchievementsSubject = ReplaySubject<[Achievement]>.create(bufferSize: 1)
    private let userPropertiesSubject   = ReplaySubject<UserProperties>.create(bufferSize: 1)
    private let outputSubject           = ReplaySubject<[CellInfo]>.create(bufferSize: 1)
    private let disposeBag              = DisposeBag()
    
    init() {
        self.input = Input(listOfAchievements: self.listOfAchievementsSubject.asObserver(), userProperties: self.userPropertiesSubject.asObserver())
        
        let obs1 = self.listOfAchievementsSubject.asObservable()
        let obs2 = self.userPropertiesSubject.asObservable()
        let out = Observable.combineLatest(obs1, obs2, resultSelector: { value1, value2 in
            (value1, value2)
        }).map { (elem) -> [CellInfo] in
            let achievements = elem.0
            let userProperties = elem.1
            var cells: [CellInfo] = []
            
            for achievement in achievements {
                var locked = true
                
                for userAchievement in userProperties.Achievements {
                    if userAchievement == achievement.ID {
                        locked = false
                        break
                    }
                }

                let crtCellInfo = CellInfo(achievement: achievement, locked: locked)
                cells.append(crtCellInfo)
            }
            
            // Show the achieved achievements first
            cells.sort(by: { (cellA, cellB) -> Bool in
                return cellA.locked == false && cellB.locked == true
            })
            
            return cells
        }
        
        self.output = Output(listOfCellInfo: out)
    }
}
