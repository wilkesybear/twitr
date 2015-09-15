//
//  TweetsCell.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/15/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

protocol TweetsCellDelegate {
    func tweetsCell(tweetsCell: TweetsCell, replyToTweet: Tweet)
}

class TweetsCell: UITableViewCell {
    
    // toggle visibility
    @IBOutlet weak var retweetedLabel: UILabel!
    @IBOutlet weak var retweetedImage: UIImageView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var delegate: TweetsCellDelegate?
    
    var tweet: Tweet? {
        didSet {
            if let tweet = tweet {
                avatarImageView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
                usernameLabel.text = tweet.user?.name
                screennameLabel.text = "@\(tweet.user!.screenName!)"
                tweetTextLabel.text = tweet.text
                timeLabel.text = tweet.createdFromTimeAgo()
                
                if tweet.favorited! == true {
                    self.favoriteButton.setImage(UIImage(named: "twitter_favorite_on.png"), forState: UIControlState.Normal)
                } else {
                    self.favoriteButton.setImage(UIImage(named: "twitter_favorite.png"), forState: UIControlState.Normal)
                }
                
                if tweet.retweeted! == true {
                    self.retweetButton.setImage(UIImage(named: "twitter_retweet_on.png"), forState: UIControlState.Normal)
                } else {
                    self.retweetButton.setImage(UIImage(named: "twitter_retweet.png"), forState: UIControlState.Normal)
                }
                
                if tweet.isARetweet == true {
                    retweetedLabel.text = "\(tweet.user!.name!) retweeted"
                    retweetedLabel.hidden = false
                    retweetedImage.hidden = false
                } else {
                    retweetedLabel.hidden = true
                    retweetedImage.hidden = true
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReply(sender: AnyObject) {
        delegate?.tweetsCell(self, replyToTweet: tweet!)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet!.id!, completion: { (response, error) -> () in
            if response != nil {
                self.retweetButton.setImage(UIImage(named: "twitter_retweet_on.png"), forState: UIControlState.Normal)
            }
        })
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(tweet!.id!, completion: { (response, error) -> () in
            if response != nil {
                self.favoriteButton.setImage(UIImage(named: "twitter_favorite_on.png"), forState: UIControlState.Normal)
            }
        })
        
    }
    
}
