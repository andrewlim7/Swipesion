//
//  StatisticVC.swift
//  Swipesion
//
//  Created by Andrew Lim on 28/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CSPieChart

class StatisticVC: UIViewController {

    @IBOutlet weak var pieView: CSPieChart!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var dataList: [CSPieChartData] = []
    
    var colorList: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCount(Category: "General")
        fetchCount(Category: "Sport")
        fetchCount(Category: "Music")
        fetchCount(Category: "Technology")
        fetchCount(Category: "Business")
        fetchCount(Category: "Science-And-Nature")
        fetchCount(Category: "Gaming")
        fetchCount(Category: "Politics")
        fetchCount(Category: "Entertainment")
        
//        if dataList.count == 0 {
//            dataList = [CSPieChartData(key: "General", value: 1)]
//            
//            colorList = [.white]
//        }
        
        
        pieView?.dataSource = self
        pieView?.delegate = self
        
        pieView?.pieChartRadiusRate = 0.9
        pieView?.pieChartLineLength = 20
        pieView?.seletingAnimationType = .touch
        
        pieView?.show(animated: true)

        setupSpinner()
    }
    
    
    
    fileprivate var touchDistance: CGFloat = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: view) else {
            return
        }
        
        touchDistance = location.x
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: view) else {
            return
        }
        
        touchDistance -= location.x
        
        if touchDistance > 100 {
            print("Right")
        } else if touchDistance < -100 {
            print("Left")
        }
        
        touchDistance = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 255/255, green: 88/255, blue: 85/255, alpha: 1)]
        
    }

    
    func fetchCount(Category:String) {
        
        myActivityIndicator.startAnimating()
        let ref = Database.database().reference()
        if let currentUserID = Auth.auth().currentUser?.uid{
            ref.child("users").child(currentUserID).child("category").child(Category).observe(.value, with: { (snapshot) in
                var count = 0
                count += Int(snapshot.childrenCount)
                
                if Category == "General"{
                    let newData = CSPieChartData(key: Category, value: Double(count))
                    let newColor = UIColor.red
                    self.colorList.append(newColor)
                    self.dataList.append(newData)

                } else if Category == "Sport"{
                    let newData = CSPieChartData(key: Category, value: Double(count))
                    let newColor = UIColor.orange
                    self.colorList.append(newColor)
                    self.dataList.append(newData)
                    
                } else if Category == "Music"{
                    let newData = CSPieChartData(key: Category, value: Double(count))
                    let newColor = UIColor.yellow
                    self.colorList.append(newColor)
                    self.dataList.append(newData)

                } else if Category == "Technology"{
                    let newData = CSPieChartData(key: Category, value: Double(count))
                    let newColor = UIColor.green
                    self.colorList.append(newColor)
                    self.dataList.append(newData)
                    
                } else if Category == "Business"{
                    let newData = CSPieChartData(key: Category, value: Double(count))
                    let newColor = UIColor.blue
                    self.colorList.append(newColor)
                    self.dataList.append(newData)
                    
                } else if Category == "Science-And-Nature"{
                    let newData = CSPieChartData(key: Category, value: Double(count))
                    let newColor = UIColor.magenta
                    self.colorList.append(newColor)
                    self.dataList.append(newData)
                    
                } else if Category == "Gaming"{
                    let newData = CSPieChartData(key: Category, value: Double(count))
                    let newColor = UIColor.cyan
                    self.colorList.append(newColor)
                    self.dataList.append(newData)

                    
                } else if Category == "Politics"{
                    let newData = CSPieChartData(key: Category, value: Double(count))
                    let newColor = UIColor.black
                    self.colorList.append(newColor)
                    self.dataList.append(newData)
                    
                } else {
                    let newData = CSPieChartData(key: Category, value: Double(count))
                    let newColor = UIColor.gray
                    self.colorList.append(newColor)
                    self.dataList.append(newData)
                }
                    self.pieView.reloadPieChart()
                    self.myActivityIndicator.stopAnimating()
            })
        }
    }
    
    func setupSpinner(){
        
        myActivityIndicator.color = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = true
        view.addSubview(myActivityIndicator)
    }
}

extension StatisticVC: CSPieChartDataSource {
    func numberOfComponentData() -> Int {
        return dataList.count
    }
    
    func pieChartComponentData(at index: Int) -> CSPieChartData {
        return dataList[index]
    }
    
    func numberOfComponentColors() -> Int {
        return colorList.count
    }
    
    func pieChartComponentColor(at index: Int) -> UIColor {
        return colorList[index]
    }
    
    func numberOfLineColors() -> Int {
        return colorList.count
    }
    
    func pieChartLineColor(at index: Int) -> UIColor {
        return colorList[index]
    }
    
    func numberOfComponentSubViews() -> Int {
        return dataList.count
    }
    
    func pieChartComponentSubView(at index: Int) -> UIView {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.image = UIImage(named: "saved")
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }

}

extension StatisticVC: CSPieChartDelegate {
    func didSelectedPieChartComponent(at index: Int) {
        let data = dataList[index]
        print(data.key)
        chooseLabel.text = data.key
        countLabel.text = String(format: "%.0f", data.value)
    }
}
