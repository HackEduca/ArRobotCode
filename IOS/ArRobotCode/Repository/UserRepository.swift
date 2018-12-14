//
//  UserRepository.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 12/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import Firebase

class UserRepository {
    static let shared = UserRepository()
    
    private let firebaseAuth: Auth!
    private let db: Firestore!
    private var userProperties: UserProperties?
    
    // Make constructor private
    private init() {
        self.firebaseAuth = Auth.auth()
        self.db = Firestore.firestore()
        self.getUserPropertiesFromServer()
    }
    
    func doInit() {
        
    }
    
    func getUser() -> User?{
        return self.firebaseAuth.currentUser
    }
    
    func getUserProperties() ->UserProperties? {
        return self.userProperties
    }
    
    func setUserSelectedCharacter(newCharacterID: String) {
        self.userProperties?.SelectedCharacter = newCharacterID
        self.saveUserPropertiesToServer()
    }
    
    private func getUserPropertiesFromServer() {
        let docRef = db.collection("users").document(self.getUser()!.uid)
        
        docRef.getDocument(completion: { (document, err) in
            if let document = document, document.exists {
                do {
                    self.userProperties = try JSONDecoder().decode(UserProperties.self, withJSONObject: document.data(), options: [])
                } catch {
                    print(error)
                }
            }
        })
    }
    
    private func saveUserPropertiesToServer() {
        do {
            self.db.collection("users").document(self.getUser()!.uid).updateData(try userProperties!.asDictionary())
        } catch {
            
        }
    }
    
}
