//
//  CameraViewController.swift
//  Spitchy
//
//  Created by Rplay on 05/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class CameraViewController: UIViewController {
    
    let colors = Colors()
    var session: Session?
    var preview: Preview?
    var fakeHashtags = [
        "#Poisson",
        "#CakeAuFruit",
        "#Sardine",
        "#Poney",
        "#Batiston1982",
        "#Paulette",
    ]
    
    var fakePreview: FakePreview?
    var hashtags = [HashtagModel]()
    var timer: NSTimer?
    var tap: UITapGestureRecognizer?
    
    @IBOutlet var previewLayer: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var spitchy: UILabel!
    @IBOutlet var customTopicInput: UITextField!
    @IBOutlet var liveButton: UIButton!
    @IBOutlet var topicButton: UIButton!
    @IBOutlet var waveView: UIView!
    
    @IBOutlet var waveViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var waveViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var waveViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = Session()
        preview = Preview()
        
        let sessionAudioVideo = session?.createSession()
        let previewSize = self.view.frame.size
        let previewAudioVideo = preview?.createPreview(previewSize, session: sessionAudioVideo!)
        
        previewLayer.layer.addSublayer(previewAudioVideo!)
        sessionAudioVideo?.startRunning()
        
        fakePreview = FakePreview.sharedInstance
        
        let fakeSize = CGSize(width: 200, height: 600)
        fakePreview?.createFakePreview(fakeSize)
        let previewFake = fakePreview!.preview
        
        initFakeHashtags()
        design()
        
        tableView.reloadData()
        self.waveViewBottomConstraint.constant = 40
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
        
        //-- Keyboard event
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
        initTapGesture()
        
    }
    
    func animate() {
        self.waveViewBottomConstraint.constant = 25
        self.waveViewHeightConstraint.constant = 100
        self.waveViewWidthConstraint.constant = 100
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = self.waveView.layer.cornerRadius
        animation.toValue = 50
        animation.duration = 1.5
        self.waveView.layer.addAnimation(animation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(1.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.waveView.frame.size = CGSize(width: 100, height: 100)
            self.waveView.layer.opacity = 0
            self.view.layoutIfNeeded()
            
            
            }, completion: { (finished: Bool) -> Void in
                
                self.waveView.layer.opacity = 0.6
                self.waveViewBottomConstraint.constant = 40
                self.waveViewHeightConstraint.constant = 70
                self.waveViewWidthConstraint.constant = 70
                self.waveView.layer.cornerRadius = 35
                self.view.layoutIfNeeded()
        })
    }
    
    func initFakeHashtags(){
        for hashtag in fakeHashtags {
            hashtags.append(HashtagModel(hashtag: hashtag))
        }
    }
    
    func design() {
        
        //-- Spitchy
        spitchy.font = UIFont(name: "BPreplay-BoldItalic", size: 24)
        spitchy.textColor = colors.white
        
        for family in UIFont.familyNames() {
            //print(family)
            for names in UIFont.fontNamesForFamilyName(family) {
                //print("== \(names)")
            }
        }
        
        //-- Custom Topic Input
        customTopicInput.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let customTopicInputAttributesPlaceholder = [
            NSFontAttributeName : UIFont(name : "Lato-Italic", size: 14)!,
            NSForegroundColorAttributeName : colors.white
        ]
        
        let customTopicInputAttributesText = [
            NSFontAttributeName : UIFont(name : "Lato-Regular", size: 14)!,
            NSForegroundColorAttributeName : colors.white
        ]
        
        customTopicInput.attributedPlaceholder = NSAttributedString(string: "Ton hashtag perso", attributes: customTopicInputAttributesPlaceholder)
        customTopicInput.attributedText = NSAttributedString(string: "", attributes: customTopicInputAttributesText)
        
        customTopicInput.textColor = colors.white
        
        //-- TableView
        tableView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        tableView.separatorStyle = .None
        
        //-- Live Button
        liveButton.layer.frame.size = CGSize(width: 70, height: 70)
        liveButton.layer.backgroundColor = colors.blue.CGColor
        liveButton.layer.opacity = 1
        liveButton.layer.cornerRadius = liveButton.layer.frame.width / 2

        //-- Topic button
        topicButton.titleLabel?.font = UIFont(name: "BPreplay-Italic", size: 36)
        topicButton.titleLabel?.textColor = colors.white
        topicButton.tintColor = colors.white
        
        //-- Wave
        //waveView.layer.frame.size = CGSize(width: 70, height: 70)
        waveView.frame.size = CGSize(width: 70, height: 70)
        waveView.layer.backgroundColor = colors.blue.CGColor
        waveView.layer.opacity = 0.2
        waveView.layer.cornerRadius = waveView.frame.size.width / 2
    }
    
    @IBAction func hashtagButton(sender: UIButton) {
        bridgeController.goToNextVC()
    }
    
    @IBAction func profileButton(sender: UIButton) {
        bridgeController.goToPreviousVC()
    }
}


extension CameraViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("HashtagCell")!
        cell.contentView.layer.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0).CGColor
        cell.textLabel?.text = hashtags[indexPath.row].hashtag
        cell.backgroundColor =  UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        cell.textLabel?.textColor = colors.white
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.selectionStyle = .None
        cell.textLabel?.font = UIFont(name: "Lato-Italic", size: 18)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeHashtags.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.textLabel?.font = UIFont(name: "Lato-BoldItalic", size: 18)
        
        customTopicInput.text = hashtags[indexPath.row].hashtag
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.textLabel?.font = UIFont(name: "Lato-Italic", size: 18)
    }
    
}

extension CameraViewController: UIGestureRecognizerDelegate {
    
    //-- Tap gesture
    func initTapGesture() {
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap!.delegate = self
    }
    
    func dismissKeyboard() {
        customTopicInput.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification){
        self.view.addGestureRecognizer(tap!)
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.removeGestureRecognizer(tap!)
    }
}

