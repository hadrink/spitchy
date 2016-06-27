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
    var timerButtonsGoToBottom: NSTimer?
    var timerCountDown: NSTimer?
    var counter: Int?
    var tapForKeyboard: UITapGestureRecognizer?
    var tapForButtonsGoBack: UITapGestureRecognizer?
    var liveStarted: Bool?
    var nbViewers: UILabel?
    
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
    
    @IBOutlet var profileButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet var topicButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet var liveButtonBottomConstraint: NSLayoutConstraint!
    
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
        initButtonsGoBackOnTap()
        
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
    
    func startLive() -> Bool {
        
        self.view.addGestureRecognizer(tapForButtonsGoBack!)
        
        buttonsGoToBottom()
        
        return true
    }
    
    func stopLive() -> Bool {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(self.animate), userInfo: nil, repeats: true)
        self.waveView.alpha = 1
        
        self.view.removeGestureRecognizer(tapForButtonsGoBack!)
        
        self.profileButtonBottomConstraint.constant = 40
        self.topicButtonBottomConstraint.constant = 40
        self.liveButtonBottomConstraint.constant = 40
        
        timerButtonsGoToBottom?.invalidate()
        timerButtonsGoToBottom = nil
        //})
        
        return false
    }
    
    @IBAction func startLiveAction(sender: AnyObject) {
        
        counter = 3
        
        if liveStarted == false || liveStarted == nil {
            timer?.invalidate()
            timer = nil
            timerCountDown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.countDown), userInfo: nil, repeats:
            true)
        } else {
            liveStarted = stopLive()
            
            
            UIView.transitionWithView(liveButton, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                self.liveButton.setImage(UIImage(named: "logo-live-icon"), forState: .Normal)
                self.liveButton.setTitle("", forState: .Normal)
            }, completion: nil)
            
            UIView.transitionWithView(spitchy, duration: 1, options: .TransitionCrossDissolve, animations: {
                self.spitchy.text = "Spitchy"
                self.spitchy.font = UIFont(name: "BPreplay-BoldItalic", size: 24)
                }, completion: nil)
            
            UIView.animateWithDuration(1, animations: {
                self.liveButton.backgroundColor = self.colors.blue
                self.tableView.alpha = 1
                self.nbViewers?.alpha = 0
                self.customTopicInput.alpha = 1
                }, completion: { finished in
                    self.nbViewers?.removeFromSuperview()
            })
            
            print("Live stoped")
        }
        
        
    }
    
    func countDown() {
        
        nbViewers = createNbViewersLabel()
        self.nbViewers?.alpha = 0
        
        
        UIView.transitionWithView(liveButton, duration: 0.25, options: .TransitionCrossDissolve, animations: {
            self.liveButton.setImage(nil, forState: .Normal)
            self.liveButton.setTitle(String(self.counter!), forState: .Normal)
            }, completion: nil)
        
        print(counter)
        
        if counter == 0 {
            self.waveView.alpha = 0
            timerCountDown?.invalidate()
            
            
            UIView.transitionWithView(liveButton, duration: 0.25, options: .TransitionCrossDissolve, animations: {
                self.liveButton.setTitle("", forState: .Normal)
                self.liveButton.setImage(UIImage(named: "logo-live-icon"), forState: .Normal)
                }, completion: nil)
            
            UIView.transitionWithView(spitchy, duration: 1, options: .TransitionCrossDissolve, animations: {
                self.spitchy.text = self.customTopicInput.text
                self.spitchy.font = UIFont(name: "Lato-Light", size: 24)
                }, completion: nil)
            

            
            UIView.animateWithDuration(1, animations: {
                self.liveButton.backgroundColor = self.colors.red
                self.nbViewers?.alpha = 1
                self.tableView.alpha = 0
                self.customTopicInput.alpha = 0
                }, completion: { finished in
                
            })
            
            timerCountDown = nil
            liveStarted = startLive()
            
            print("Live started")
            
        }
        
        counter! -= 1
    }
    
    func createNbViewersLabel(text: String = "0 viewers") -> UILabel? {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 60, width: 250, height: 40))
        label.font = UIFont(name: "Lato-Regular", size: 14)
        label.textColor = colors.white
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .Center
        let constraint = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: .None, attribute: .NotAnAttribute, multiplier: 1, constant: 250)
        let top = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 60)
        
        self.view.addSubview(label)
        self.view.addConstraint(constraint)
        self.view.addConstraint(width)
        self.view.addConstraint(top)
        self.view.layoutIfNeeded()
        
        return label
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
        spitchy.text = "Spitchy"
        
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
        liveButton.backgroundColor = colors.blue
        liveButton.titleLabel?.font = UIFont(name: "Lato-Bold", size: 24)

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
        tapForKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapForKeyboard!.delegate = self
    }
    
    func dismissKeyboard() {
        customTopicInput.endEditing(true)
    }
    
    func keyboardWillShow(sender: NSNotification){
        self.view.addGestureRecognizer(tapForKeyboard!)
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.removeGestureRecognizer(tapForKeyboard!)
    }
    
    func initButtonsGoBackOnTap() {
        tapForButtonsGoBack = UITapGestureRecognizer(target: self, action: #selector(self.buttonsComeBackOnTap))
    }
    
    func buttonsComeBackOnTap() {
        
        
        UIView.animateWithDuration(0.5, animations: {
            self.profileButtonBottomConstraint.constant = 40
            self.topicButtonBottomConstraint.constant = 40
            self.liveButtonBottomConstraint.constant = 40
            
            self.view.layoutIfNeeded()
        })
        
        timerButtonsGoToBottom?.invalidate()
        timerButtonsGoToBottom = nil
        
        timerButtonsGoToBottom = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(self.buttonsGoToBottom), userInfo: nil, repeats: false)
        
    }
    
    func buttonsGoToBottom() {
        
        
        UIView.animateWithDuration(0.5, delay: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            
            self.profileButtonBottomConstraint.constant = -100
            self.topicButtonBottomConstraint.constant = -100
            self.liveButtonBottomConstraint.constant = -100
            self.view.layoutIfNeeded()
            
            }, completion: { finished in
                
        })
        
    
        
    }
}

