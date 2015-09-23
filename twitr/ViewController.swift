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
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> () in
            print("completed login")
            if user != nil {
            
                self.performSegueWithIdentifier("loginSegue2", sender: self)
            }
        }
    }

}

