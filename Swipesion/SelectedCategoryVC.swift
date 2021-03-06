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
    
    var firstLoad = true
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
            saveLinkButton.isHidden = true
        }
    }
    @IBOutlet weak var rightButton: UIButton!{
        didSet{
            rightButton.addTarget(self, action: #selector(rightButtonTapped(_:)), for: .touchUpInside)
            rightButton.isHidden = true
        }
    }
    @IBOutlet weak var leftButton: UIButton!{
        didSet{
            leftButton.addTarget(self, action: #selector(leftButtonTapped(_:)), for: .touchUpInside)
            leftButton.isHidden = true
        }
    }
    
    let frameAnimationSpringBounciness: CGFloat = 9
    let frameAnimationSpringSpeed: CGFloat = 16
    let kolodaCountOfVisibleCards = 2
    let kolodaAlphaValueSemiTransparent: CGFloat = 0.1
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var storeCategory : String?
    
    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        //        for title in getNewsID {
        //
        //            categoryTitleLabel.text = title.category?.capitalized
        //        }
        
        if getNewsID.count == 0  {
            categoryTitleLabel.text = "Loading"
        } else {
            categoryTitleLabel.text = getNewsID[0].category?.capitalized
            storeCategory = categoryTitleLabel.text
        }
        
        newsOnCategory()
        setupSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }

    func leftButtonTapped(_ sender: Any){
        kolodaView?.swipe(.left)
    }
    
    func rightButtonTapped(_ sender: Any){
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
            
            if let sourceID = getID.nid {
                
                if let filteredCater = getID.category {
                    
                    getNews(from: sourceID, sorted: filteredCater)
                }
            }
        }
    }
    
    func getNews(from source: String, sorted cate: String) {
        myActivityIndicator.startAnimating()
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
                        
                        guard
                            let getSourceName = json?["source"] as? String,
                            let getArticles = json?["articles"] as? [[String:Any]] else { return }
                        
                        for retrievedObject in getArticles {
                            if let latestNews = News(dictionary: retrievedObject, source:getSourceName) {
                                DispatchQueue.main.async {
                                    self.news.append(latestNews)
                                }
                            }
                        }
                        
                        if self.firstLoad { // == true
                            self.firstLoad = false // set it to false so it wont load 3 times from user interfaces but backend it loaded all the sources.
                            DispatchQueue.main.async {
                                self.kolodaView.reloadData()
                                
                            }
                            
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
    
    func setupSpinner(){
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        view.addSubview(myActivityIndicator)
    }
}

extension SelectedCategoryVC: KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] {
        return [.left, .right, .down]
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        if koloda.currentCardIndex == news.count { //the flow of this logic: if currentCard[30] == total news[30]
            kolodaView.resetCurrentCardIndex() //reset it back to the news[0]
        }else { //else
            koloda.reloadData() //if currentCard[9] == total news[30], means it will load news[10] until news[30] == news[30] then will reset it to news[0]
        }
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
        print("tapped")
        
    }
    
    func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
        self.myActivityIndicator.stopAnimating()
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        self.myActivityIndicator.stopAnimating()
        saveLinkButton.isHidden = false
        leftButton.isHidden = false
        rightButton.isHidden = false
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
            
            
            let ref = Database.database().reference()
            if let userID = Auth.auth().currentUser?.uid{
                if let category = storeCategory{
                    let getCateRef = ref.child("users").child(userID).child("category").child(category).childByAutoId()
                    getCateRef.setValue(true)
                }
            }
            
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
                                         "sourceName": sendNews.sourceName ?? "",
                                         "timestamp": now.timeIntervalSince1970]
            
            let getRef = databaseRef.child("savedLinks").childByAutoId()
            getRef.setValue(param)
            
            let currentSID = getRef.key
            
            let updateUserSID = databaseRef.child("users").child(uid).child("links")
            updateUserSID.updateChildValues([currentSID:true])
        }
        
    }
    
    
}
