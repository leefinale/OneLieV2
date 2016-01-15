//
//  CreateViewController.swift
//  OneLieV2
//
//  Created by Elex Lee on 12/19/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import UIKit
import iAd
import FBSDKCoreKit
import Parse

protocol CreateViewControllerDelegate {
    func setWasCreated()
}

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageSelectionViewControllerDelegate {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    
    @IBOutlet weak var truthOne: UITextField!
    @IBOutlet weak var truthTwo: UITextField!
    @IBOutlet weak var lieOne: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var cancelShadowImageView: UIImageView!
    @IBOutlet weak var submitShadowImageView: UIImageView!
    
    
    @IBOutlet weak var submitToViewHeight: NSLayoutConstraint!
    
    var imagePicker: UIImagePickerController?
    
    var tap: UITapGestureRecognizer?
    var notificationCenter: NSNotificationCenter?
    
    var gameArray: [String]?
    
    var delegate: CreateViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        
        notificationCenter = NSNotificationCenter.defaultCenter()
        
        tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap!)
        notificationCenter!.addObserver(self, selector: "keyboardWillMove:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        notificationCenter!.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        gameArray = ["", "", ""]
        
        gameImageView.clipsToBounds = true
//        gameImageView.layer.borderColor = UIColor(red: 0.98, green: 0.82, blue: 0.64, alpha: 1).CGColor
        gameImageView.layer.borderColor = UIColor.whiteColor().CGColor
        gameImageView.layer.borderWidth = 3
        gameImageView.layer.cornerRadius = 7
        
        requestFacebookProfilePicture()
        
        submitButtonFormat(submitButton, inputShadow: submitShadowImageView)
        returnHomeButtonFormat(cancelButton, inputShadow: cancelShadowImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if UIScreen.mainScreen().bounds.height < 570 {
            submitToViewHeight.constant = 50
        } else if UIScreen.mainScreen().bounds.height < 670 {
            submitToViewHeight.constant = 75
        } else {
            submitToViewHeight.constant = 100
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        UIViewController.prepareInterstitialAds()
    }
    
    func submitButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
//        inputButton.backgroundColor = UIColor(red: 0.65, green: 0.8, blue: 0.27, alpha: 1)
        inputButton.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.62, alpha: 1)
        inputButton.layer.cornerRadius = 7
        
//        inputShadow.backgroundColor = UIColor(red: 0.44, green: 0.7, blue: 0.22, alpha: 1)
        inputShadow.backgroundColor = UIColor(red: 0.41, green: 0.74, blue: 0.55, alpha: 1)
        inputShadow.layer.cornerRadius = 7
    }
    
    func returnHomeButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
