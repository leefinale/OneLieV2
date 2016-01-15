//
//  GameEditDetailViewController.swift
//  One Lie
//
//  Created by Elex Lee on 12/30/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI
import FBSDKCoreKit

protocol GameEditDetailViewControllerDelegate
{
    func changesWereSaved()
}

class GameEditDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageSelectionViewControllerDelegate {
    
    @IBOutlet weak var gameImageView: PFImageView!
    
    @IBOutlet weak var truthOneButton: UIButton!
    @IBOutlet weak var truthTwoButton: UIButton!
    @IBOutlet weak var lieOneButton: UIButton!

    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var truthOneShadowImageView: UIImageView!
    @IBOutlet weak var truthTwoShadowImageView: UIImageView!
    @IBOutlet weak var lieOneShadowImageView: UIImageView!
    
    @IBOutlet weak var saveButtonShadowImageView: UIImageView!
    @IBOutlet weak var cancelButtonShadowImageView: UIImageView!
    
    var imagePicker: UIImagePickerController?
    var customAlertText: UITextField?
    var chosenTextField: Int?
    
    var gameStrings: [String]?
    var gameObjectID: String?
    
    var delegate: GameEditDetailViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker!.delegate = self
        
        gameImageView.layer.cornerRadius = 7
        gameImageView.clipsToBounds = true
        gameImageView.layer.borderWidth = 3
        gameImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        truthOneButton.setTitle("", forState: .Normal)
        truthTwoButton.setTitle("", forState: .Normal)
        lieOneButton.setTitle("", forState: .Normal)
        
        gameButtonFormat(truthOneButton, inputShadow: truthOneShadowImageView)
        gameButtonFormat(truthTwoButton, inputShadow: truthTwoShadowImageView)
        gameButtonFormat(lieOneButton, inputShadow: lieOneShadowImageView)
        saveButtonFormat(saveButton, inputShadow: saveButtonShadowImageView)
        cancelButtonFormat(cancelButton, inputShadow: cancelButtonShadowImageView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    func saveButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        inputButton.backgroundColor = lightColor(3)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = darkColor(3)
        inputShadow.layer.cornerRadius = 7
    }
    
    func cancelButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(UIColor(red: 0.93, green: 0.2, blue: 0.2, alpha: 1), forState: .Normal)
        
