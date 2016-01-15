//
//  AppDelegate.swift
//  OneLieV2
//
//  Created by Elex Lee on 12/19/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import iAd
import GoogleMobileAds
import UIKit
import Parse
import Bolts
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
//    ADBannerViewDelegate

    var window: UIWindow?
    var iAdBannerAdView: ADBannerView!
    var adMobBannerAdView: GADBannerView!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios/guide#local-datastore
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        // User database
        Parse.setApplicationId("z3BP21YVmcE4sQrVoOhjjhzAINMaamczOT1o0IbC",
            clientKey: "kmlByGYyqhtFwm88uUymuWGgybaV4drjhvPX4LQs")
        
        // Dev database
//        Parse.setApplicationId("oFhl52upDQuibmj8CpNVNl9wwG6x3fHRrAtLwYTh",
//            clientKey: "x4jeQP5foRwbmX27fvrVN9VxWI74HgJGV6xqGw6U")
        
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        
//        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        if PFUser.currentUser() != nil {
            let user = PFUser.currentUser()
            user!.fetchInBackgroundWithBlock() {
                Void in
                
                print("parse current user update \(user!)")
                
                //            self.playButton.userInteractionEnabled = true
                //            self.createButton.userInteractionEnabled = true
                //            self.libraryButton.userInteractionEnabled = true
                //            self.aboutButton.userInteractionEnabled = true
                //            self.signOutButton.userInteractionEnabled = true
            }
            
        }
        
//        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//            // Set delegate and hide banner initially
//            iAdBanner.delegate = self
//            iAdBanner.hidden = true
//            return true
//        }
//        
//        func bannerViewDidLoadAd(banner: ADBannerView!) {
//            print("bannerViewDidLoadAd")
//            iAdBanner.hidden = false
//        }
//        
//        func bannerViewActionDidFinish(banner: ADBannerView!) {
//            print("bannerViewActionDidFinish")
//        }
//        
//        func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
//            print("didFailToReceiveAdWithError: \(error)")
//            iAdBanner.hidden = true
//        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}

