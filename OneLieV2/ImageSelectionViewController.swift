//
//  ImageSelectionViewController.swift
//  One Lie
//
//  Created by Elex Lee on 12/28/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import Foundation
import UIKit

protocol ImageSelectionViewControllerDelegate
{
    func sendUserChoice(var selection: String)
}

class ImageSelectionViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var upperButtonDivider: UIView!
    @IBOutlet weak var lowerButtonDivider: UIView!
    
    var dividerHeightCGFloat: CGFloat?
    
    var delegate: ImageSelectionViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        let randNum = Int(arc4random_uniform(4))
        cameraButton.backgroundColor = lightColor(randNum)
        galleryButton.backgroundColor = lightColor(randNum)
        cancelButton.setTitleColor(UIColor(red: 0.98, green: 0.52, blue: 0.49, alpha: 1), forState: .Normal)
    
        upperButtonDivider.backgroundColor = darkColor(randNum)
        lowerButtonDivider.backgroundColor = darkColor(randNum)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func cameraButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true) {
            Void in
            self.delegate.sendUserChoice("camera")
        }
    }
    @IBAction func galleryButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true) {
            Void in
            self.delegate.sendUserChoice("gallery")
        }
    }
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
