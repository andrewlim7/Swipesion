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

class SavedNewsVC: UIViewController, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    var storeSavedLinks : [News] = []
    var filteredLinks : [News] = []
    var isNewsSaved : Bool = false
    let currentUserID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSavedLinks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
    }
    
  
    
    
    
    func fetchSavedLinks(){
        
        if currentUserID != nil {
            
            if let user = currentUserID {
                
                ref.child("users").child(user).child("links").observeSingleEvent(of: .value, with: { (snapshot) in
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
            if let data = News(snapshot: snapshot) {
                
                self.storeSavedLinks.append(data)
                self.storeSavedLinks.sort(by: {$0.timestamp > $1.timestamp})
                self.filteredLinks = self.storeSavedLinks
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredLinks = searchText.isEmpty ? storeSavedLinks : storeSavedLinks.filter{ (item: News) -> Bool in
            return item.title?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
    }
    
}

extension SavedNewsVC : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : SavedNewsCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SavedNewsCell else { return UITableViewCell() }
        
        let currentRow = filteredLinks[indexPath.row]
        
        cell.titleLabel.text = currentRow.title
        cell.sourcesLabel.text = "Author: \(currentRow.author ?? "N/A")"
        
        cell.cellImageView.sd_setShowActivityIndicatorView(true)
        cell.cellImageView.sd_setIndicatorStyle(.whiteLarge)
        
        if let url = currentRow.urlToImage {
            let imageURL = URL(string: url)
            cell.cellImageView.sd_setImage(with: imageURL)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentRow = filteredLinks[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectedNewsVC") as! SelectedNewsVC
        
        isNewsSaved = true
        
        vc.getNews = currentRow
        vc.getIsNewsSaved = isNewsSaved
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let currentRow = self.filteredLinks[indexPath.row]
            
            self.filteredLinks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
            let databaseRef = Database.database().reference()
            
            guard
                let uid = Auth.auth().currentUser?.uid,
                let linkID = currentRow.linkID
                else { return }
            
            
            let getRef = databaseRef.child("savedLinks").child(linkID)
            getRef.removeValue()
            
            let updateUserSID = databaseRef.child("users").child(uid).child("links").child(linkID)
            updateUserSID.removeValue()
            
            //            self.tableView.reloadData()
            
        }
    }
}
