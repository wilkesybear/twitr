//
//  ViewController.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/14/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginClicked(sender: AnyObject) {
//        TwitterClient.sharedInstance.requestSerializer.clearAuthorizationHeader()
//        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitter://oauth"), scope: nil,
//            success: { (requestToken: BDBOAuth1Credential!) -> Void in
//                println("Got my token")
//                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
//                UIApplication.sharedApplication().openURL(authURL!)
//                
//            }) { (error: NSError!) -> Void in
//                println("Uh oh")
//        }
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> () in
            print("completed login")
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
        }
    }

}

