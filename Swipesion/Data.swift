//
//  Data.swift
//  Swipesion
//
//  Created by Andrew Lim on 14/07/2017.
//  Copyright © 2017 Andrew Lim. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Data {
    
    var author: String?
    var description: String?
    var title: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var nid: String?
    var category: String?
    var linkID : String?
    
    
    init?(snapshot: DataSnapshot){
        
        self.linkID = snapshot.key
        
        guard let dictionary = snapshot.value as? [String: Any] else { return nil }
        
        if let validAuthor = dictionary["author"] as? String  {
            self.author = validAuthor
        } else {
            self.author = ""
        }
        
        if let validDescription = dictionary["description"] as? String {
            
            self.description = validDescription
        } else {
            self.description = ""
        }
        
        if let validTitle = dictionary["title"] as? String{
            self.title = validTitle
        }else{
            self.title = ""
        }
        
        if let validUrl = dictionary["url"] as? String{
            self.url = validUrl
        }else{
            self.url = ""
        }
        
        if let validURLToImage = dictionary["urlToImage"] as? String{
            self.urlToImage = validURLToImage
        }else{
            self.urlToImage = ""
        }
        
        if let validDate = dictionary["publishAt"] as? String{
            self.publishedAt = validDate
        }else{
            self.publishedAt = ""
        }

 
        
        
    }
    
    
    
}
