//
//  SelectedNewsVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 13/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import SDWebImage

class SelectedNewsVC: UIViewController {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!
    
    var getNews: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = getNews?.title
        self.dateLabel.text = getNews?.publishedAt
        self.authorLabel.text = getNews?.author
        self.linkLabel.text = getNews?.url
        self.descriptionLabel.text = getNews?.description
        
        if let url = getNews?.urlToImage {
            
            let displayURL = URL(string:url)
            
            imageView.sd_setImage(with: displayURL)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
