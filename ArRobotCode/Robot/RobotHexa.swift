//
//  RobotHexa.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 23/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit

class RobotHexa: RobotInterface {
    let host = "http://192.168.43.24"
    let port = 8000
    
    func moveFront(distanceInMM distance: Int) {
        let url = URL(string: host + ":8000/moveFront?distance=" + String(distance))!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                print("Error when making the request: " + error!.localizedDescription)
                return
                
            }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func moveBack(distanceInMM distance: Int) {
        print("moveBackwards called")
    }
    
    func moveLeft(distanceInMM distance: Int) {
        print("moveLeft called")
    }
    
    func moveRight(distanceInMM distance: Int) {
        print("moveRight called")
    
    }

}
