//
//  FeedbackViewController.swift
//  One Lie
//
//  Created by Elex Lee on 12/31/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import FBSDKCoreKit
import Foundation
import iAd
import UIKit
import Parse
import ParseUI


class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var feedbackView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var cancelShadowImageView: UIImageView!
    @IBOutlet weak var submitShadowImageView: UIImageView!
    
    @IBOutlet weak var FeedbackViewVerticalConstraint: NSLayoutConstraint!
    
    var tap: UITapGestureRecognizer?
    var notificationCenter: NSNotificationCenter?
    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to our app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Ads.sharedInstance.presentingViewController = self

        fetchEmail()
        
        notificationCenter = NSNotificationCenter.defaultCenter()
        
        tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap!)
        
        notificationCenter!.addObserver(self, selector: "keyboardWillMove:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        notificationCenter!.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        let randNum = Int(arc4random_uniform(4))
        buttonFormat(cancelButton, inputShadow: cancelShadowImageView, inputNum: 4)
        buttonFormat(submitButton, inputShadow: submitShadowImageView, inputNum: randNum)
        cancelButton.setTitleColor(UIColor(red: 0.98, green: 0.52, blue: 0.49, alpha: 1), forState: .Normal)
        
        feedbackView.backgroundColor = lightColor(randNum)
        feedbackView.layer.cornerRadius = 7
        feedbackView.layer.borderColor = darkColor(randNum).CGColor
        feedbackView.layer.borderWidth = 3
        
        messageTextView.delegate = self
        messageTextView.layer.cornerRadius = 7
//        messageTextView.layer.borderWidth = 3
//        messageTextView.layer.borderColor = darkColor(randNum).CGColor
        messageTextView.text = "Enter your feedback here!"
        messageTextView.textColor = UIColor(red: 0.73, green: 0.73, blue: 0.76, alpha: 1)
        
//        emailTextField.layer.cornerRadius = 7
//        emailTextField.layer.borderWidth = 3
//        emailTextField.layer.borderColor = darkColor(randNum).CGColor
        
        feedbackLabel.textColor = darkColor(randNum)
    }
    
    override func viewWillAppear(animated: Bool) {
        Ads.sharedInstance.showBannerAd(self)
        if appDelegate.iAdBannerAdView != nil {
            FeedbackViewVerticalConstraint.constant -= appDelegate.iAdBannerAdView.frame.height
        } else if appDelegate.adMobBannerAdView != nil {
            FeedbackViewVerticalConstraint.constant -= appDelegate.adMobBannerAdView.frame.height
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        Ads.sharedInstance.removeBannerAds(self)
        if appDelegate.iAdBannerAdView != nil {
            FeedbackViewVerticalConstraint.constant += appDelegate.iAdBannerAdView.frame.height
        } else if appDelegate.adMobBannerAdView != nil {
            FeedbackViewVerticalConstraint.constant += appDelegate.adMobBannerAdView.frame.height
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor(red: 0.73, green: 0.73, blue: 0.76, alpha: 1) {
            textView.text = nil
            textView.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your feedback here!"
            textView.textColor = UIColor(red: 0.73, green: 0.73, blue: 0.76, alpha: 1)
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func keyboardWillMove(notification: NSNotification) {
        print("keyboard shows")
        print(notification.userInfo!)
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let constraint = notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let frameValue = constraint.CGRectValue()
        print(frameValue)
        self.view.setNeedsLayout()
        self.feedbackLabel.hidden = true
        FeedbackViewVerticalConstraint.constant = -115

        self.view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in print("")
        })
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboard hide")
        print(notification.userInfo!)
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        self.view.setNeedsLayout()
        self.feedbackLabel.hidden = false
        if appDelegate.iAdBannerAdView != nil {
            FeedbackViewVerticalConstraint.constant = 0 - appDelegate.iAdBannerAdView.frame.height
        } else if appDelegate.adMobBannerAdView != nil {
            FeedbackViewVerticalConstraint.constant = 0 - appDelegate.adMobBannerAdView.frame.height
        }

        self.view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in print("")
        })
    }
    
    
    func changeAllFieldStatus(input: Bool) {
        emailTextField.enabled = input
        messageTextView.editable = input
        submitButton.enabled = input
        cancelButton.enabled = input
    }
    
    func saveFeedbackToParse() {
        let savingSpinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView
        savingSpinner.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        savingSpinner.layer.cornerRadius = 7
        savingSpinner.center = self.view.center
        savingSpinner.hidesWhenStopped = true
        savingSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(savingSpinner)
        savingSpinner.startAnimating()
        
        self.submitButton.setTitle("SUBMITTING", forState: .Normal)
        changeAllFieldStatus(false)
        
        let feedbackObject = PFObject(className: "Feedback")
        feedbackObject.setObject(messageTextView.text, forKey: "userFeedback")
        feedbackObject.setObject(emailTextField.text!, forKey: "email")
        feedbackObject.setObject(FBSDKAccessToken.currentAccessToken().userID, forKey: "userID")
        feedbackObject.saveInBackgroundWithBlock() {
            (success: Bool, error: NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                savingSpinner.stopAnimating()
                self.dismissViewControllerAnimated(true, completion:  nil)
            }
        }
    }
    
    func fetchEmail() {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if let email = result.valueForKey("email") {
                print(email)
                self.emailTextField.text = (email as? String)!
            }
        })
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        saveFeedbackToParse()
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
