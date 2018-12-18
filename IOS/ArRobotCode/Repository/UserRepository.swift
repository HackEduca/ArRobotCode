//
//  UserRepository.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 12/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
class UserRepository {
    public static let shared = UserRepository()
    public var userPropertiesObservable: Observable<UserProperties> {
         get {
             return self.userPropertiesSubject.asObservable()
         }
    }
    
    private let firebaseAuth: Auth!
    private let db: Firestore!
    
    private var userProperties: UserProperties?
    private let userPropertiesSubject = ReplaySubject<UserProperties>.create(bufferSize: 1)
    
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
    
    func addCompletedLevel(levelID: String) {
        // To check, if userProperties is null !!!
        
        var found = false
        if let userProperties = self.userProperties {
            for levelCompleted in userProperties.CompletedLevels {
                if levelCompleted == levelID {
                    found = true
                    break
                }
            }
            
            if found == false {
                self.userProperties?.CompletedLevels.append(levelID)
                self.saveUserPropertiesToServer()
            }
        }
    }
    
    private func getUserPropertiesFromServer() {
        if let user = self.getUser() {
            let docRef = db.collection("users").document(user.uid)
            
            docRef.getDocument(completion: { (document, err) in
                if let document = document, document.exists {
                    do {
                        self.userProperties = try JSONDecoder().decode(UserProperties.self, withJSONObject: document.data(), options: [])
                        self.userPropertiesSubject.onNext(self.userProperties!)
                    } catch {
                        print(error)
                    }
                }
            })
        }
        
    }
    
    private func saveUserPropertiesToServer() {
        do {
            self.db.collection("users").document(self.getUser()!.uid).updateData(try userProperties!.asDictionary())
            self.getUserPropertiesFromServer()
        } catch {
            
        }
    }
    
}
