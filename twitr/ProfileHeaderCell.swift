//
//  ProfileHeaderCell.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/21/15.
//  Copyright © 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var user: User? {
        didSet {
            usernameLabel.text = user?.name
            descriptionLabel.text = user?.tagline
            profileImageView.setImageWithURL(NSURL(string: (user?.profileImageUrl)!))
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
