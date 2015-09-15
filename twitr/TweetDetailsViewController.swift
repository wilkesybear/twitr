//
//  TweetDetailsViewController.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/15/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedImageView: UIImageView!
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.barTintColor = UIColor(red:0.408, green:0.659, blue:0.898, alpha:1.00)
        
        if let tweet = tweet {
            profileImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
            nameLabel.text = tweet.user?.name
            screennameLabel.text = "@\(tweet.user!.screenName!)"
            tweetLabel.text = tweet.text
            timeLabel.text = tweet.createdAtString
            
            retweetCountLabel.text = "\(tweet.retweetedCount!)"
            favoritesCountLabel.text = "\(tweet.favoritedCount!)"
            
            if tweet.favorited! == true {
                self.favoriteButton.setImage(UIImage(named: "twitter_favorite_on.png"), forState: UIControlState.Normal)
            }
            
            if tweet.retweeted! == true {
                self.retweetButton.setImage(UIImage(named: "twitter_retweet_on.png"), forState: UIControlState.Normal)
            }
            
            if tweet.isARetweet == true {
                retweetedLabel.text = "\(tweet.user!.name!) retweeted"
                retweetedLabel.hidden = false
                retweetedImageView.hidden = false
            } else {
                retweetedLabel.hidden = true
                retweetedImageView.hidden = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet!.id!, completion: { (response, error) -> () in
            if response != nil {
                self.retweetButton.setImage(UIImage(named: "twitter_retweet_on.png"), forState: UIControlState.Normal)
                self.retweetCountLabel.text = "\(1 + self.tweet!.retweetedCount!)"
            }
        })
    }
    
    
    @IBAction func onReply(sender: AnyObject) {
        performSegueWithIdentifier("DetailsReply", sender: self)
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(tweet!.id!, completion: { (response, error) -> () in
            if response != nil {
                self.favoriteButton.setImage(UIImage(named: "twitter_favorite_on.png"), forState: UIControlState.Normal)
                self.favoritesCountLabel.text = "\(1 + self.tweet!.favoritedCount!)"
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        println("segueing here")
        var nc = segue.destinationViewController as! UINavigationController
        var vc = nc.topViewController as! TweetComposerController
        vc.replyToTweet = tweet!
    }

}
