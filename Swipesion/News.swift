//
//  News.swift
//  KolodaTest
//
//  Created by Mohd Adam on 11/07/2017.
//  Copyright © 2017 Mohd Adam. All rights reserved.
//

import Foundation
import FirebaseDatabase

class News {

    var author: String?
    var sourceName : String?
    var description: String?
    var title: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var nid: String?
    var category: String?
    var linkID : String?
    var timestamp : Date
    
    init?(dictionary: [String:Any], source: String? = nil) {
        self.author = dictionary["author"] as? String  ?? "N/A"
        self.description = dictionary["description"] as? String ?? "N/A"
        self.title = dictionary["title"] as? String ?? "N/A"
        self.url = dictionary["url"] as? String ?? "N/A"
        self.urlToImage = dictionary["urlToImage"] as? String ?? "N/A"
        self.publishedAt = dictionary["publishAt"] as? String ?? "N/A"
        self.nid = dictionary["id"] as? String ?? "N/A"
        self.category = dictionary["category"] as?  String ?? "N/A"
        self.sourceName = source ?? dictionary["sourceName"] as? String ?? "N/A"
        self.timestamp = Date()
    }
}

extension News {
    
    convenience init?(snapshot: DataSnapshot) {
        guard
            let dictionary = snapshot.value as? [String: Any]
        else { return nil }
        
        self.init(dictionary: dictionary)
        self.linkID = snapshot.key
        
        if let validTimestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: validTimestamp)
        }
    }
}
