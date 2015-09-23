//
//  AppDelegate.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/14/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
        
        if User.currentUser != nil {
            // Go to the logged in screen
            print("Current user detected \(User.currentUser!.name)")
            let vc = storyboard.instantiateViewControllerWithIdentifier("HamburgerViewController") as! HamburgerViewController
            window?.rootViewController = vc
            
            let tweetsViewNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsViewNavigationController")
            
            vc.contentViewController = tweetsViewNavigationController

            let menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
            
            vc.menuViewController = menuViewController
            
            menuViewController.hamburgerViewController = vc
            menuViewController.tweetsViewController = tweetsViewNavigationController
            
            let profileController = storyboard.instantiateViewControllerWithIdentifier("ProfileDetailsController") as! ProfileDetailsController
            
            menuViewController.profileViewController = profileController
        }
        
        return true
    }
    
    func userDidLogout() {
        let vc = storyboard.instantiateInitialViewController() as UIViewController!
        window?.rootViewController = vc
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        TwitterClient.sharedInstance.openURL(url)
        
//        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
//            println("Got access token")
//            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
//            
//            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
////                    println("user: \(response)")
//                    var user = User(dictionary: response as! NSDictionary)
//                    println("\(user.name)")
//                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                    println("error getting current user")
//                }
//            )
//            
//            TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//                var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
//                for t in tweets {
//                    println("\(t.text) \(t.createdAt)")
//                }
//                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                println("failed to get timeline")
//            })
//            
//            }) { (error: NSError!) -> Void in
//            println("Failed to receive access token")
//        }
        
        return true
    }


}

