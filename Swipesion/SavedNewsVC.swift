//
//  SavedNewsVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 11/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class SavedNewsVC: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var storeSavedLinks : [Data] = []
    
    let currentUserID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedLinks()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func fetchSavedLinks(){
        
        if currentUserID != nil {
            
            if let user = currentUserID {
                
                ref.child("users").child(user).child("links").observe(.value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String:Any] else {return}
                    
                    self.storeSavedLinks = []
                    
                    for (key, _) in dictionary {
                        self.getSavedLinks(key)
                    }
                })
            }
        }
        
        
    }
    
    func getSavedLinks(_ linkID : String){
        
        ref.child("savedLinks").child(linkID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = Data(snapshot: snapshot){

                self.storeSavedLinks.append(data)
                //self.storeSavedLinks.sort(by: {$0.publishedAt > $1.publishedAt})
                self.tableView.reloadData()
            }
            
        })
    }
    

}

extension SavedNewsVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeSavedLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : SavedNewsCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SavedNewsCell else { return UITableViewCell() }
        
        let currentRow = storeSavedLinks[indexPath.row]

        cell.titleLabel.text = currentRow.title
        cell.dateLabel.text = currentRow.publishedAt
        
        if let url = currentRow.urlToImage {  
            let imageURL = URL(string: url)
            cell.cellImageView.sd_setImage(with: imageURL)
        }
        
        DispatchQueue.main.async {
            tableView.reloadData()
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
