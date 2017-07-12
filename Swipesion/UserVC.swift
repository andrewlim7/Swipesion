//
//  UserVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 11/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class UserVC: UIViewController {
    
    @IBOutlet weak var changeProfileImage: UIImageView!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var uploadImageButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
