//
//  CharactersRepository.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 13/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
class CharacterRepository {
    public static let shared = CharacterRepository()
    public var charactersObservable: Observable<[Character]> {
        get {
            return self.charactersSubject.asObservable()
        }
    }

    private let db: Firestore!
    private let charactersSubject = ReplaySubject<[Character]>.create(bufferSize: 1)
    
    // Make constructor private
    private init() {
        self.db = Firestore.firestore()
        self.getCharactersFromServer()
    }
    
    func doInit() {
        
    }
    
    func getCharacter(byID: String) -> Observable<Character?> {
        return self.charactersSubject.map({ (characters) -> Character? in
            for character in characters {
                if character.ID == byID {
                    return character
                }
            }
            return nil
        })

    }
    
    private func getCharactersFromServer() {
        let docRef = db.collection("characters")
        
        docRef.getDocuments(completion: { (querySnapshot, err) in
            var characters: [Character] = []
            for document in querySnapshot!.documents {
                do {
                    let character = try JSONDecoder().decode(Character.self, withJSONObject: document.data(), options: [])
                    character.ID = document.documentID
                    characters.append(character)
                } catch {
                }
            }
            
            characters = characters.sorted(by: { (characterA, characterB) -> Bool in
                return characterA.LevelRequired < characterB.LevelRequired
            })
            self.charactersSubject.onNext(characters)
        })
    }
}
