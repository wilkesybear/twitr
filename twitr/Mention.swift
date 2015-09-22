//
//  Mention.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/22/15.
//  Copyright © 2015 Andrew Wilkes. All rights reserved.
//

import Foundation

struct Mention {
    var name: String
    var text: String
    
    init(n: String, t: String) {
        self.name = n
        self.text = t
    }
}