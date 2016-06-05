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
    
    var hashtags = [HashtagModel]()
    
    @IBOutlet var previewLayer: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var spitchy: UILabel!
    @IBOutlet var customTopicInput: UITextField!
    @IBOutlet var liveButton: UIButton!
    
    override func viewDidLoad() {
        session = Session()
        preview = Preview()
        
        let sessionAudioVideo = session?.createSession()
        let previewSize = self.view.frame.size
        let previewAudioVideo = preview?.createPreview(previewSize, session: sessionAudioVideo!)
        
        previewLayer.layer.addSublayer(previewAudioVideo!)
        sessionAudioVideo?.startRunning()
        
        initFakeHashtags()
        design()
        
        tableView.reloadData()
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
            print(family)
            for names in UIFont.fontNamesForFamilyName(family) {
                print("== \(names)")
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
        
        //-- TableView
        tableView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        tableView.separatorStyle = .None
        
        //-- Live Button
        liveButton.layer.frame.size = CGSize(width: 70, height: 70)
        liveButton.layer.backgroundColor = colors.blue.CGColor
        liveButton.layer.opacity = 0.8
        liveButton.layer.cornerRadius = liveButton.layer.frame.width / 2
        
        
        print((liveButton.frame))
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
        cell.textLabel?.font = UIFont(name: "Lato-Italic", size: 18)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fakeHashtags.count
    }
}

