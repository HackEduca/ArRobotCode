//
//  MainViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 11/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import RxSwift
import RxGesture

class MainViewController: UIViewController {
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var myCharactersButton: UIButton!
    @IBOutlet weak var myLevelsButton: UIButton!
    @IBOutlet weak var userCharacterImage: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUserLabel()
        self.updateUserCharacterImage()
    }
    
    func setUserLabel() {
        if UserRepository.shared.getUser() != nil {
            self.userLabel.text = "Hi, " + (UserRepository.shared.getUser()?.displayName)!
        }
    }
    
    func updateUserCharacterImage() {
    
        Observable.combineLatest(CharacterRepository.shared.charactersObservable,
                                UserRepository.shared.userPropertiesObservable,
                                resultSelector: { value1, value2 in
        }).subscribe({ ev in
            let characterID = UserRepository.shared.getUserProperties()?.SelectedCharacter
            let characterPicture = CharacterRepository.shared.getCharacter(byID: characterID!)?.Picture
            self.userCharacterImage.image = UIImage(named: characterPicture!)
        }).disposed(by: self.disposeBag)
       
    }
}
