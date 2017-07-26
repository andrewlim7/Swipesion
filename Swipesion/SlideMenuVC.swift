//
//  SlideMenuVC.swift
//  Swipesion
//
//  Created by Hanafi Hisyam on 13/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class SlideMenuVC: UIViewController, SettingVCDelegate {
    
    @IBOutlet weak var savedNewsButton: UIButton!{
        didSet{
            savedNewsButton.addTarget(self, action: #selector(didTappedSavedNewsButton(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var settingsButton: UIButton! {
        didSet{
            settingsButton.addTarget(self, action: #selector(didTappedSettingsButton(_ :)), for: .touchUpInside)
            
        }
    }
    
    @IBOutlet weak var imageView: CircleView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    let currentUserID = UserDefaults.standard.string(forKey: "currentUID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        usernameLabel.text = UserDefaults.standard.string(forKey: "currentUserName")
//        
//        if let profileImage = UserDefaults.standard.url(forKey: "currentUserProfileImage") {
//            imageView.sd_setImage(with: profileImage)
//        }
//        
//        if let fbProfileID = UserDefaults.standard.string(forKey: "currentUserFacebookID") {
//            
//            if let fbProfileURL = NSURL(string: "https://graph.facebook.com/\(fbProfileID)/picture?type=large&return_ssl_resources=1") {
//                self.imageView.sd_setImage(with: fbProfileURL as URL)
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameLabel.text = UserDefaults.standard.string(forKey: "currentUserName")
        
        if let profileImage = UserDefaults.standard.url(forKey: "currentUserProfileImage") {
            imageView.sd_setImage(with: profileImage)
        }
        
        if let fbProfileID = UserDefaults.standard.string(forKey: "currentUserFacebookID") {
            
            if let fbProfileURL = NSURL(string: "https://graph.facebook.com/\(fbProfileID)/picture?type=large&return_ssl_resources=1") {
                self.imageView.sd_setImage(with: fbProfileURL as URL)
            }
        }
    }
    
    func didTappedSavedNewsButton(_ sender : Any){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SavedNewsVC") as? SavedNewsVC
        // let navController = UINavigationController()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func didTappedSettingsButton(_ sender: Any) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let settingsVC = mainStoryboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        settingsVC.delegate = self
        
        self.present(settingsVC, animated: true, completion: nil)
    }
    
    func passData() {
        dismiss(animated: true, completion: nil)
    }
}