//        inputButton.setTitleColor(UIColor(red: 0.93, green: 0.2, blue: 0.2, alpha: 1), forState: .Normal)
        inputButton.setTitleColor(UIColor(red: 0.98, green: 0.52, blue: 0.49, alpha: 1), forState: .Normal)
        
        inputButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        inputShadow.layer.cornerRadius = 7
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            gameImageView.contentMode = .ScaleAspectFill
            gameImageView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func presentImagePicker() {
        presentViewController(imagePicker!, animated: true, completion: nil)
    }
    
    func sendUserChoice(selection: String) {
        print(selection)
        setImagePickerUsingUserSelection(selection)
    }
    
    func setImagePickerUsingUserSelection(userSelection: String) {
        if userSelection == "camera" {
            self.imagePicker!.allowsEditing = true
            self.imagePicker!.sourceType = .Camera
            self.imagePicker!.modalPresentationStyle = .Popover
            self.presentImagePicker()
        } else if userSelection == "gallery" {
            self.imagePicker!.allowsEditing = true
            self.imagePicker!.sourceType = .PhotoLibrary
            self.imagePicker!.modalPresentationStyle = .Popover
            self.presentImagePicker()
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
        self.gameImageView.hidden = true
        self.editImageButton.hidden = true
        self.submitToViewHeight.constant = frameValue.height + 45
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
        self.gameImageView.hidden = false
        self.editImageButton.hidden = false
        if UIScreen.mainScreen().bounds.height < 570 {
            submitToViewHeight.constant = 50
        } else if UIScreen.mainScreen().bounds.height < 670 {
            submitToViewHeight.constant = 75
        } else {
            submitToViewHeight.constant = 100
        }
        self.view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
            }, completion: {
                (value: Bool) in print("")
        })
    }
    
    func createAlert(inputTitle: String) {
        let blankFieldAlert = UIAlertController(title: inputTitle, message: nil, preferredStyle: .Alert)
        presentViewController(blankFieldAlert, animated: true, completion: nil)
        
        let confirm = UIAlertAction(title: "OK", style: .Default, handler: nil)
        blankFieldAlert.addAction(confirm)
    }
    
    func checkForBlankFields() -> Bool {
        truthOne.resignFirstResponder()
        truthTwo.resignFirstResponder()
        lieOne.resignFirstResponder()
        if let textTruthOne = truthOne.text {
            if textTruthOne == "" {
                createCustomAlert("You need to fill out every field!")
                return true
            } else if textTruthOne.characters.count > 40 {
                createCustomAlert("Maximum 40 characters per field!")
                return true
            }
            gameArray![0] = textTruthOne
        }
        if let textTruthTwo = truthTwo.text {
            if textTruthTwo == "" {
                createCustomAlert("You need to fill out every field!")
                return true
            } else if textTruthTwo.characters.count > 40 {
                createCustomAlert("Maximum 40 characters per field!")
                return true
            }
            gameArray![1] = textTruthTwo
        }
        if let textLie = lieOne.text {
            if textLie == "" {
                createCustomAlert("You need to fill out every field!")
                return true
            } else if textLie.characters.count > 40 {
                createCustomAlert("Maximum 40 characters per field!")
                return true
            }
            gameArray![2] = textLie
        }
        if gameImageView.image == nil {
            createCustomAlert("Don't forget to add a picture!")
            return true
        }
        return false
    }
    
    func requestFacebookProfilePicture() {
        let graphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if error != nil {
                print(error)
            } else {
                print("happy feet")
                var profilePictureURL: NSURL
                if let data = result["data"] {
                    if let url = data["url"] {
                        print(url)
                        let stringURL = String(url)
                        print(stringURL)
                        profilePictureURL = NSURL(string: stringURL)!
                        self.downloadImage(profilePictureURL)
                    }
                }
            }
        })
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL) {
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.gameImageView.image = UIImage(data: data)!
            }
        }
    }
    
    func setButtonLabelStatus(input: Bool) {
        self.submitButton.enabled = input
        self.truthOne.enabled = input
        self.truthTwo.enabled = input
        self.lieOne.enabled = input
        self.cancelButton.enabled = input
        self.editImageButton.enabled = input
    }
    
    func createCustomAlert(alertMessage: String) {
        setButtonLabelStatus(false)
        
        let randNum = Int(arc4random_uniform(4))
        
        let customAlertView = UIView(frame: CGRectMake(0, 0, 250, 135))
        customAlertView.layer.cornerRadius = 7
        customAlertView.backgroundColor = lightColor(randNum)
//        customAlertView.backgroundColor = UIColor(red: 0.64, green: 0.84, blue: 0.96, alpha: 1)
        customAlertView.layer.borderWidth = 3
        customAlertView.layer.borderColor = darkColor(randNum).CGColor
//        customAlertView.layer.borderColor = UIColor(red: 0.4, green: 0.65, blue: 0.77, alpha: 1).CGColor
        customAlertView.center = self.view.center
        self.view.addSubview(customAlertView)
        
        let customAlertText = UITextView(frame: CGRectMake(0, 10, 250, 70))
        customAlertText.userInteractionEnabled = false
        customAlertText.text = alertMessage
        customAlertText.textColor = UIColor.whiteColor()
        customAlertText.backgroundColor = UIColor.clearColor()
        customAlertText.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
        customAlertText.textAlignment = .Center
        customAlertView.addSubview(customAlertText)
        
        let customAlertShadow = UIImageView(frame: CGRectMake(35, 78, 180, 35))
        customAlertShadow.layer.cornerRadius = 7
        customAlertShadow.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        customAlertView.addSubview(customAlertShadow)
        
        let customAlertButton = UIButton(frame: CGRectMake(35, 75, 180, 35))
        customAlertButton.layer.cornerRadius = 7
        customAlertButton.backgroundColor = UIColor.whiteColor()
        customAlertButton.setTitleColor(lightColor(randNum), forState: .Normal)
//        customAlertButton.setTitleColor(UIColor(red: 0.64, green: 0.84, blue: 0.96, alpha: 1), forState: .Normal)
        customAlertButton.setTitle("OK", forState: .Normal)
        customAlertButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
        customAlertButton.addTarget(self, action: "customAlertButtonPressed:", forControlEvents: .TouchUpInside)
        customAlertView.addSubview(customAlertButton)
    }
    
    func customAlertButtonPressed(sender: UIButton) {
        self.view.subviews.last?.removeFromSuperview()
        setButtonLabelStatus(true)
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
    
    @IBAction func changeUserImage(sender: UIButton) {
        let imageSelection = self.storyboard?.instantiateViewControllerWithIdentifier("ImageSelectionViewController") as! ImageSelectionViewController
        imageSelection.delegate = self
        imageSelection.modalPresentationStyle = .Custom
        self.presentViewController(imageSelection, animated: true) {
            Void in
            imageSelection.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        }
//        promptForImagePickerSelection()
    }
    
    @IBAction func cancelCreation(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitUserInfo(sender: UIButton) {
        if checkForBlankFields() {
            print("Not all creation conditions met")
            self.dismissKeyboard()
        } else {
            let savingSpinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView
            savingSpinner.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            savingSpinner.layer.cornerRadius = 7
            savingSpinner.center = self.view.center
            savingSpinner.hidesWhenStopped = true
            savingSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            view.addSubview(savingSpinner)
            savingSpinner.startAnimating()
    
            self.dismissKeyboard()
            
            self.submitButton.setTitle("SAVING", forState: .Normal)
            setButtonLabelStatus(false)
            
            let gameObject = PFObject(className: "GameSets")
            gameObject.setObject(gameArray!, forKey: "gameStrings")
            gameObject.setObject(FBSDKAccessToken.currentAccessToken().userID, forKey: "creatorUserID")
            gameObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                print("gameArray has been saved! Now saving image data")
                let userImage = UIImagePNGRepresentation(self.gameImageView.image!)
                let parseImageFile =  PFFile(data: userImage!)
                gameObject.setObject(parseImageFile!, forKey: "gameImage")
                gameObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        savingSpinner.stopAnimating()
                        self.dismissViewControllerAnimated(true) {
                            () -> Void in
                            self.delegate.setWasCreated()
                        }
                    }
                }
            }
        }
    }
    
}