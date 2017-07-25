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


class SlideMenuVC: UIViewController {
    
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
        
        usernameLabel.text = UserDefaults.standard.string(forKey: "currentUserName")
        imageView.sd_setImage(with: UserDefaults.standard.url(forKey: "currentUserProfileImage"))
    }
    
    func didTappedSavedNewsButton(_ sender : Any){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SavedNewsVC") as? SavedNewsVC
       // let navController = UINavigationController()
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }

    func didTappedSettingsButton(_ sender: Any) {
    
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let settingsVC = mainStoryboard.instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC
        self.present(settingsVC!, animated: true, completion: nil)
        
    
    }
}
