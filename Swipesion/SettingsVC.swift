//
//  SettingsVC.swift
//  Swipesion
//
//  Created by Hanafi Hisyam on 13/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
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
    
    
    @IBOutlet weak var imageView: CircleView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!{
        didSet{
            editProfileButton.addTarget(self, action: #selector(SettingsVC.didTappedEditButton), for: .touchUpInside)
        }
    }
    
    var getProfileImage : UIImage?
    var getUserName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = getProfileImage
        usernameLabel.text = getUserName
        
        
        if UserDefaults.standard.string(forKey: "currentUserFacebookID") != nil {
            editProfileButton.isHidden = true
        }
    }
    
    func didTappedCloseButton() {
    
        dismiss(animated: true, completion: nil)

    }
    
    func didTappedEditButton(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let userVC = mainStoryboard.instantiateViewController(withIdentifier: "UserVC") as! UserVC
        
        userVC.displayUserImage = imageView.image
        
        self.present(userVC, animated: true, completion: nil)
    }
    
    func didTapSignOutButton(_ sender: Any){
        let firebaseAuth = Auth.auth()
        let loginManager = FBSDKLoginManager() //FB system logout
        
        UserDefaults.standard.setValue(nil, forKey: "currentUID")
        UserDefaults.standard.setValue(nil, forKey: "currentUserName")
        UserDefaults.standard.set(nil, forKey: "currentUserProfileImage")
        UserDefaults.standard.synchronize()
        
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
