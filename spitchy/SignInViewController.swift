//
//  SignInViewController.swift
//  Spitchy
//
//  Created by Rplay on 02/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    let colors = Colors()
    
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var logo: UIImageView!
    @IBOutlet var baseline: UILabel!
    @IBOutlet var hashtag: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        animateImageView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let images = [
        UIImage(named: "topic-economy"),
        UIImage(named: "topic-politique"),
        UIImage(named: "topic-sport")
    ]
    
    let hashtags = [
        "#économie",
        "#politique",
        "#sport"
    ]
    
    var index = 0
    let animationDuration: NSTimeInterval = 0.25
    let switchingInterval: NSTimeInterval = 4
    
    func animateImageView() {
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(self.switchingInterval * NSTimeInterval(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                self.animateImageView()
            }
        }
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        /*
         transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromRight
         */
        backgroundImage.layer.addAnimation(transition, forKey: kCATransition)
        backgroundImage.image = images[index]
        hashtag.text = hashtags[index]
        
        CATransaction.commit()
        
        index = index < images.count - 1 ? index + 1 : 0
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
    
    func design() {
        let loginWithAttributes = [ NSFontAttributeName: UIFont(name: "Lato-Regular", size: 18.0)! ]
        let loginWithString = NSMutableAttributedString(string: "Sign in with", attributes: loginWithAttributes )
        
        let facebookAttributes = [ NSFontAttributeName: UIFont(name : "Lato-Bold", size: 18.0)!]
        let facebookString = NSMutableAttributedString(string: " Facebook", attributes: facebookAttributes)
        
        loginWithString.appendAttributedString(facebookString)
        
        
        signInButton.setAttributedTitle(loginWithString, forState: .Normal)
        signInButton.backgroundColor = colors.green
        signInButton.tintColor = colors.white
        signInButton.layer.cornerRadius = 4.0
        signInButton.layer.shadowColor = UIColor.blackColor().CGColor
        signInButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        signInButton.layer.shadowOpacity = 0.5
        signInButton.layer.shadowRadius = 1.0
        
        baseline.font = UIFont(name: "Lato-Regular", size: 20)
        baseline.textColor = colors.white
        baseline.text = "Réagis à l'actualité."
        
        hashtag.font = UIFont(name: "Lato-Bold", size: 20)
        hashtag.textColor = colors.white
        hashtag.text = "#économie"
    }
    
}



