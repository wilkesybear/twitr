//
//  Tweet.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/14/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var id: Int?
    var isARetweet: Bool?
    var favorited: Bool?
    var retweeted: Bool?
    var favoritedCount: Int?
    var retweetedCount: Int?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = dictionary["id"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        
        if dictionary.valueForKey("retweeted_status") != nil {
            isARetweet = true
        } else {
            isARetweet = false
        }
        
        favoritedCount = dictionary["favorite_count"] as? Int
        retweetedCount = dictionary["retweet_count"] as? Int
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    func createdFromTimeAgo() -> String {
        if let createdAt = createdAt {
            return createdAt.shortTimeAgoSinceNow()
        } else {
            return ""
        }
    }
}
