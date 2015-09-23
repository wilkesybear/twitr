//
//  HamburgerViewController.swift
//  twitr
//
//  Created by Andrew Wilkes on 9/22/15.
//  Copyright © 2015 Andrew Wilkes. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var originalLeftMargin: CGFloat!
    @IBOutlet weak var leftMargin: NSLayoutConstraint!
    
    var menuViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldCVC) {
            view.layoutIfNeeded()
            
            if oldCVC != nil {
                oldCVC.willMoveToParentViewController(nil)
                oldCVC.view.removeFromSuperview()
                oldCVC.didMoveToParentViewController(nil)
            }
            
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.leftMargin.constant = 0
                self.view.layoutIfNeeded()
            })
            contentViewController.view.frame = contentView.frame
        }
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        let velocity = sender.velocityInView(view)
        
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            originalLeftMargin = leftMargin.constant
        } else if sender.state == UIGestureRecognizerState.Changed {
            leftMargin.constant = originalLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                if velocity.x > 0 {
                    self.leftMargin.constant = self.view.frame.size.width - 50
                } else {
                    self.leftMargin.constant = 0
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
