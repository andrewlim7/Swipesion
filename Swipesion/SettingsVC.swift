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

protocol SettingVCDelegate {
    func passData()
}


class SettingsVC: UIViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem! {
        didSet{
            closeButton.target = self
            closeButton.action = #selector(didTappedCloseButton)
            closeButton.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)

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
    var delegate: SettingVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameLabel.text = UserDefaults.standard.string(forKey: "currentUserName")?.capitalized
        
        if let profileImage = UserDefaults.standard.url(forKey: "currentUserProfileImage") {
            imageView.sd_setImage(with: profileImage)
        }
        
        if let fbProfileID = UserDefaults.standard.string(forKey: "currentUserFacebookID") {
            
            if let fbProfileURL = NSURL(string: "https://graph.facebook.com/\(fbProfileID)/picture?type=large&return_ssl_resources=1") {
                self.imageView.sd_setImage(with: fbProfileURL as URL)
            }
        }
        
        if UserDefaults.standard.string(forKey: "currentUserFacebookID") != nil {
            editProfileButton.isHidden = true
        }
        
    }
    
    func didTappedCloseButton() {
    
        delegate?.passData()

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
