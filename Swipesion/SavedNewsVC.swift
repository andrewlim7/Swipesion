//
//  SavedNewsVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 11/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit

class SavedNewsVC: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var savedLinks : News?
    var storeSavedLinks : [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        storeSavedLinks.append(savedLinks!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

}

extension SavedNewsVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeSavedLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : SavedNewsCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SavedNewsCell else { return UITableViewCell() }
        
        
        
        for storeSavedLink in storeSavedLinks {
            
            cell.titleLabel.text = storeSavedLink.title
            cell.dateLabel.text = storeSavedLink.publishedAt
            
            if let url = storeSavedLink.urlToImage {
                let imageURL = URL(string: url)
                cell.cellImageView.sd_setImage(with: imageURL)
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
