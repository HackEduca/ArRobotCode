//
//  MainViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 07/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Lottie

class MainViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var enterWorldText: UILabel!
    @IBOutlet var loginView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        GIDSignIn.sharedInstance().uiDelegate = self
        signInButton.center = self.view.center
        enterWorldText.center = self.view.center
        enterWorldText.center.y -= 80
        
        let animationView = LOTAnimationView(name: "rocket")
        self.loginView.insertSubview(animationView, at: 0)
        animationView.loopAnimation = true
        
        animationView.play{ (finished) in
            
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
