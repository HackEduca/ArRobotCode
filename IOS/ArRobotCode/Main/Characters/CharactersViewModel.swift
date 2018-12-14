//
//  CharactersMVVM.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 13/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import RxSwift

final class CharactersViewModel {
    // Public members
    let input: Input
    struct Input {
        let listOfCharacters: AnyObserver<[Character]>
        let userProperties: AnyObserver<UserProperties>
    }
    
    let output: Output
    struct Output {
        let listOfCellInfo: Observable<[CellInfo]>
    }

    struct CellInfo {
        let character: Character
        let chosen: Bool
    }
    
    // Private members
    private let listOfCharactersSubject = ReplaySubject<[Character]>.create(bufferSize: 1)
    private let userPropertiesSubject   = ReplaySubject<UserProperties>.create(bufferSize: 1)
    private let outputSubject           = ReplaySubject<[CellInfo]>.create(bufferSize: 1)
    private let disposeBag              = DisposeBag()
    
    init() {
        self.input = Input(listOfCharacters: self.listOfCharactersSubject.asObserver(), userProperties: self.userPropertiesSubject.asObserver())
        
        let obs1 = self.listOfCharactersSubject.asObservable()
        let obs2 = self.userPropertiesSubject.asObservable()
        let out = Observable.combineLatest(obs1, obs2, resultSelector: { value1, value2 in
             (value1, value2)
        }).map { (elem) -> [CellInfo] in
            let characters = elem.0
            let userProperties = elem.1
            
            var cells: [CellInfo] = []
            for character in characters {
                var chosen = false
                var crtCellInfo = CellInfo(character: character, chosen: false)
                
                cells.append(crtCellInfo)
            }
            
            return cells
        }
        
        self.output = Output(listOfCellInfo: out)
        
    }
   
}
