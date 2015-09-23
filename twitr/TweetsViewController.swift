//
//  TweetsViewController.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/15/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetComposerControllerDelegate, TweetsCellDelegate, UIGestureRecognizerDelegate {
    
    var tweets: [Tweet]?
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.barTintColor = UIColor(red:0.408, green:0.659, blue:0.898, alpha:1.00)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "loadTimeline", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        loadTimeline()
    }
    
    func loadTimeline() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetsCell
        
        let tweet = tweets![indexPath.row]
        
        cell.tweet = tweet
        cell.delegate = self
        
        return cell
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print("segue is \(segue.identifier)")
        
        if segue.identifier == "ComposeTweet" {
            let nc = segue.destinationViewController as! UINavigationController
            let vc = nc.topViewController as! TweetComposerController
            vc.delegate = self
            
            if sender! is Tweet {
                vc.replyToTweet = sender as? Tweet
            }
            
        } else if segue.identifier == "TweetDetails" {
            let vc = segue.destinationViewController as! TweetDetailsViewController
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            let tweet = tweets![indexPath.row]
            vc.tweet = tweet
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tweetComposerController(tweetComposerController: TweetComposerController, didCreateTweet tweet: Tweet) {
        if tweets != nil {
            tweets!.insert(tweet, atIndex: 0)
            tableView.reloadData()
        }
    }
    
    func tweetsCell(tweetsCell: TweetsCell, replyToTweet: Tweet) {
        performSegueWithIdentifier("ComposeTweet", sender: replyToTweet)
    }


}
