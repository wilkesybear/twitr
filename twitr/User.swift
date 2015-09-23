//
//  User.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/14/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

var _currentUser: User?
var currentUserKey = "kCurrentUser"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var id: Int?
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var profileImageUrlHD: String?
    var tagline: String?
    var dictionary: NSDictionary
    var followingCount: Int?
    var followersCount: Int?
    var profileHeader: String?
    var numTweets: Int?
    
    var tweets: [Tweet]?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url_https"] as? String
        
        profileImageUrlHD = profileImageUrl!
        
        let range = profileImageUrlHD!.rangeOfString("_normal", options: .RegularExpressionSearch)
        if let range = range {
            profileImageUrlHD = profileImageUrlHD!.stringByReplacingCharactersInRange(range, withString: "_bigger")
        }
        
        tagline = dictionary["description"] as? String
        followingCount = dictionary["friends_count"] as? Int
        followersCount = dictionary["followers_count"] as? Int
        
        profileHeader = dictionary["profile_banner_url"] as? String
        numTweets = dictionary["statuses_count"] as? Int
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    func getTweets(completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.userTweets(id!, completion: { (tweets, error) -> () in
            if tweets != nil {
                self.tweets = tweets
            }
            completion(tweets: self.tweets, error: error)
        })
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    let dictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: [])) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                let data = try? NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
