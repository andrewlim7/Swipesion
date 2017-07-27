//
//  MainVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 11/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FBSDKLoginKit
import MARoundButton


class MainVC: UIViewController, SWRevealViewControllerDelegate {
    
    var interest: [News] = []
    var filteredCategory: [News] = []
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var direction: UICollectionViewScrollDirection = .horizontal
    var categoryTitle:[String] = ["General", "Sport", "Music", "Technology", "Business", "Science and Nature", "Gaming", "Politics", "Entertainment"]
    var categoryDesc:[String] = ["Find out your latest and hottest general with us, just start with a swipe.",
                                 "Find out your latest and hottest sport with us, just start with a swipe.",
                                 "Find out your latest and hottest music with us, just start with a swipe.",
                                 "Find out your latest and hottest technology with us, just start with a swipe.",
                                 "Find out your latest and hottest business with us, just start with a swipe.",
                                 "Find out your latest and hottest science and nature with us, just start with a swipe.",
                                 "Find out your latest and hottest gaming with us, just start with a swipe.",
                                 "Find out your latest and hottest politics with us, just start with a swipe.",
                                 "Find out your latest and hottest entertainment with us, just start with a swipe."]
    var mainMenuLogo:[UIImage] = [UIImage(named: "mainMenuNews")!,
                                  UIImage(named: "mainMenuSport")!,
                                  UIImage(named: "mainMenuMusic")!,
                                  UIImage(named: "mainMenuTech")!,
                                  UIImage(named: "mainMenuBusiness")!,
                                  UIImage(named: "mainMenuScience")!,
                                  UIImage(named: "mainMenuGaming")!,
                                  UIImage(named: "mainMenuPolitics")!,
                                  UIImage(named: "mainMenuEntertainment")!]
    
    
    var randomColor = [UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1),
                       UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1),
                       UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)]
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var mainCollectionViewCell: UICollectionView! {
        
        didSet {
            
            mainCollectionViewCell.delegate = self
            mainCollectionViewCell.dataSource = self
        
            mainCollectionViewCell.layer.borderWidth = CGFloat(1.0)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewsID()
        showMenu()
        tapGesture()
        
        
        let newLayout = AnimatedCollectionViewLayout()
        newLayout.animator = LinearCardAttributesAnimator()
        newLayout.scrollDirection = direction
        mainCollectionViewCell.collectionViewLayout = newLayout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func getCategory(category: String) {
        
        for getCate in interest {
            
            if getCate.category == category {
                
                filteredCategory.append(getCate)
            }
            
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectedCategoryVC") as? SelectedCategoryVC
        
        vc?.getNewsID = filteredCategory
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getNewsID() {
        
        let urlSession = URLSession(configuration: .default)
        
        let url = URL(string: "https://newsapi.org/v1/sources?language=en&apiKey=22f2516b0fc845818b266905e56cf205")
        
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = "GET"
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            
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
                        
                        guard let getCategory = json?["sources"] as? [[String:Any]] else { return }
                        
                        
                        
                        for retrievedObject in getCategory {
                            
                            if let latestNews = News(dictionary: retrievedObject) {
                                
                                latestNews.nid = retrievedObject["id"] as? String
                                latestNews.sourceName = retrievedObject["name"] as? String
                                latestNews.category = retrievedObject["category"] as? String
                                
                                self.interest.append(latestNews)
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
    
    func showMenu() {
        
        if revealViewController() != nil {
            
            menuBtn.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            //menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
            
        }
        
    }
    
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        let tagId = 4207868622
        
        if revealController.frontViewPosition == FrontViewPosition.right {
            let lock = self.view.viewWithTag(tagId)
            UIView.animate(withDuration: 0.25, animations: {
                lock?.alpha = 0
            }, completion: {(finished: Bool) in
                lock?.removeFromSuperview()
            }
            )
            lock?.removeFromSuperview()
        } else if revealController.frontViewPosition == FrontViewPosition.left {
            let lock = UIView(frame: self.view.bounds)
            lock.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            lock.tag = tagId
            lock.alpha = 0
            lock.backgroundColor = UIColor.black
            lock.addGestureRecognizer(UITapGestureRecognizer(target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            self.view.addSubview(lock)
            UIView.animate(withDuration: 0.75, animations: {
                lock.alpha = 0.333
            }
            )
        }
    }
    
    func tapGesture() {
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
    }
    
}

extension MainVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == 0 {
            
            getCategory(category: "general")
            self.filteredCategory = []
            
        } else if indexPath.item == 1{
            
            getCategory(category: "sport")
            self.filteredCategory = []
            
        } else if indexPath.item == 2{
            
            getCategory(category: "music")
            self.filteredCategory = []
            
        } else if indexPath.item == 3{
            
            getCategory(category: "technology")
            self.filteredCategory = []
            
        } else if indexPath.item == 4{
            
            getCategory(category: "business")
            self.filteredCategory = []
            
        } else if indexPath.item == 5{
            
            getCategory(category: "science-and-nature")
            self.filteredCategory = []
            
        }  else if indexPath.item == 6{
            
            getCategory(category: "gaming")
            self.filteredCategory = []
            
        } else if indexPath.item == 7{
            
            getCategory(category: "politics")
            self.filteredCategory = []
            
        } else {
            
            getCategory(category: "entertainment")
            self.filteredCategory = []
        }
        
    }
    
}

extension MainVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCell
        
        cell.titleLabel.text = categoryTitle[indexPath.item]
        cell.descriptionLabel.text = categoryDesc[indexPath.item]
        cell.mainMenuLogoView.image = mainMenuLogo[indexPath.item]

        cell.backgroundColor = self.randomColor[indexPath.item % self.randomColor.count]
        
        return cell
    }
    
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let animator = animator else { return view.bounds.size }
        return CGSize(width: view.bounds.width / CGFloat(animator.2), height: view.bounds.height / CGFloat(animator.3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}







