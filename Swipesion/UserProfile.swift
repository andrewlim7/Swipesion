//
//  UserProfile.swift
//  Swipesion
//
//  Created by Andrew Lim on 24/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserProfile {
    
    var name : String?
    var email : String?
    var profileImageURL : URL?
    var userID : String?
    var fbID : String?
    
    init?(snapshot: DataSnapshot){
        
        self.userID = snapshot.key
        
        guard
            let dictionary = snapshot.value as? [String:Any],
            let validName = dictionary["name"] as? String
            else { return nil }
        
        self.name = validName
        
        if let validEmail = dictionary["email"] as? String {
            self.email = validEmail
        }
        
        if let validprofileImageURL = dictionary["profileImageURL"] as? String{
            let url = URL(string: validprofileImageURL)
            self.profileImageURL = url
        }
        
        if let validfbID = dictionary["id"] as? String {
            self.fbID = validfbID
        }
        
    }
    
}
