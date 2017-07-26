//
//  SelectedCategoryVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 11/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import Koloda
import pop
import SDWebImage
import FirebaseAuth
import FirebaseDatabase

class SelectedCategoryVC: UIViewController {

    var news : [News] = []
    var getNewsID: [News] = []
    var session: URLSession = URLSession(configuration: .default)
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!{
        didSet{
            backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var saveLinkButton: UIButton!{
        didSet{
            saveLinkButton.addTarget(self, action: #selector(saveLinkButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    let frameAnimationSpringBounciness: CGFloat = 9
    let frameAnimationSpringSpeed: CGFloat = 16
    let kolodaCountOfVisibleCards = 2
    let kolodaAlphaValueSemiTransparent: CGFloat = 0.1
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        for title in getNewsID {
            
            categoryTitleLabel.text = title.category?.capitalized
        }
        
        newsOnCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    func saveLinkButtonTapped(_ sender: Any){
        kolodaView?.swipe(.down)
    }

    func backButtonTapped(_ sender: Any){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func newsOnCategory() {
        
        for getID in getNewsID {
            
            //if getID.category == "general" {
            
            if let sourceID = getID.nid {
                
                if let filteredCater = getID.category {
                    
                    getNews(from: sourceID, sorted: filteredCater)
                }
                
                //}
            }
        }
    }
    
    func getNews(from source: String, sorted cate: String) {
        
        session = URLSession(configuration: .default)
        
        let url = URL(string: "https://newsapi.org/v1/articles?source=\(source)&category=\(cate)&apiKey=22f2516b0fc845818b266905e56cf205")
        
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "GET"
        
        session.dataTask(with: urlRequest) { (data, response, error) in
            
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
                        
                        guard let getArticles = json?["articles"] as? [[String:Any]] else { return }
                        
                        for retrievedObject in getArticles {
                            if let latestNews = News(dictionary: retrievedObject) {
                                self.news.append(latestNews)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.kolodaView.reloadData()
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
    
    
}

extension SelectedCategoryVC: KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .down]
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
        print("tapped")
        
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
}

extension SelectedCategoryVC: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        
        return .default
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        
        return news.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        
        let customImageCard = CustomImageView(frame: koloda.frame)
        
        let currentIndex = self.news[index]
        
        customImageCard.sd_setShowActivityIndicatorView(true)
        customImageCard.sd_setIndicatorStyle(.whiteLarge)
        
        if let url = currentIndex.urlToImage {
            
            let displayURL = URL(string:url)
            
            customImageCard.customImageView.sd_setImage(with: displayURL)
            
        }
        
        customImageCard.customLabelText.text = currentIndex.title
        
        return customImageCard
        
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        if direction == SwipeResultDirection.right {
            
            let sendNews = self.news[index]
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "SelectedNewsVC") as! SelectedNewsVC
            
            vc.getNews = sendNews
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if direction == SwipeResultDirection.down {
        
            let databaseRef = Database.database().reference()
            
            guard
                let uid = Auth.auth().currentUser?.uid
                else { return }
            
            let sendNews = self.news[index]
            let now = Date()
            let param : [String: Any] = ["userID": uid,
                                         "title": sendNews.title ?? "",
                                         "description": sendNews.description ?? "",
                                         "author": sendNews.author ?? "",
                                         "url": sendNews.url ?? "",
                                         "urlToImage": sendNews.urlToImage ?? "",
                                         "publishAt":sendNews.publishedAt ?? "",
                                         "timestamp": now.timeIntervalSince1970]
            
            let getRef = databaseRef.child("savedLinks").childByAutoId()
            getRef.setValue(param)

            let currentSID = getRef.key
            
            let updateUserSID = databaseRef.child("users").child(uid).child("links")
            updateUserSID.updateChildValues([currentSID:true])
        }
        
    }
    
}
