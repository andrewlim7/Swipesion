//
//  SlideMenuVC.swift
//  Swipesion
//
//  Created by Hanafi Hisyam on 13/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
