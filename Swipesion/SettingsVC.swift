//
//  SettingsVC.swift
//  Swipesion
//
//  Created by Hanafi Hisyam on 13/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit


class SettingsVC: UIViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem! {
        didSet{
            closeButton.target = self
            closeButton.action = #selector(didTappedCloseButton)
        }
    }
    
    @IBOutlet weak var signOutButton: UIButton!{
        didSet{
            signOutButton.addTarget(self, action: #selector(didTapSignOutButton(_:)), for: .touchUpInside)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func didTappedCloseButton() {
    
        dismiss(animated: true, completion: nil)

    }
    
    func didTapSignOutButton(_ sender: Any){
        let firebaseAuth = Auth.auth()
        let loginManager = FBSDKLoginManager() //FB system logout
        
        do {
            try firebaseAuth.signOut()
            loginManager.logOut()
            
            print ("Logged out successfully!")
            
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
            return
        }
    }


   
}
