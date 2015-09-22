//
//  MenuViewController.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/21/15.
//  Copyright © 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    
    var mentions: [Mention]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = User.currentUser!

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        loadMentions()
    }
    
    func loadMentions() {
        TwitterClient.sharedInstance.mentions({ (response, error) -> () in
            if error == nil {
                self.mentions = response
            }
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Mentions"
        }
        return ""
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 {
            return 1
        } else if let mentions = mentions {
            return mentions.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileHeaderCell") as! ProfileHeaderCell
            
            cell.user = user
            
            return cell
            
        } else if section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Links Cell")!
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NotificationsCell") as! NotificationCell
            
            cell.mention = mentions![indexPath.row]
            
            return cell
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
