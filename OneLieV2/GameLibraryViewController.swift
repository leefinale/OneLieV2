//
//  GameLibraryViewController.swift
//  One Lie
//
//  Created by Elex Lee on 12/29/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//


import FBSDKCoreKit
import Foundation
import iAd
import Parse
import ParseUI
import UIKit

class GameLibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GameDeleteDetailViewControllerDelegate {
    
    @IBOutlet weak var gameLibraryCollectionView: UICollectionView!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var homeShadowImageView: UIImageView!
    
    @IBOutlet weak var homeButtonConstraint: NSLayoutConstraint!
    
    var gameArray: [PFFile?]?
    var gameStrings: [String]?
    var objectIDArray: [String]?
    var selectedCell: Int?
    var loadingImagesSpinner: UIActivityIndicatorView?
    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to our app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameArray = [PFFile?]()
        objectIDArray = [String]()
        gameStrings = [String]()
        gameLibraryCollectionView.backgroundColor = UIColor(red: 0.86, green: 0.86, blue: 0.86, alpha: 0.86)
        buttonFormat(homeButton, inputShadow: homeShadowImageView)
        queryParseForUserGames()
    }
    
    override func viewWillAppear(animated: Bool) {
        Ads.sharedInstance.showBannerAd(self)
        if appDelegate.iAdBannerAdView != nil {
            homeButtonConstraint.constant += appDelegate.iAdBannerAdView.frame.height
        } else if appDelegate.adMobBannerAdView != nil {
            homeButtonConstraint.constant += appDelegate.adMobBannerAdView.frame.height
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        Ads.sharedInstance.removeBannerAds(self)
        if appDelegate.iAdBannerAdView != nil {
            homeButtonConstraint.constant -= appDelegate.iAdBannerAdView.frame.height
        } else if appDelegate.adMobBannerAdView != nil {
            homeButtonConstraint.constant -= appDelegate.adMobBannerAdView.frame.height
        }
    }
//    override func viewDidDisappear(animated: Bool) {
//        homeButtonConstraint.constant -= appDelegate.iAdBanner.frame.height
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if gameArray != nil {
            return gameArray!.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //        let cell = UICollectionViewCell(frame: CGRectMake(0, 0, 50, 50))
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gameLibraryCell", forIndexPath: indexPath)
        let randNum = Int(arc4random_uniform(4))
        cell.backgroundColor = darkColor(randNum)
        cell.layer.borderColor = lightColor(randNum).CGColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 7
        cell.clipsToBounds = true
        
        let collectionViewWidth = gameLibraryCollectionView.bounds.width
        let gameImage = PFImageView(frame: CGRectMake(0, 0, (collectionViewWidth - 41) / 3, (collectionViewWidth - 41) / 3))
        if gameArray != nil {
            if let image = gameArray![indexPath.row] {
                gameImage.file = image as PFFile
                gameImage.clipsToBounds = true
                gameImage.loadInBackground()
            }
        } else {
            gameImage.image = UIImage.imageWithColor(UIColor.redColor())
        }
        cell.addSubview(gameImage)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if objectIDArray!.count != 0 {
            selectedCell = indexPath.row
            let gameDeleteDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GameDeleteDetailViewController") as! GameDeleteDetailViewController
            
            let query = PFQuery(className: "GameSets")
            query.selectKeys(["gameStrings"])
            query.whereKey("objectId", equalTo: objectIDArray![indexPath.row])
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                print("grabbed objects")
                if let object = objects {
                    self.gameStrings = (object[0]["gameStrings"] as? [String])!
                }
                self.presentViewController(gameDeleteDetailViewController, animated: true) {
                    () -> Void in
                    gameDeleteDetailViewController.delegate = self
                    gameDeleteDetailViewController.gameObjectID = self.objectIDArray![indexPath.row]
                    gameDeleteDetailViewController.gameImageView.file = self.gameArray![indexPath.row]
                    gameDeleteDetailViewController.truthOneTextField.text = self.gameStrings![0]
                    gameDeleteDetailViewController.truthTwoTextField.text = self.gameStrings![1]
                    gameDeleteDetailViewController.lieOneTextField.text = self.gameStrings![2]
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let collectionViewWidth = gameLibraryCollectionView.bounds.width
//        print(collectionViewWidth - 50 / 3)
        return CGSize(width: (collectionViewWidth - 41) / 3, height: (collectionViewWidth - 41) / 3)
    }
    
    func queryParseForUserGames() {
        loadingImagesSpinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView
        loadingImagesSpinner!.layer.cornerRadius = 7
        loadingImagesSpinner!.center = self.view.center
        loadingImagesSpinner!.hidesWhenStopped = true
        loadingImagesSpinner!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(loadingImagesSpinner!)
        loadingImagesSpinner!.startAnimating()
        
        let query = PFQuery(className: "GameSets")
        query.selectKeys(["gameImage"])
        query.whereKey("hidden", notEqualTo: true)
        query.whereKey("creatorUserID", containsString: FBSDKAccessToken.currentAccessToken().userID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            print(objects)
            self.gameArray = [PFFile?]()
            self.objectIDArray = [String]()
            for object in objects! {
                if let imageObject = object["gameImage"] {
                    self.gameArray?.append(imageObject as? PFFile)
                    self.objectIDArray?.append(object.objectId!)
                }
            }
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.gameLibraryCollectionView.reloadData()
                self.loadingImagesSpinner?.stopAnimating()
            }
        }
    }
    
    func gameWasDeleted() {
//        gameArray = [PFFile?]()
//        objectIDArray = [String]()
//        gameStrings = [String]()
//        queryParseForUserGames()
//        gameArray?.removeAtIndex(selectedCell!)
        queryParseForUserGames()
//        gameLibraryCollectionView.reloadData()
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
    
    func buttonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        let randNum = Int(arc4random_uniform(4))
        
        inputButton.backgroundColor = lightColor(randNum)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = darkColor(randNum)
        inputShadow.layer.cornerRadius = 7
    }
    
    @IBAction func goHomePressed(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}