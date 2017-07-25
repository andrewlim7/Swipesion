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
        
        return[("rocket","A great rocket start!", "Ice cream gummi bears marshmallow oat cake marshmallow pastry. Liquorice fruitcake jujubes cupcake. Carrot cake brownie toffee.", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descriptionFont),
               
               ("brush","A great brush morning start!", "Ice cream gummi bears marshmallow oat cake marshmallow pastry. Liquorice fruitcake jujubes cupcake. Carrot cake brownie toffee.", "", backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descriptionFont),
               
               ("notification","Stay up to date!", "Ice cream gummi bears marshmallow oat cake marshmallow pastry. Liquorice fruitcake jujubes cupcake. Carrot cake brownie toffee.", "", backgroundColorThree, UIColor.white, UIColor.white, titleFont, descriptionFont)][index]
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
