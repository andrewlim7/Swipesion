//
//  SelectedNewsVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 13/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices
import FirebaseAuth
import FirebaseDatabase
import Social

class SelectedNewsVC: UIViewController {
    

    @IBOutlet weak var twitterBtn: UIButton! {
        
        didSet {
            
            twitterBtn.addTarget(self, action: #selector(twitterBtnTapped(_:)), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var facebookBtn: UIButton! {
        
        didSet {
            
            facebookBtn.addTarget(self, action: #selector(facebookBtnTapped(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var urlBtn: UIButton! {
        
        didSet {
            
            urlBtn.addTarget(self, action: #selector(urlBtnTapped(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveLinkButton: UIButton!{
        didSet{
            saveLinkButton.addTarget(self, action: #selector(saveLinkButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    var getNews : News?
    var getIsNewsSaved : Bool?
    
    let currentUserID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = getNews?.title
        self.dateLabel.text = getNews?.publishedAt
        self.authorLabel.text = getNews?.author
        self.descriptionLabel.text = getNews?.description
        
        if let url = getNews?.urlToImage {
            
            let displayURL = URL(string:url)
            
            imageView.sd_setImage(with: displayURL)
        }
        
        if getIsNewsSaved == true{
            saveLinkButton.isHidden = true
        }
        
        saveLinkButton.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
    
    func twitterBtnTapped(_ sender: Any) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            if let url = getNews?.url {
                
                if let newUrl = URL(string: url) {
                    
                    tweetShare.add(newUrl)
                }
            }
            
            tweetShare.add(imageView.image)
            tweetShare.setInitialText((getNews?.title)! + " by SwipeSion")
            
            self.present(tweetShare, animated: true, completion: nil)
            
            let alert = UIAlertController(title: "Done", message: "Posted to Twitter", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func facebookBtnTapped(_ sender: Any) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            
            if let url = getNews?.url {
                
                if let newUrl = URL(string: url) {
                    
                    fbShare.add(newUrl)
                }
            }
            
            fbShare.add(imageView.image)
            fbShare.setInitialText((getNews?.title)! + " by SwipeSion")
            
            self.present(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func saveLinkButtonTapped(_ sender: Any){
        saveLinkButton.isEnabled = false
        if currentUserID != nil {
            let databaseRef = Database.database().reference()
            
            guard
                let uid = Auth.auth().currentUser?.uid,
                let saveNews = getNews
                else { return }
            
            let now = Date()
            let param : [String: Any] = ["userID": uid,
                                         "title": saveNews.title ?? "",
                                         "description": saveNews.description ?? "",
                                         "author": saveNews.author ?? "",
                                         "url": saveNews.url ?? "",
                                         "urlToImage": saveNews.urlToImage ?? "",
                                         "publishAt":saveNews.publishedAt ?? "",
                                         "timestamp": now.timeIntervalSince1970]
            
            let getRef = databaseRef.child("savedLinks").childByAutoId()
            getRef.setValue(param)
            
            let currentSID = getRef.key
            
            let updateUserSID = databaseRef.child("users").child(uid).child("links")
            updateUserSID.updateChildValues([currentSID:true])
            
            let alertController = UIAlertController(title: "Saved!", message: "Please check it in your saved links.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(ok)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func urlBtnTapped(_ sender: Any) {
        
        if let urlString = getNews?.url {
            let url = URL(string: urlString)!
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
            controller.delegate = self
        }
    }
    
}

extension SelectedNewsVC: SFSafariViewControllerDelegate {
    
    
}
