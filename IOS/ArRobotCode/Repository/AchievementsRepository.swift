//
//  AchievementsRepository.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 18/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import Foundation

import Foundation
import Firebase
import RxSwift

class AchievementsRepository {
    public static let shared = AchievementsRepository()
    public var achievementsObservable: Observable<[Achievement]> {
        get {
            return self.achievementSubject.asObservable()
        }
    }
    
    private let db: Firestore!
    private let achievementSubject = ReplaySubject<[Achievement]>.create(bufferSize: 1)
    
    // Make constructor private
    private init() {
        self.db = Firestore.firestore()
        self.getAchievementsFromServer()
    }
    
    func doInit() {
        
    }
    
    func getAchievement(byID: String) -> Observable<Achievement?> {
        return self.achievementSubject.map({ (achievements) -> Achievement? in
            for achievement in achievements {
                if achievement.ID == byID {
                    return achievement
                }
            }
            return nil
        })
        
    }
    
    private func getAchievementsFromServer() {
        let docRef = db.collection("achievements")
        
        docRef.getDocuments(completion: { (querySnapshot, err) in
            var achievements: [Achievement] = []
            for document in querySnapshot!.documents {
                do {
                    let achievement = try JSONDecoder().decode(Achievement.self, withJSONObject: document.data(), options: [])
                    achievement.ID = document.documentID
                    achievements.append(achievement)
                } catch {
                }
            }
            
            self.achievementSubject.onNext(achievements)
        })
    }
}
