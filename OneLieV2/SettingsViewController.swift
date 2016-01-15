//
//  SettingsViewController.swift
//  One Lie
//
//  Created by Elex Lee on 12/30/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import Foundation
import iAd
import UIKit
import FBSDKCoreKit
import Parse
import ParseUI

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var aboutShadowImageView: UIView!
    @IBOutlet weak var feedbackShadowImageView: UIView!
    @IBOutlet weak var signOutShadowImageView: UIImageView!
    
    @IBOutlet weak var signOutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scoreTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to our app delegate
    
    var signOut: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryUserScore()
        self.title = "SETTINGS"
        
        var randNum = Int(arc4random_uniform(4))
//        navigationController?.navigationBar.backgroundColor = lightColor(randNum)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 19)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barTintColor = lightColor(randNum)
        
        signOut = false
        
        randNum = Int(arc4random_uniform(4))
        aboutButton.backgroundColor = lightColor(randNum)
        aboutShadowImageView.backgroundColor = darkColor(randNum)
        randNum = Int(arc4random_uniform(4))
        feedbackButton.backgroundColor = lightColor(randNum)
        feedbackShadowImageView.backgroundColor = darkColor(randNum)
        randNum = Int(arc4random_uniform(4))
        scoreTitleLabel.textColor = lightColor(4)
        scoreLabel.textColor = lightColor(4)
        
        buttonFormat(signOutButton, inputShadow: signOutShadowImageView, inputNum: 4)
        signOutButton.setTitleColor(UIColor(red: 0.98, green: 0.52, blue: 0.49, alpha: 1), forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        Ads.sharedInstance.showBannerAd(self)
        if appDelegate.iAdBannerAdView != nil {
            signOutConstraint.constant += appDelegate.iAdBannerAdView.frame.height
        } else if appDelegate.adMobBannerAdView != nil {
            signOutConstraint.constant += appDelegate.adMobBannerAdView.frame.height
        }
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        if appDelegate.iAdBannerAdView != nil {
            signOutConstraint.constant -= appDelegate.iAdBannerAdView.frame.height
        } else if appDelegate.adMobBannerAdView != nil {
            signOutConstraint.constant -= appDelegate.adMobBannerAdView.frame.height
        }
        Ads.sharedInstance.removeBannerAds(self)
//        signOutConstraint.constant -= appDelegate.iAdBanner.frame.height
    }
    

    override func viewDidDisappear(animated: Bool) {
        if signOut == true {
            let loginView = self.storyboard?.instantiateViewControllerWithIdentifier("LogInViewController") as! LoginViewController
            self.presentViewController(loginView, animated: true, completion: nil)
        }
    }
    
    func queryUserScore() {
        let query: PFQuery = PFUser.query()!
        query.whereKey("userID", containsString: FBSDKAccessToken.currentAccessToken().userID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                print("user details \(objects!)")
                for object in objects! {
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        if let queryScoreTotal = object["scoreTotal"] {
                            self.scoreLabel.text = String(queryScoreTotal as! Int)
                            print("user total score \(self.scoreLabel)")
                        }
                    }
                }
            }
        }
    }
    
    func buttonFormat(inputButton: UIButton, inputShadow: UIImageView, inputNum: Int) {
        inputButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        inputButton.backgroundColor = lightColor(inputNum)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = darkColor(inputNum)
        inputShadow.layer.cornerRadius = 7
    }
    
    func lightColor(inputNumber: Int) -> UIColor {
        if inputNumber == 0 {
            // blue
            return UIColor(red: 0.64, green: 0.84, blue: 0.96, alpha: 1)
        } else if inputNumber == 1 {
            // yellow
            return UIColor(red: 0.98, green: 0.82, blue: 0.64, alpha: 1)
        } else if inputNumber == 2 {
            // red
            return UIColor(red: 0.98, green: 0.52, blue: 0.49, alpha: 1)
        } else if inputNumber == 3 {
            // green
            return UIColor(red: 0.5, green: 0.8, blue: 0.62, alpha: 1)
        } else {
            // white
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
    }
    
    func darkColor(inputNumber: Int) -> UIColor {
        if inputNumber == 0 {
            // blue
            return UIColor(red: 0.4, green: 0.65, blue: 0.77, alpha: 1)
        } else if inputNumber == 1 {
            // yellow
            return UIColor(red: 0.96, green: 0.73, blue: 0.44, alpha: 1)
        } else if inputNumber == 2 {
            // red
            return UIColor(red: 0.91, green: 0.43, blue: 0.39, alpha: 1)
        } else if inputNumber == 3 {
            // green
            return UIColor(red: 0.41, green: 0.74, blue: 0.55, alpha: 1)
        } else {
            // grey
            return UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        }
    }

    @IBAction func aboutButtonPressed(sender: UIButton) {
        let aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
        presentViewController(aboutViewController, animated: true, completion: nil)
    }
    
    @IBAction func feedbackButtonPressed(sender: UIButton) {
        let feedbackViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackViewController") as! FeedbackViewController
        print(feedbackViewController)
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
        self.presentViewController(feedbackViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func signOutButtonPressed(sender: UIButton) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            self.signOut = true
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
}
