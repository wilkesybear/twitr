//
//  NotificationCell.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/21/15.
//  Copyright © 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mentionTextLabel: UILabel!
    
    var mention: Mention? {
        didSet {
            nameLabel.text = mention?.name
            mentionTextLabel.text = mention?.text
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
