//
//  TwitterClient.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/14/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let twitterConsumerKey = "x2AjRwmksl56JF34reKcibwqO"
let twitterConsumerSecret = "YrZza5d3yd0eXwS74lsXvYMzDYdb3P5AH4igU63RDaou0e7T2k"

class TwitterClient: BDBOAuth1RequestOperationManager {
   
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authorization page
        requestSerializer.clearAuthorizationHeader()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitter://oauth"), scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                println("Got my token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
                
            }) { (error: NSError!) -> Void in
                println("Uh oh")
                self.loginCompletion?(user: nil, error: error)
            }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Got access token")
            self.requestSerializer.saveAccessToken(accessToken)
            
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void
                in
                    var user = User(dictionary: response as! NSDictionary)
                    User.currentUser = user
                    println("\(user.name)")
                    self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
                }
            )
            
            }) { (error: NSError!) -> Void in
                self.loginCompletion?(user: nil, error: error)
                println("Failed to receive access token")
        }

    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            for t in tweets {
                println("\(t.text) \(t.createdAt)")
            }
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("failed to get timeline")
                completion(tweets: nil, error: error)
        })
    }
    
    func favorite(id: Int, completion: (response: AnyObject?, error: NSError?) -> ()) {
        var params = ["id": id]
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Successfully favorited")
            completion(response: response, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Could not favorite: \(error)")
                completion(response: nil, error: error)
        })
    }
    
    func retweet(id: Int, completion: (response: AnyObject?, error: NSError?) -> ()) {
        var url = "1.1/statuses/retweet/\(id).json"
        POST(url, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Successfully retweeted")
            completion(response: response, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Could not retweet: \(error)")
                completion(response: nil, error: error)
        })
    }
    
    func tweet(text: String, reply_id: Int?, completion: (response: Tweet?, error: NSError?) -> ()) {
        var params = ["status": text]
        if reply_id != nil {
            params["in_reply_to_status_id"] = "\(reply_id!)"
        }
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Successfully tweeted")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(response: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Could not tweet: \(error)")
                completion(response: nil, error: error)
        })
    }
    
    
}
