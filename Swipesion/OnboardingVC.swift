//
//  OnboardingVC.swift
//  Swipesion
//
//  Created by Mohd Adam on 25/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingVC: UIViewController {

    @IBOutlet weak var onBoardingView: OnboardingView! {
        
        didSet {
            
            onBoardingView.delegate = self
            onBoardingView.dataSource = self
        }
    }
    
    @IBOutlet weak var startedBtn: UIButton! {
        
        didSet {
            
            startedBtn.addTarget(self, action: #selector(startedBtnTapped(_:)), for: .touchUpInside)
            startedBtn.setTitle("Start", for: .normal)
            startedBtn.layer.borderWidth = 1
            startedBtn.layer.borderColor = UIColor.white.cgColor
            startedBtn.layer.cornerRadius = 5
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    func startedBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Auth", bundle: Bundle.main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        GeneralSettings.saveOnboardingFinished()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}

extension OnboardingVC: PaperOnboardingDataSource {
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        return[("Newspaper-icon", "Just Swipe", "A great news start with a swipe, change the way we read news, say goodbye to flip just swipe.", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descriptionFont),
               
               ("done rm5", "Left. Right. Down.", "Swipe left to skip. Swipe right to read now. Swipe down to read later.", "", backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descriptionFont),
               
               ("notification","Stay up to date!", "We won't let you miss the latest and hottest news! Press 'Start' to login.", "", backgroundColorThree, UIColor.white, UIColor.white, titleFont, descriptionFont)][index]
    }
    
    func onboardingItemsCount() -> Int {
        
        return 3
    }
}

extension OnboardingVC: PaperOnboardingDelegate {
    
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        
        if index == 1 {
            
            if self.startedBtn.alpha == 1 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.startedBtn.alpha = 0
                    
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
        if index == 2 {
            
            UIView.animate(withDuration: 0.4, animations: {
                
                self.startedBtn.alpha = 1
            })
        }
        
    }
    
    
}
