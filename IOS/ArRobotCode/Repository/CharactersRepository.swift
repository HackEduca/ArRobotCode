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
    private var characters: [Character] = []
    private let charactersSubject = ReplaySubject<[Character]>.create(bufferSize: 1)
    
    // Make constructor private
    private init() {
        self.db = Firestore.firestore()
        self.getCharactersFromServer()
    }
    
    func doInit() {
        
    }
    
    func getCharcters() ->[Character] {
        return self.characters
    }
    
    func getCharacter(byID: String) -> Character? {
        for character in self.characters {
            if character.ID == byID {
                return character
            }
        }
        
        return nil
    }
    
    private func getCharactersFromServer() {
        let docRef = db.collection("characters")
        self.characters = []
        
        docRef.getDocuments(completion: { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                do {
                    let character = try JSONDecoder().decode(Character.self, withJSONObject: document.data(), options: [])
                    character.ID = document.documentID
                    self.characters.append(character)
                } catch {
                    
                }
            }
            
            self.characters = self.characters.sorted(by: { (characterA, characterB) -> Bool in
                return characterA.LevelRequired < characterB.LevelRequired
            })
            self.charactersSubject.onNext(self.characters)

        })
    }
}
