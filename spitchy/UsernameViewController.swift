//
//  UsernameViewController.swift
//  Spitchy
//
//  Created by Kévin Rignault on 02/06/2016.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class UsernameViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let colors = Colors()
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var lastStep: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var validButton: UIButton!
    
    @IBOutlet weak var infosLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //-- Init style elements
        design()
        
        //-- Keyboard event
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UsernameViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UsernameViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        //-- Tap gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UsernameViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goAction(sender: UIButton) {
        let bridgeController = BridgeController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.presentViewController(bridgeController, animated: true, completion: nil)
    }
    
    
    func design() {
        
        print("design")
        
        //-- Main text
        lastStep.text = "Dernière étape"
        lastStep.font = UIFont(name: "Lato-BlackItalic", size: 36)
        
        usernameLabel.text = "Choisis ton nom d'utilisateur."
        usernameLabel.font = UIFont(name: "Lato-Regular", size: 14)
        
        //-- Form
        usernameInput.placeholder = "Username"
        
        validButton.layer.cornerRadius = 4.0
        validButton.titleLabel!.text = "GO !"
        validButton.titleLabel!.font = UIFont(name: "Lato-Bold", size: 18)
        
        //-- More infos
        infosLabel.text = "PS : Évite de prendre un pseudo que tu pourrais regretter parce qu’on a pas encore ajouter l’option qui permet de le changer. Et peut être qu’on ne l’ajoutera jamais :)."
        infosLabel.font = UIFont(name: "Lato-Regular", size: 14)
        
    }
    
    func keyboardWillShow(sender: NSNotification){
        let info = sender.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        print(keyboardFrame)

        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.frame.origin.y = -self.infosLabel.frame.origin.y * 2 + self.view.frame.height + 20
        })
    }
    
    func keyboardWillHide(sender: NSNotification) {
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.view.frame.origin.y = 0
        })
    }
    
    func dismissKeyboard() {
        usernameInput.endEditing(true)
    }

}