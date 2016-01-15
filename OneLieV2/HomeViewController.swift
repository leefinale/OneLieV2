//
//  ViewController.swift
//  OneLieV2
//
//  Created by Elex Lee on 12/19/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import Parse
import iAd
import UIKit
import FBSDKLoginKit

class HomeViewController: UIViewController, FBSDKLoginButtonDelegate, CreateViewControllerDelegate {
//    ADInterstitialAdDelegate

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var playShadowImageView: UIImageView!
    @IBOutlet weak var createShadowImageView: UIImageView!
    @IBOutlet weak var libraryShadowImageView: UIImageView!
    @IBOutlet weak var settingsShadowImageView: UIImageView!
    
//    var interstitialAd:ADInterstitialAd!
//    var interstitialAdView: UIView = UIView()
    
    var adLoaded: Bool?
    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to our app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
//        canDisplayBannerAds = true
//        interstitialAd = ADInterstitialAd()
//        interstitialAd.delegate = self
//        interstitialPresentationPolicy = ADInterstitialPresentationPolicy.Manual
        
        buttonFormat(playButton, inputShadow: playShadowImageView, inputNum: 0)
        buttonFormat(createButton, inputShadow: createShadowImageView, inputNum: 3)
        buttonFormat(libraryButton, inputShadow: libraryShadowImageView, inputNum: 1)
        buttonFormat(settingsButton, inputShadow: settingsShadowImageView, inputNum: 2)
//        buttonFormat(signOutButton, inputShadow: signOutShadowImageView, inputNum: 4)
//        signOutButton.setTitleColor(UIColor(red: 0.98, green: 0.52, blue: 0.49, alpha: 1), forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        Ads.sharedInstance.showBannerAd(self)
    }
    
    override func viewWillDisappear(animated: Bool) {
        Ads.sharedInstance.removeBannerAds(self)
    }
    
    override func viewDidAppear(animated: Bool) {
//        Ads.sharedInstance.showBannerAd(self)
        print("fb current access token \(FBSDKAccessToken.currentAccessToken())")
        print("parse current user stored in cache \(PFUser.currentUser())")
        
        playButton.userInteractionEnabled = false
        createButton.userInteractionEnabled = false
        libraryButton.userInteractionEnabled = false
        settingsButton.userInteractionEnabled = false
        
        if (FBSDKAccessToken.currentAccessToken() != nil && PFUser.currentUser() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
//            user!.fetchIfNeededInBackground()
            playButton.userInteractionEnabled = true
            createButton.userInteractionEnabled = true
            libraryButton.userInteractionEnabled = true
            settingsButton.userInteractionEnabled = true
            requestFacebook()
        } else {
            let loginView = self.storyboard?.instantiateViewControllerWithIdentifier("LogInViewController") as! LoginViewController
            self.presentViewController(loginView, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestFacebook() {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, about, bio, birthday, email, education, gender, relationship_status, family, picture"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            if error != nil {
//                print(error)
//            } else {
//                print(result.valueForKey("name")!)
//                if let about = result.valueForKey("about") {
//                    print(about)
//                }
//                if let bio = result.valueForKey("bio") {
//                    print(bio)
//                }
//                if let birthday = result.valueForKey("birthday") {
//                    print(birthday)
//                }
//                if let email = result.valueForKey("email") {
//                    print(email)
//                }
//                if let education = result.valueForKey("education") {
//                    print(education)
//                }
//                if let gender = result.valueForKey("gender") {
//                    print(gender)
//                }
//                if let relationship = result.valueForKey("relationship_status") {
//                    print(relationship)
//                }
//                if let family = result.valueForKey("family") {
//                    print(family)
//                }
//            }
        })
    }
    
    func buttonFormat(inputButton: UIButton, inputShadow: UIImageView, inputNum: Int) {
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = inputButton.bounds
//        gradient.cornerRadius = 5
//        gradient.colors = [
//            UIColor.grayColor().CGColor,
//            UIColor.grayColor().CGColor,
//            UIColor.blackColor().CGColor,
//            UIColor.blackColor().CGColor
//        ]
//        
//        /* repeat the central location to have solid colors */
//        gradient.locations = [0, 0.5, 0.5, 1.0]
//        
//        /* make it horizontal */
//        gradient.startPoint = CGPointMake(0, 0.75)
//        gradient.endPoint = CGPointMake(0, 1)
//        
//        inputButton.layer.insertSublayer(gradient, atIndex: 0)
        inputButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)

        inputButton.backgroundColor = buttonColorRandom(inputNum)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = buttonBorderColorRandom(inputNum)
        inputShadow.layer.cornerRadius = 7
    }
    
    func buttonColorRandom(inputNumber: Int) -> UIColor {
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
    
    func buttonBorderColorRandom(inputNumber: Int) -> UIColor {
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
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                print(result)
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func setWasCreated() {
//        showAd() {
//            () -> Void in
//        }
    }
    
    
//    func interstitialAdWillLoad(interstitialAd: ADInterstitialAd!) {
//        
//    }
//    
//    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
//        if adLoaded == false {
//            adLoaded = true
//        }
//    }
//    
//    func interstitialAdActionDidFinish(interstitialAd: ADInterstitialAd!) {
//        interstitialAdView.removeFromSuperview()
//    }
//    
//    func interstitialAdActionShouldBegin(interstitialAd: ADInterstitialAd!, willLeaveApplication willLeave: Bool) -> Bool {
//        return true
//    }
//    
//    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
//        
//    }
//    
//    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
//        interstitialAdView.removeFromSuperview()
//    }
//    
//    func showAd(completion: () -> Void) {
//        if let loaded = adLoaded {
//            if loaded == true {
//                interstitialAdView = UIView()
//                interstitialAdView.frame = self.view.bounds
//                view.addSubview(interstitialAdView)
//                
//                interstitialAd.presentInView(interstitialAdView)
//                UIViewController.prepareInterstitialAds()
//            }
//        }
//    }
    
    @IBAction func createButtonPressed(sender: UIButton) {
        let createViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CreateViewController") as! CreateViewController
        createViewController.delegate = self
        self.presentViewController(createViewController, animated: true, completion: nil)
    }
}



