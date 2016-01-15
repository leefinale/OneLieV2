//
//  PlayViewController.swift
//  OneLieV2
//
//  Created by Elex Lee on 12/19/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import Parse
import ParseUI
import iAd
import UIKit
import FBSDKCoreKit

class PlayViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var gameImageView: PFImageView!
    
    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
    @IBOutlet weak var buttonThree: UIButton!
    
    @IBOutlet weak var buttonOneShadowImageView: UIImageView!
    @IBOutlet weak var buttonTwoShadowImageView: UIImageView!
    @IBOutlet weak var buttonThreeShadowImageView: UIImageView!
    
    @IBOutlet weak var gameHeader: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var returnHomeShadowImageView: UIImageView!
    @IBOutlet weak var playAgainShadowImageView: UIImageView!
    
    @IBOutlet weak var returnHomeButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var scoreStreakLabel: UILabel!
    
    var gameArray: [String]?
    var answerKey: Int?
    var gameObjectID: String?
    var gameResult: [String:Bool]?
    var gamesPlayed: [String]?
    var userScoreTotal: Int?
    var userScoreConsecutive: Int?
    
    var querySpinner: UIActivityIndicatorView?
    var newGameSpinner: UIActivityIndicatorView?
    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to our app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.gameButtonsShouldHide(true)
        
        querySpinner = UIActivityIndicatorView()
        newGameSpinner = UIActivityIndicatorView()

        gameResult = [String:Bool]()
        gamesPlayed = [String]()
        
        
        createGame()
        
        parseQueryCurrentUser()
        
        gameImageView.clipsToBounds = true
        gameImageView.layer.borderColor = UIColor.whiteColor().CGColor
        gameImageView.layer.borderWidth = 3
        gameImageView.layer.cornerRadius = 7
        
        gameButtonFormat(buttonOne, inputShadow: buttonOneShadowImageView)
        gameButtonFormat(buttonTwo, inputShadow: buttonTwoShadowImageView)
        gameButtonFormat(buttonThree, inputShadow: buttonThreeShadowImageView)
        
        returnHomeButtonFormat(returnHomeButton, inputShadow: returnHomeShadowImageView)
        playAgainButtonFormat(playAgainButton, inputShadow: playAgainShadowImageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        Ads.sharedInstance.showBannerAd(self)
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewWillDisappear(animated: Bool) {
        Ads.sharedInstance.removeBannerAds(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func gameButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1), forState: .Normal)
        
        inputButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        inputShadow.layer.cornerRadius = 7
    }
    
    func playAgainButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
//        old green color for button
//        UIColor(red: 0.65, green: 0.8, blue: 0.27, alpha: 1)
        inputButton.backgroundColor = lightColor(3)
        inputButton.layer.cornerRadius = 7
        
