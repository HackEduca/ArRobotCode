//
//  RobotHexa.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 23/10/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import Alamofire

class RobotHexa: RobotInterface {
    let host = "http://192.168.43.24:8000"
    
    func moveFront(distanceInMM distance: Int) {
        let url = URL(string: host + "/moveFront?dist=" + String(distance))!
        
        Alamofire.request(url).responseJSON(completionHandler: { (data) in
            print(data)
        })
    }
    
    func moveBack(distanceInMM distance: Int) {
        let url = URL(string: host + "/moveBack?dist=" + String(distance))!

        Alamofire.request(url).responseJSON(completionHandler: { (data) in
            print(data)
        })
    }
    
    func turnLeft() {
        let url = URL(string: host + "/rotateLeft")!
        
        Alamofire.request(url).responseJSON(completionHandler: { (data) in
            print(data)
        })
    }
    
    func turnRight() {
        let url = URL(string: host + "/rotateRight")!
        
        Alamofire.request(url).responseJSON(completionHandler: { (data) in
            print(data)
        })
    }

}
