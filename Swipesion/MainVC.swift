//
//  MainVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 11/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import MARoundButton


class MainVC: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!{
        didSet{
            signOutButton.addTarget(self, action: #selector(didTapSignOutButton(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var button1: MARoundButton!{
        didSet{
            button1.corner = 30
            button1.borderColor = UIColor.black
            button1.border = 2
        }
    }
    @IBOutlet weak var button2: MARoundButton!{
        didSet{
            button2.corner = 30
            button2.borderColor = UIColor.black
            button2.border = 2
        }
    }
    @IBOutlet weak var button3: MARoundButton!{
        didSet{
            button3.corner = 30
            button3.borderColor = UIColor.black
            button3.border = 2
        }
    }
    @IBOutlet weak var button4: MARoundButton!{
        didSet{
            button4.corner = 30
            button4.borderColor = UIColor.black
            button4.border = 2
        }
    }
    @IBOutlet weak var button5: MARoundButton!{
        didSet{
            button5.corner = 30
            button5.borderColor = UIColor.black
            button5.border = 2
        }
    }
    @IBOutlet weak var button6: MARoundButton!{
        didSet{
            button6.corner = 30
            button6.borderColor = UIColor.black
            button6.border = 2
        }
    }
    @IBOutlet weak var button7: MARoundButton!{
        didSet{
            button7.corner = 30
            button7.borderColor = UIColor.black
            button7.border = 2
        }
    }
    @IBOutlet weak var button8: MARoundButton!{
        didSet{
            button8.corner = 30
            button8.borderColor = UIColor.black
            button8.border = 2
        }
    }
    @IBOutlet weak var button9: MARoundButton!{
        didSet{
            button9.corner = 30
            button9.borderColor = UIColor.black
            button9.border = 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
