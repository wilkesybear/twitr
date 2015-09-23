//
//  ProfileViewCell.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/22/15.
//  Copyright © 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    @IBOutlet weak var profileHeaderImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    
    var user: User! {
        didSet {
            profileHeaderImageView.setImageWithURL(NSURL(string: user.profileHeader!))
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrlHD!))
            profileImageView.contentMode = .ScaleAspectFit
            usernameLabel.text = user.name!
            numTweetsLabel.text = "\(user.numTweets!) tweets"
            taglineLabel.text = user.tagline!
            screennameLabel.text = user.screenName!
            numFollowersLabel.text = "\(user.followersCount!)"
            numFollowingLabel.text = "\(user.followingCount!)"
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

}
