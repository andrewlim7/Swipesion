//
//  GeneralSettings.swift
//  Swipesion
//
//  Created by Andrew Lim on 25/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import UIKit
import Foundation


/// A custom object to store and retreive your settings from NSUserDefaults

class GeneralSettings: NSObject {
    
    /**
     Stores a boolean value to set the onboarding was completed
     */
    class func saveOnboardingFinished() {
        UserDefaults.standard.set(true, forKey: "onboarding")
        UserDefaults.standard.synchronize()
    }
    
    /**
     Returns the stored boolean key from NSUserDefaults for checking if the onboarding was completed already or not.
     
     - returns: YES, if the onboarding was already completed before
     */
    class func isOnboardingFinished() -> Bool {
        return UserDefaults.standard.bool(forKey: "onboarding")
    }
    
}
