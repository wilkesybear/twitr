//
//  TweetComposerController.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/15/15.
//  Copyright (c) 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

let newTweetCreated = "newTweetCreated"

protocol TweetComposerControllerDelegate {
    func tweetComposerController(tweetComposerController: TweetComposerController, didCreateTweet tweet: Tweet)
}

class TweetComposerController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetField: UITextView!
    @IBOutlet weak var charactersLeftLabel: UILabel!
    
    var delegate: TweetComposerControllerDelegate?
    
    var replyToTweet: Tweet? {
        didSet {
            self.title = "Reply"
        }
    }
    
    var user: User? {
        didSet {
            if let user = user {
                profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
                nameLabel.text = user.name
                screennameLabel.text = user.screenName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User.currentUser
        
        navigationController!.navigationBar.barTintColor = UIColor(red:0.408, green:0.659, blue:0.898, alpha:1.00)
        
        tweetField.becomeFirstResponder()
        tweetField.delegate = self
        
        if replyToTweet != nil {
            let text = replyToTweet!.user!.screenName! as String
            tweetField.text = "@\(text) "
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segue is \(segue)")
    }

    @IBAction func onTweet(sender: AnyObject) {
        var reply_id : Int? = nil
        if replyToTweet != nil {
            reply_id = replyToTweet!.id
        }
        println("\(reply_id)")
        TwitterClient.sharedInstance.tweet(tweetField.text, reply_id: reply_id, completion: { (response, error) -> () in
            if error == nil {
                var tweet = response!
                self.delegate?.tweetComposerController(self, didCreateTweet: tweet)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        var text = textView.text
        
        if (count(text) > 140) {
            textView.text = text.substringToIndex(advance(text.startIndex, 140))
        }
        
        let remain = 140 - count(textView.text)
        
        charactersLeftLabel.text = "\(remain) left"
    }
}
