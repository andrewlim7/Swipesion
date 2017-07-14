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

class SelectedNewsVC: UIViewController {
    

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
    
    var getNews: News?
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
        
    }
    
    func saveLinkButtonTapped(_ sender: Any){
        
        if currentUserID != nil {
            if let userID = currentUserID {
                let ref = Database.database().reference()
                //ref.child("users").child(userID).child("savedLinks").updateChildValues([: true])
                
            }
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
}

extension SelectedNewsVC: SFSafariViewControllerDelegate {
    
    
}
