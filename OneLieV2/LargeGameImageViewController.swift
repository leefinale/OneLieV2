//
//  LargeGameImageViewController.swift
//  OneLieV2
//
//  Created by Elex Lee on 12/23/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import ParseUI
//import iAd
import UIKit

class LargeGameImageViewController: UIViewController {
    
    @IBOutlet weak var largeGameImageView: PFImageView!
    
//    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate // Create reference to our app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        largeGameImageView.image = UIImage.imageWithColor(UIColor.blackColor())
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissView")
        view.addGestureRecognizer(tap)
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissView() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}

extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