//        old green color for border
//        UIColor(red: 0.44, green: 0.7, blue: 0.22, alpha: 1)
        inputShadow.backgroundColor = darkColor(3)
        inputShadow.layer.cornerRadius = 7
    }
    
    func returnHomeButtonFormat(inputButton: UIButton, inputShadow: UIImageView) {
        inputButton.setTitleColor(lightColor(2), forState: .Normal)
        
        inputButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        inputButton.layer.cornerRadius = 7
        
        inputShadow.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        inputShadow.layer.cornerRadius = 7
    }

    func createGame() {
        resultButtonsShouldHide(true)
        resultView.hidden = true
        gameHeader.hidden = true
        gameArray = [String]()
    }
    
    func grabGame(completion: (resultArray: [String]) -> Void) {
        let query = PFQuery(className: "GameSets")
        query.whereKey("objectId", notContainedIn: gamesPlayed!)
        query.whereKey("hidden", notEqualTo: true)
        query.whereKey("creatorUserID", notEqualTo: FBSDKAccessToken.currentAccessToken().userID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            print("number of games not played \(objects?.count)")
            if objects?.count == 0 {
                // THIS IS IF USER HAS PLAYED ALL AVAILABLE GAMES
                self.newGameSpinner?.stopAnimating()
                
                let randNum = Int(arc4random_uniform(4))
                
                let noGamesView = UIView(frame: CGRectMake(0, 0, 250, 135))
                noGamesView.layer.cornerRadius = 7
                noGamesView.backgroundColor = self.lightColor(randNum)
                noGamesView.layer.borderWidth = 3
                noGamesView.layer.borderColor = self.darkColor(randNum).CGColor
                noGamesView.center = self.view.center
                self.view.addSubview(noGamesView)
                
                let noGamesText = UITextView(frame: CGRectMake(0, 10, 250, 70))
                noGamesText.userInteractionEnabled = false
                noGamesText.text = "You've played all \n available games!"
                noGamesText.textColor = UIColor.whiteColor()
                noGamesText.backgroundColor = UIColor.clearColor()
                noGamesText.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
                noGamesText.textAlignment = .Center
                noGamesView.addSubview(noGamesText)
                
                let noGamesButtonShadow = UIImageView(frame: CGRectMake(35, 78, 180, 35))
                noGamesButtonShadow.layer.cornerRadius = 7
                noGamesButtonShadow.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
                noGamesView.addSubview(noGamesButtonShadow)
                
                let noGamesButton = UIButton(frame: CGRectMake(35, 75, 180, 35))
                noGamesButton.layer.cornerRadius = 7
                noGamesButton.backgroundColor = UIColor.whiteColor()
                noGamesButton.setTitleColor(self.lightColor(randNum), forState: .Normal)
                noGamesButton.setTitle("OK", forState: .Normal)
                noGamesButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 19)
                noGamesButton.addTarget(self, action: "noGamesButtonPressed:", forControlEvents: .TouchUpInside)
                noGamesView.addSubview(noGamesButton)
                
                print("You've played all games")
//                let noGamesAlert = UIAlertController(title: "You've played all available games!", message: nil, preferredStyle: .Alert)
//                
//                let confirmAction = UIAlertAction(title: "Ok", style: .Default) { [unowned self] (action: UIAlertAction!) in
//                    self.navigationController?.popViewControllerAnimated(true)
//                }
//                noGamesAlert.addAction(confirmAction)
//                self.presentViewController(noGamesAlert, animated: true, completion: nil)
            } else if error == nil && objects != nil {
                // The find succeeded.
                if let object = objects {
                    let gameChooser = Int(arc4random_uniform(UInt32(object.count)))
                    print("randomized game state number \(gameChooser)")
                    self.gameObjectID = object[gameChooser].objectId! as String
                    print("game object ID \(self.gameObjectID!)")
                    
                    self.gameImageView.file = object[gameChooser]["gameImage"] as? PFFile
                    self.gameImageView.loadInBackground()
                    
                    self.gameArray = object[gameChooser]["gameStrings"] as? [String]
                    print("current game array \(self.gameArray!)")
                    completion(resultArray: self.gameArray!)
                }
                // Do something with the found objects
            } else {
                // Log details of the failure
                print(error)
            }
        }
    }
    
    func noGamesButtonPressed(sender: UIButton!) {
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    func gameButtonsShouldHide(input: Bool) {
        buttonOne.hidden = input
        buttonTwo.hidden = input
        buttonThree.hidden = input
        
        buttonOneShadowImageView.hidden = input
        buttonTwoShadowImageView.hidden = input
        buttonThreeShadowImageView.hidden = input
        
        buttonOne.enabled = !input
        buttonTwo.enabled = !input
        buttonThree.enabled = !input
    }
    
    func resultButtonsShouldHide(input: Bool) {
        resultLabel.hidden = input
        playAgainButton.hidden = input
        returnHomeButton.hidden = input
        playAgainShadowImageView.hidden = input
        returnHomeShadowImageView.hidden = input
    }
    
    func parsePostResultsToCurrentUser(gameID: String, result: Bool) {
        let myUser: PFUser = PFUser.currentUser()!
        self.gameResult![gameID] = result
        myUser.setObject(self.gameResult!, forKey: "gameResults")
        if gamesPlayed == nil {
            gamesPlayed = [String]()
        }
        gamesPlayed!.append(gameID)
        myUser.setObject(gamesPlayed!, forKey: "gamesPlayed")
        if result {
            if userScoreTotal == nil {
                userScoreTotal = 0
            }
            if userScoreConsecutive == nil {
                userScoreConsecutive = 0
            }
            userScoreConsecutive! += 1
            userScoreTotal! += 1
            myUser.setObject(userScoreTotal!, forKey: "scoreTotal")
            myUser.setObject(userScoreConsecutive!, forKey: "consecutiveTotal")
        } else if !result {
            userScoreConsecutive = 0
            myUser.setObject(userScoreConsecutive!, forKey: "consecutiveTotal")
        }
        myUser.saveInBackgroundWithBlock {
            (success:Bool, error:NSError?) -> Void in
            if(success)
            {
                print("User details are now updated")
            }
        }
    }
    
    func parseQueryCurrentUser() {
        newGameSpinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView
        newGameSpinner!.layer.cornerRadius = 7
        newGameSpinner!.center = self.view.center
        newGameSpinner!.hidesWhenStopped = true
        newGameSpinner!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(newGameSpinner!)
        newGameSpinner!.startAnimating()
        
        let query: PFQuery = PFUser.query()!
        query.whereKey("userID", containsString: FBSDKAccessToken.currentAccessToken().userID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil && objects != nil {
                print("user details \(objects!)")
                for object in objects! {
                    if let queryGameResults = object["gameResults"] {
                        self.gameResult = queryGameResults as? [String:Bool]
                        print("user game results \(self.gameResult)")
                    }
                    self.gamesPlayed = object["gamesPlayed"] as? [String]
                    if let queryGamesPlayed = object["gamesPlayed"] {
                        self.gamesPlayed = queryGamesPlayed as? [String]
                        print("games user has played \(self.gamesPlayed)")
                    } else {
                        self.gamesPlayed = []
                    }
                    if let queryScoreTotal = object["scoreTotal"] {
                        self.userScoreTotal = queryScoreTotal as? Int
                        print("user total score \(self.userScoreTotal)")
                    }
                    if let queryScoreConsecutive = object["consecutiveTotal"] {
                        self.userScoreConsecutive = queryScoreConsecutive as? Int
                        print("user consecutive score \(self.userScoreTotal)")
                    }
                    self.grabGame() {
                        (resultArray: [String]) in
                        randomize(resultArray) {
                            (randomizedArray: Array<String>, answerKey: Int) in
                            self.gameArray = randomizedArray
                            self.answerKey = answerKey
                            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                                self.buttonOne.setTitle(randomizedArray[0], forState: .Normal)
                                self.buttonTwo.setTitle(randomizedArray[1], forState: .Normal)
                                self.buttonThree.setTitle(randomizedArray[2], forState: .Normal)
                                self.gameButtonsShouldHide(false)
                                self.gameHeader.text = "FIND THE LIE"
                                self.gameHeader.hidden = false
                                self.newGameSpinner!.stopAnimating()
                            }
                        }
                    }
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
    
    func customizeResultView(inputView: UIView, win: Bool) {
        let randNum = Int(arc4random_uniform(4))
        inputView.layer.cornerRadius = 7
        inputView.layer.borderWidth = 3
        inputView.layer.borderColor = darkColor(randNum).CGColor
        inputView.backgroundColor = lightColor(randNum)
        inputView.hidden = false
        if win {
            if let streak = self.userScoreConsecutive {
                scoreStreakLabel.text = String(streak + 1)
            } else {
                scoreStreakLabel.text = "1"
            }
        } else {
            scoreStreakLabel.text = "0"
        }
    }
    
    @IBAction func imagePressed(sender: UIButton) {
        let popoverImage = (self.storyboard?.instantiateViewControllerWithIdentifier("ImagePopover"))! as! LargeGameImageViewController
        popoverImage.modalPresentationStyle = .Custom
        presentViewController(popoverImage, animated: false) {
            () in
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                popoverImage.largeGameImageView.image = self.gameImageView.image
            }
        }
    }
    
    @IBAction func buttonOnePressed(sender: UIButton) {
        gameHeader.text = "YOU ARE"
        if answerKey == 0 {
            customizeResultView(resultView, win: true)
            parsePostResultsToCurrentUser(gameObjectID!, result: true)
            gameButtonsShouldHide(true)
            resultLabel.text = "CORRECT"
            resultButtonsShouldHide(false)
        } else {
            customizeResultView(resultView, win: false)
            parsePostResultsToCurrentUser(gameObjectID!, result: false)
            gameButtonsShouldHide(true)
            resultLabel.text = "INCORRECT"
            resultLabel.hidden = false
            resultButtonsShouldHide(false)
        }
    }
    
    @IBAction func buttonTwoPressed(sender: UIButton) {
        gameHeader.text = "YOU ARE"
        if answerKey == 1 {
            customizeResultView(resultView, win: true)
            parsePostResultsToCurrentUser(gameObjectID!, result: true)
            gameButtonsShouldHide(true)
            resultLabel.text = "CORRECT"
            resultLabel.hidden = false
            resultButtonsShouldHide(false)
        } else {
            customizeResultView(resultView, win: false)
            parsePostResultsToCurrentUser(gameObjectID!, result: false)
            gameButtonsShouldHide(true)
            resultLabel.text = "INCORRECT"
            resultLabel.hidden = false
            resultButtonsShouldHide(false)
        }
    }
    
    @IBAction func buttonThreePressed(sender: UIButton) {
        gameHeader.text = "YOU ARE"
        if answerKey == 2 {
            customizeResultView(resultView, win: true)
            parsePostResultsToCurrentUser(gameObjectID!, result: true)
            gameButtonsShouldHide(true)
            resultLabel.text = "CORRECT"
            resultLabel.hidden = false
            resultButtonsShouldHide(false)
        } else {
            customizeResultView(resultView, win: false)
            parsePostResultsToCurrentUser(gameObjectID!, result: false)
            gameButtonsShouldHide(true)
            resultLabel.text = "INCORRECT"
            resultLabel.hidden = false
            resultButtonsShouldHide(false)
        }
    }
    
    @IBAction func returnHomeButtonPressed(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func playAgainButton(sender: UIButton) {
        newGameSpinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 100, 100)) as UIActivityIndicatorView
        newGameSpinner!.layer.cornerRadius = 7
        newGameSpinner!.center = self.view.center
        newGameSpinner!.hidesWhenStopped = true
        newGameSpinner!.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.addSubview(newGameSpinner!)
        newGameSpinner!.startAnimating()
        
        buttonOne.setTitle("", forState: .Normal)
        buttonTwo.setTitle("", forState: .Normal)
        buttonThree.setTitle("", forState: .Normal)
        gameImageView.file = nil
        gameImageView.image = UIImage.imageWithColor(UIColor.clearColor())
        createGame()
        self.grabGame() {
            (resultArray: [String]) in
            randomize(resultArray) {
                (randomizedArray: Array<String>, answerKey: Int) in
                self.gameArray = randomizedArray
                self.answerKey = answerKey
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.buttonOne.setTitle(randomizedArray[0], forState: .Normal)
                    self.buttonTwo.setTitle(randomizedArray[1], forState: .Normal)
                    self.buttonThree.setTitle(randomizedArray[2], forState: .Normal)
//                    self.iAdBanner.hidden = true
                    self.gameButtonsShouldHide(false)
                    self.gameHeader.text = "FIND THE LIE"
                    self.gameHeader.hidden = false
                    self.newGameSpinner!.stopAnimating()
                }
            }
        }
    }
    
}
