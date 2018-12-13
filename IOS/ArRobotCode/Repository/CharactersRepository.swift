//
//  CharactersRepository.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 13/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import Firebase

class CharacterRepository {
    static let shared = CharacterRepository()
    
    private let db: Firestore!
    private var characters: [Character] = []
    
    // Make constructor private
    private init() {
        self.db = Firestore.firestore()
        self.getCharactersFromServer()
    }
    
    func doInit() {
        
    }
    
    func getCharcters() ->[Character] {
        return self.characters.sorted(by: { (characterA, characterB) -> Bool in
            return characterA.LevelRequired < characterB.LevelRequired
        })
    }
    
    private func getCharactersFromServer() {
        let docRef = db.collection("characters")
        self.characters = []
        
        docRef.getDocuments(completion: { (querySnapshot, err) in
            for document in querySnapshot!.documents {
                do {
                    let character = try JSONDecoder().decode(Character.self, withJSONObject: document.data(), options: [])
                    self.characters.append(character)
                } catch {
                    
                }
                
            }
        })
    }
}
