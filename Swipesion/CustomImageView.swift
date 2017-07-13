//
//  CustomImageView.swift
//  KolodaTest
//
//  Created by Mohd Adam on 11/07/2017.
//  Copyright © 2017 Mohd Adam. All rights reserved.
//

import UIKit
import Koloda

class CustomImageView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    @IBOutlet weak var customLabelText: UILabel!
    
    @IBOutlet lazy var customImageView: UIImageView! = {
        
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        
        self.addSubview(imageView)
        
        return imageView
        
        }()
    
    func loadXib(){
        
        Bundle.main.loadNibNamed("CustomView", owner: self, options: nil) //as? CustomImageView
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

