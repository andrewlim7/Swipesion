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
    
    var interest: [News] = []
    var filteredCategory: [News] = []

    @IBOutlet weak var menuBtn: UIBarButtonItem! 

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
            button1.isEnabled = false
            button1.addTarget(self, action: #selector(button1Tapped(_:)), for: .touchUpInside)
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
        getNewsID()
        showMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func button1Tapped(_ sender: Any){
        
        getCategory(category: "general")

    }
    
    func getCategory(category: String) {
        
        for getCate in interest {
            
            if getCate.category == category {
                
                filteredCategory.append(getCate)
            }
            
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectedCategoryVC") as? SelectedCategoryVC
        
        vc?.getNewsID = filteredCategory
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getNewsID() {
        
        let urlSession = URLSession(configuration: .default)
        
        let url = URL(string: "https://newsapi.org/v1/sources?&apiKey=22f2516b0fc845818b266905e56cf205")
        
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "GET"
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            
            if let valideError = error {
                
                print(valideError.localizedDescription)
                
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            switch httpResponse.statusCode {
                
            case 200...299:
                
                if let validData = data {
                    
                    do {
                        
                        let json: [String:Any]? = try JSONSerialization.jsonObject(with: validData, options: .allowFragments) as? [String:Any]
                        
                        guard let getCategory = json?["sources"] as? [[String:Any]] else { return }
                        
                        for retrievedObject in getCategory {
                            
                            let latestNews = News()
                            
                            latestNews.nid = retrievedObject["id"] as? String
                            latestNews.category = retrievedObject["category"] as? String
                            
                            self.interest.append(latestNews)
                        }
                        
                        DispatchQueue.main.async {
                            self.button1.isEnabled = true
                        }
                        return
                    }
                    catch {
                        
                        return
                    }
                }
                
            case 400...599:
                return
            default:
                return
            }
            
            }.resume()
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
    
    func showMenu() {
        
        if revealViewController() != nil {
            
            menuBtn.target = revealViewController()
            menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
            
        }
    }
    
}
