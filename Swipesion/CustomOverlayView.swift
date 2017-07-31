//
//  CustomOverlayView.swift
//  KolodaTest
//
//  Created by Mohd Adam on 11/07/2017.
//  Copyright © 2017 Mohd Adam. All rights reserved.
//

import UIKit
import Koloda

class CustomOverlayView: OverlayView {
    
    let overlayRightImage = "like"
    let overlayLeftImage = "dislike"
    let overlayDownImage = "saved-1"
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        
        self.addSubview(imageView)
        
        return imageView
    }()
    
    override var overlayState: SwipeResultDirection? {
        
        didSet {
            
            switch overlayState {
            case .left?:
                overlayImageView.image = UIImage(named: overlayLeftImage)
//                overlayImageView.tintColor = UIColor.red
            case .right?:
                overlayImageView.image = UIImage(named: overlayRightImage)
//                overlayImageView.tintColor = UIColor.green
                
//            case .up?:
//                overlayImageView.image = UIImage(named: overlayDownImage)

            default:
                overlayImageView.image = nil
            }
        }
    }
}