        inputButton.backgroundColor = lightColor(4)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = darkColor(4)
        inputShadow.layer.cornerRadius = 7
    }
    
    func gameButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1), forState: .Normal)
        
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
        truthOneButton.enabled = input
        truthTwoButton.enabled = input
        lieOneButton.enabled = input
        saveButton.enabled = input
        cancelButton.enabled = input
    }
    
    func createCustomAlert(alertMessage: String) {
        setButtonLabelStatus(false)
        
        let customAlertView = UIView(frame: CGRectMake(0, 0, 270, 135))
        customAlertView.layer.cornerRadius = 7
//        customAlertView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        customAlertView.backgroundColor = UIColor(red: 0.98, green: 0.82, blue: 0.64, alpha: 1)
//        customAlertView.backgroundColor = UIColor(red: 0.64, green: 0.84, blue: 0.96, alpha: 1)
        customAlertView.layer.borderWidth = 3
        customAlertView.layer.borderColor = UIColor(red: 0.96, green: 0.73, blue: 0.44, alpha: 1).CGColor
//        customAlertView.layer.borderColor = UIColor(red: 0.4, green: 0.65, blue: 0.77, alpha: 1).CGColor
        customAlertView.center = self.view.center
        self.view.addSubview(customAlertView)
        
        customAlertText = UITextField(frame: CGRectMake(10, 25, 250, 35))
        customAlertText!.userInteractionEnabled = true
        customAlertText!.borderStyle = UITextBorderStyle.RoundedRect
        customAlertText!.placeholder = alertMessage
        customAlertText!.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1)
        customAlertText!.font = UIFont(name: "HelveticaNeue-Bold", size: 13)
        customAlertText!.textAlignment = .Center
        customAlertView.addSubview(customAlertText!)
        
        let customAlertConfirmShadow = UIImageView(frame: CGRectMake(150, 78, 90, 35))
        customAlertConfirmShadow.layer.cornerRadius = 7
        customAlertConfirmShadow.backgroundColor = UIColor(red: 0.41, green: 0.74, blue: 0.55, alpha: 1)
        customAlertView.addSubview(customAlertConfirmShadow)
    
        let customAlertConfirmButton = UIButton(frame: CGRectMake(150, 75, 90, 35))
        customAlertConfirmButton.layer.cornerRadius = 7
        customAlertConfirmButton.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.62, alpha: 1)
        customAlertConfirmButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        customAlertButton.setTitleColor(UIColor(red: 0.64, green: 0.84, blue: 0.96, alpha: 1), forState: .Normal)
        customAlertConfirmButton.setTitle("OK", forState: .Normal)
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
        customAlertCancelButton.setTitleColor(UIColor(red: 0.98, green: 0.52, blue: 0.49, alpha: 1), forState: .Normal)
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
        print(sender)
        if !checkForBlankFields() {
            if chosenTextField! == 1 {
                truthOneButton.setTitle(customAlertText?.text, forState: .Normal)
            } else if chosenTextField! == 2 {
                truthTwoButton.setTitle(customAlertText?.text, forState: .Normal)
            } else if chosenTextField! == 3 {
                lieOneButton.setTitle(customAlertText?.text, forState: .Normal)
            }
            self.view.subviews.last?.removeFromSuperview()
            setButtonLabelStatus(true)
        }
    }
    
    func checkForBlankFields() -> Bool {
        if customAlertText?.text == "" {
            customAlertText?.text = "Field cannot be blank!"
            return true
        } else if customAlertText?.text?.characters.count > 40 {
            customAlertText?.text = "Maximum 40 characters!"
            return true
        }
        return false
    }
    
    @IBAction func editImagePressed(sender: UIButton) {
        let imageSelection = self.storyboard?.instantiateViewControllerWithIdentifier("ImageSelectionViewController") as! ImageSelectionViewController
        imageSelection.delegate = self
        imageSelection.modalPresentationStyle = .Custom
        self.presentViewController(imageSelection, animated: true) {
            Void in
            imageSelection.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        }
    }
    
    @IBAction func truthOnePressed(sender: UIButton) {
        createCustomAlert("New Truth")
        chosenTextField = 1
    }
    
    @IBAction func truthTwoPressed(sender: UIButton) {
        createCustomAlert("New Truth")
        chosenTextField = 2
    }
    
    @IBAction func lieOnePressed(sender: UIButton) {
        createCustomAlert("New Lie")
        chosenTextField = 3
    }
    
    @IBAction func saveButtonPressed(sender: UIButton) {
        let savingSpinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView
        savingSpinner.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        savingSpinner.layer.cornerRadius = 7
        savingSpinner.center = self.view.center
        savingSpinner.hidesWhenStopped = true
        savingSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(savingSpinner)
        savingSpinner.startAnimating()
        
        self.saveButton.setTitle("SAVING", forState: .Normal)
        setButtonLabelStatus(false)
        
        gameStrings = [String]()
        
        gameStrings!.append((truthOneButton.titleLabel?.text)!)
        gameStrings!.append((truthTwoButton.titleLabel?.text)!)
        gameStrings!.append((lieOneButton.titleLabel?.text)!)
        
        let gameObject = PFObject(className: "GameSets")
        gameObject.objectId = gameObjectID
        gameObject.setObject(gameStrings!, forKey: "gameStrings")
        gameObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("gameArray has been saved! Now saving image data")
            let userImage = UIImagePNGRepresentation(self.gameImageView.image!)
            let parseImageFile =  PFFile(data: userImage!)
            gameObject.setObject(parseImageFile!, forKey: "gameImage")
            gameObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    savingSpinner.stopAnimating()
                    self.dismissViewControllerAnimated(true) {
                        Void in
                        self.delegate.changesWereSaved()
                    }
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

