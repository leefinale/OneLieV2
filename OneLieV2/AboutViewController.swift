//
//  AboutViewController.swift
//  One Lie
//
//  Created by Elex Lee on 12/25/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import iAd
import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var copyrightLabel: NSLayoutConstraint!
    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to our app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        aboutTextView.scrollEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        Ads.sharedInstance.showBannerAd(self)
        if appDelegate.iAdBannerAdView != nil {
            copyrightLabel.constant += appDelegate.iAdBannerAdView.frame.height
        } else if appDelegate.adMobBannerAdView != nil {
            copyrightLabel.constant += appDelegate.adMobBannerAdView.frame.height
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        Ads.sharedInstance.removeBannerAds(self)
        if appDelegate.iAdBannerAdView != nil {
            copyrightLabel.constant -= appDelegate.iAdBannerAdView.frame.height
        } else if appDelegate.adMobBannerAdView != nil {
            copyrightLabel.constant -= appDelegate.adMobBannerAdView.frame.height
        }
    }


    @IBAction func closeButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}