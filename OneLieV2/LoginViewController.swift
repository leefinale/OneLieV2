//
//  LoginViewController.swift
//  One Lie
//
//  Created by Elex Lee on 12/27/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logInShadowImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
//        self.view.center = loginView.view.center
//        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
//        loginButton.delegate = self
//        presentViewController(loginView, animated: true, completion: nil)
        
        buttonFormat(logInButton, inputShadow: logInShadowImageView)
    }
    
    func buttonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        let randNum = Int(arc4random_uniform(4))
        
        inputButton.backgroundColor = lightColor(randNum)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = darkColor(randNum)
        inputShadow.layer.cornerRadius = 7
    }
    
//    override func viewDidAppear(animated: Bool) {
//        let loginView : FBSDKLoginButton = FBSDKLoginButton()
//        self.view.addSubview(loginView)
//        loginView.center = self.view.center
//        loginView.readPermissions = ["public_profile", "email", "user_friends"]
//        loginView.delegate = self
//    }
//    
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        print("User Logged In")
//        if ((error) != nil)
//        {
//            // Process error
//        }
//        else if result.isCancelled {
//            // Handle cancellations
//        }
//        else {
//            // If you ask for multiple permissions at once, you
//            // should check if specific permissions missing
//            if result.grantedPermissions.contains("email")
//            {
//                // Do work
//                print(result)
//                dismissViewControllerAnimated(true, completion: nil)
//            }
//        }
//    }
    
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
//        print("User Logged Out")
//    }
    
    
    func requestFacebook() {
        let requestParameters = ["fields": "id, email, first_name, last_name"]
        
        
        let userDetails = FBSDKGraphRequest(graphPath: "me", parameters: requestParameters)
        
        userDetails.startWithCompletionHandler { (connection, result, error:NSError!) -> Void in
            
            if(error != nil)
            {
                print("\(error.localizedDescription)")
                return
            }
            
            if(result != nil)
            {
                
                let userId: String = result["id"] as! String
                let userFirstName: String? = result["first_name"] as? String
                let userLastName: String? = result["last_name"] as? String
                let userEmail: String? = result["email"] as? String
                
                
                print("\(userEmail)")
                
                let myUser: PFUser = PFUser.currentUser()!
                
                myUser.setObject(userId, forKey: "userID")
                
                // Save first name
                if userFirstName != nil {
                    myUser.setObject(userFirstName!, forKey: "first_name")
                    
                }
                
                //Save last name
                if userLastName != nil {
                    myUser.setObject(userLastName!, forKey: "last_name")
                }
                
                // Save email address
                if userEmail != nil {
                    myUser.setObject(userEmail!, forKey: "email")
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    // Get Facebook profile picture
                    let userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                    
                    let profilePictureUrl = NSURL(string: userProfile)
                    
                    let profilePictureData = NSData(contentsOfURL: profilePictureUrl!)
                    
                    if profilePictureData != nil {
                        let profileFileObject = PFFile(data:profilePictureData!)
                        myUser.setObject(profileFileObject!, forKey: "profile_picture")
                    }
                    
                    myUser.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        
                        if(success)
                        {
                            print("User details are now updated")
                        }
                        
                    })
                    
                }
                
            }
            
        }
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
    
    @IBAction func logInButtonPressed(sender: UIButton) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile","email"], block: { (user:PFUser?, error:NSError?) -> Void in
            if(error != nil)
            {
                //Display an alert message
                let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                
                let okAction =  UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction);
                self.presentViewController(myAlert, animated:true, completion:nil);
                
                return
            }
            print(user)
//            print("Current user token=\(FBSDKAccessToken.currentAccessToken().tokenString)")
//            print("Current user id \(FBSDKAccessToken.currentAccessToken().userID)")
            self.requestFacebook()
            
            if(FBSDKAccessToken.currentAccessToken() != nil)
            {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
}
