//
//  StatisticVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 28/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class StatisticVC: UIViewController {

    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var technologyLabel: UILabel!
    
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var scienceAndNatureLabel: UILabel!
    @IBOutlet weak var gamingLabel: UILabel!
    @IBOutlet weak var politicsLabel: UILabel!
    
    @IBOutlet weak var entertaimentLabel: UILabel!
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchCount(Category: "General")
        fetchCount(Category: "Sport")
        fetchCount(Category: "Music")
        fetchCount(Category: "Technology")
        fetchCount(Category: "Business")
        fetchCount(Category: "Science-And-Nature")
        fetchCount(Category: "Gaming")
        fetchCount(Category: "Politics")
        fetchCount(Category: "Entertaiment")
        
        setupSpinner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    func fetchCount(Category:String){
        myActivityIndicator.startAnimating()
        let ref = Database.database().reference()
        if let currentUserID = Auth.auth().currentUser?.uid{
            ref.child("users").child(currentUserID).child("category").child(Category).observe(.value, with: { (snapshot) in
                var count = 0
                count += Int(snapshot.childrenCount)
                if Category == "General"{
                    self.generalLabel.text = "Total \(Category):\(count)"
                    
                } else if Category == "Sport"{
                    self.sportLabel.text = "Total \(Category):\(count)"
                    
                } else if Category == "Music"{
                    self.musicLabel.text = "Total \(Category):\(count)"
                    
                } else if Category == "Technology"{
                    self.technologyLabel.text = "Total \(Category):\(count)"
                    
                } else if Category == "Business"{
                    self.businessLabel.text = "Total \(Category):\(count)"
                    
                } else if Category == "Science-And-Nature"{
                    self.scienceAndNatureLabel.text = "Total \(Category):\(count)"
                    
                } else if Category == "Gaming"{
                    self.gamingLabel.text = "Total \(Category):\(count)"
                    
                } else if Category == "Politics"{
                    self.politicsLabel.text = "Total \(Category):\(count)"
                    
                } else {
                    self.entertaimentLabel.text = "Total \(Category):\(count)"
                    
                }
                
                self.myActivityIndicator.stopAnimating()
            })
        }
    }
    
    func setupSpinner(){
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        view.addSubview(myActivityIndicator)
    }

}
