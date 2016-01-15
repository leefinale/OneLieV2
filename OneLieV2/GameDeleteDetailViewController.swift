//
//  GameEditDetailViewController.swift
//  One Lie
//
//  Created by Elex Lee on 12/30/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import Foundation
import iAd
import UIKit
import Parse
import ParseUI
import FBSDKCoreKit

protocol GameDeleteDetailViewControllerDelegate
{
    func gameWasDeleted()
}

class GameDeleteDetailViewController: UIViewController, ADBannerViewDelegate {
    
    
    @IBOutlet weak var gameImageView: PFImageView!

    @IBOutlet weak var truthOneTextField: UITextField!
    @IBOutlet weak var truthTwoTextField: UITextField!
    @IBOutlet weak var lieOneTextField: UITextField!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var deleteButtonShadowImageView: UIImageView!
    @IBOutlet weak var cancelButtonShadowImageView: UIImageView!
    
    var gameObjectID: String?
    
    var delegate: GameDeleteDetailViewControllerDelegate!
    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to our app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Ads.sharedInstance.presentingViewController = self
            
        gameImageView.layer.cornerRadius = 7
        gameImageView.clipsToBounds = true
        gameImageView.layer.borderWidth = 3
        gameImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        truthOneTextField.text = ""
        truthTwoTextField.text = ""
        lieOneTextField.text = ""
        
        deleteButtonFormat(deleteButton, inputShadow: deleteButtonShadowImageView)
        cancelButtonFormat(cancelButton, inputShadow: cancelButtonShadowImageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        Ads.sharedInstance.showBannerAd(self)
    }

    override func viewWillDisappear(animated: Bool) {
        Ads.sharedInstance.removeBannerAds(self)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func deleteButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        inputButton.backgroundColor = lightColor(2)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = darkColor(2)
        inputShadow.layer.cornerRadius = 7
    }
    
    func cancelButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(lightColor(2), forState: .Normal)
        
        inputButton.backgroundColor = lightColor(4)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = darkColor(4)
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
    
    func setButtonLabelStatus(input: Bool) {
        deleteButton.enabled = input
        cancelButton.enabled = input
    }
    
    func createCustomAlert(alertMessage: String) {
        setButtonLabelStatus(false)
        
        let customAlertView = UIView(frame: CGRectMake(0, 0, 270, 140))
        customAlertView.layer.cornerRadius = 7
        //        customAlertView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        customAlertView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        //        customAlertView.backgroundColor = UIColor(red: 0.64, green: 0.84, blue: 0.96, alpha: 1)
        customAlertView.layer.borderWidth = 3
        customAlertView.layer.borderColor = UIColor(red: 0.93, green: 0.2, blue: 0.2, alpha: 1).CGColor
        //        customAlertView.layer.borderColor = UIColor(red: 0.4, green: 0.65, blue: 0.77, alpha: 1).CGColor
        customAlertView.center = self.view.center
        self.view.addSubview(customAlertView)
        
        let customAlertText = UITextView(frame: CGRectMake(10, 5, 250, 70))
        customAlertText.userInteractionEnabled = false
        customAlertText.backgroundColor = UIColor.clearColor()
        customAlertText.text = alertMessage
        customAlertText.textColor = UIColor(red: 0.93, green: 0.2, blue: 0.2, alpha: 1)
        customAlertText.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
        customAlertText.textAlignment = .Center
        customAlertView.addSubview(customAlertText)
        
        let customAlertConfirmShadow = UIImageView(frame: CGRectMake(150, 78, 90, 35))
        customAlertConfirmShadow.layer.cornerRadius = 7
        customAlertConfirmShadow.backgroundColor = darkColor(2)
        customAlertView.addSubview(customAlertConfirmShadow)
        
        let customAlertConfirmButton = UIButton(frame: CGRectMake(150, 75, 90, 35))
        customAlertConfirmButton.layer.cornerRadius = 7
        customAlertConfirmButton.backgroundColor = UIColor(red: 0.93, green: 0.2, blue: 0.2, alpha: 1)
        customAlertConfirmButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        //        customAlertButton.setTitleColor(UIColor(red: 0.64, green: 0.84, blue: 0.96, alpha: 1), forState: .Normal)
        customAlertConfirmButton.setTitle("CONFIRM", forState: .Normal)
        customAlertConfirmButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        customAlertConfirmButton.addTarget(self, action: "customAlertConfirmButtonPressed:", forControlEvents: .TouchUpInside)
        customAlertView.addSubview(customAlertConfirmButton)
        
        let customAlertCancelShadow = UIImageView(frame: CGRectMake(30, 78, 90, 35))
        customAlertCancelShadow.layer.cornerRadius = 7
        customAlertCancelShadow.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        customAlertView.addSubview(customAlertCancelShadow)
        
        let customAlertCancelButton = UIButton(frame: CGRectMake(30, 75, 90, 35))
        customAlertCancelButton.layer.cornerRadius = 7
        customAlertCancelButton.backgroundColor = UIColor.whiteColor()
        customAlertCancelButton.setTitleColor(UIColor(red: 0.93, green: 0.2, blue: 0.2, alpha: 1), forState: .Normal)
        //        customAlertButton.setTitleColor(UIColor(red: 0.64, green: 0.84, blue: 0.96, alpha: 1), forState: .Normal)
        customAlertCancelButton.setTitle("CANCEL", forState: .Normal)
        customAlertCancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        customAlertCancelButton.addTarget(self, action: "customAlertCancelButtonPressed:", forControlEvents: .TouchUpInside)
        customAlertView.addSubview(customAlertCancelButton)
    }
    
    func customAlertCancelButtonPressed(sender: UIButton) {
        self.view.subviews.last?.removeFromSuperview()
        setButtonLabelStatus(true)
    }
    
    func customAlertConfirmButtonPressed(sender: UIButton) {
        self.view.subviews.last?.removeFromSuperview()
        
        let deletingSpinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView
        deletingSpinner.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        deletingSpinner.layer.cornerRadius = 7
        deletingSpinner.center = self.view.center
        deletingSpinner.hidesWhenStopped = true
        deletingSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(deletingSpinner)
        deletingSpinner.startAnimating()
        
        self.deleteButton.setTitle("DELETING", forState: .Normal)
        setButtonLabelStatus(false)
        
        let gameObject = PFObject(className: "GameSets")
        gameObject.objectId = gameObjectID
        gameObject.fetchInBackgroundWithBlock() {
            (objects: PFObject?, error: NSError?) -> Void in
            if objects != nil {
                objects?.setObject(true, forKey: "hidden")
//                objects?.removeObjectForKey("creatorUserID")
                objects?.saveInBackgroundWithBlock() {
                    (success: Bool, error: NSError?) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        deletingSpinner.stopAnimating()
                        self.dismissViewControllerAnimated(true) {
                            Void in
                            self.delegate.gameWasDeleted()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func deleteButtonPressed(sender: UIButton) {
        createCustomAlert("Are you sure you want to delete this set?")
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

