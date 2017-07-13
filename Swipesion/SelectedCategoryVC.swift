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
            
            categoryTitleLabel.text = title.category
        }
        
        newsOnCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        
//        self.news = []
//
//        session.invalidateAndCancel()
//        
//    }
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
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
                            
                            let latestNews = News()
                            
                            latestNews.author = retrievedObject["author"] as? String
                            latestNews.title  = retrievedObject["title"] as? String
                            latestNews.description = retrievedObject["description"] as? String
                            latestNews.url = retrievedObject["url"] as? String
                            latestNews.urlToImage = retrievedObject["urlToImage"] as? String
                            latestNews.publishedAt = retrievedObject["publishedAt"] as? String
                            
                            
                            self.news.append(latestNews)
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
            
        }
        
    }
    
}
