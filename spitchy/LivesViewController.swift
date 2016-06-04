//
//  LivesViewController.swift
//  Spitchy
//
//  Created by Rplay on 03/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import UIKit

class LivesViewController: UIViewController {
    
    
    var fakeSpitchers: [Dictionary<String, String>] = [
        ["username" : "Jean", "image" : "test", "topic" : "#OMPSG"],
        ["username" : "Bernard", "image" : "test", "topic" : "#JambonDeBayonne"],
        ["username" : "Bertrant", "image" : "test", "topic" : "#Apiculture"],
        ["username" : "Georgette", "image" : "test", "topic" : "#Mobilette"],
        ["username" : "Mireille", "image" : "test", "topic" : "#CoutureAncienne"]
    ]
    
    var fakeTopics = [
        ["topic" : "#cuisine", "lives" : 12340],
        ["topic" : "#laitdevache", "lives" : 11340],
        ["topic" : "#nuitdebout", "lives" : 10240],
        ["topic" : "#mangerbouger", "lives" : 2148],
        ["topic" : "#coupdecoude", "lives" : 1148],
        ["topic" : "#produitdebanlieu", "lives" : 548],
        ["topic" : "#ronaldovsmessi", "lives" : 448],
        ["topic" : "#cloporte", "lives" : 348],
        ["topic" : "#poissonfrais", "lives" : 248],
        ["topic" : "#fruitsdesiles", "lives" : 148],
        ["topic" : "#tshirtdélavé", "lives" : 48],
        ["topic" : "#boissonfraiche", "lives" : 12],
        ["topic" : "#unijambiste", "lives" : 5],
        ["topic" : "#europeeanfootballcup", "lives" : 1]
    ]
    
    let colors = Colors()
    var spitchers = [SpitcherModel]()
    var topics = [TopicModel]()
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var statusBarBackground: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var backgroundViewSpitchersLabel: UIView!
    @IBOutlet var spitchersLabel: UILabel!
    @IBOutlet var backgroundViewTopicsLabel: UIView!
    @IBOutlet var topicsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        initFakeSpitchers()
        initFakeTopics()
    }
    
    func initFakeSpitchers() {
        for fakeSpitcher in fakeSpitchers {
            spitchers.append(SpitcherModel(username: fakeSpitcher["username"]!, image: UIImage(named: fakeSpitcher["image"]!)! , topic: fakeSpitcher["topic"]!))
        }
    }
    
    func initFakeTopics() {
        for fakeTopic in fakeTopics {
            topics.append(TopicModel(topicName: fakeTopic["topic"]! as! String, nbLives: fakeTopic["lives"] as! Int))
        }
    }
    
    func design() {
        
        //-- NavBar settings
        navBar.barTintColor = colors.green
        for parent in navBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        
        navBar.translucent = false
        
        navBar.topItem?.title = "Lives"
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name : "Lato-Bold", size : 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        //-- Status bar
        statusBarBackground.backgroundColor = colors.green
        
        //-- Spitchers
        spitchersLabel.text = "Spitchers en live"
        spitchersLabel.textColor = colors.white
        spitchersLabel.font = UIFont(name: "Lato-BoldItalic", size: 18)
        backgroundViewSpitchersLabel.backgroundColor = colors.blue
        
        //-- Topics
        topicsLabel.text = "Topics du moment"
        topicsLabel.textColor = colors.white
        topicsLabel.font = UIFont(name: "Lato-BoldItalic", size: 18)
        backgroundViewTopicsLabel.backgroundColor = colors.blue
        
    }
}

extension LivesViewController: UICollectionViewDelegate {

}

extension LivesViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spitchers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : SpitchersCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier("SpitcherInLiveCell",
                                                                         forIndexPath: indexPath) as! SpitchersCollectionCell
        cell.usernameLabel.text = spitchers[indexPath.row].username
        cell.topicLabel.text = spitchers[indexPath.row].topic
        cell.spitcherImage.image = spitchers[indexPath.row].image
        
        cell.backgroundColor = UIColor.whiteColor()
        cell.usernameLabel.font = UIFont(name: "Lato-Regular", size: 11)
        cell.topicLabel.font = UIFont(name: "Lato-Light", size: 11)
        
        
        return cell
    }
}

extension LivesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.separatorColor = colors.lightGreen
        
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("TopicCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = topics[indexPath.row].topicName
        cell.detailTextLabel?.text = String(topics[indexPath.row].nbLives) + " lives"
        
        cell.textLabel?.font = UIFont(name: "Lato-Bold", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "Lato-Regular", size: 14)
        
        var adjustedAccessory = cell.accessoryView?.frame
        adjustedAccessory?.origin.y += 40
        
        cell.accessoryView?.frame = adjustedAccessory!
        
        return cell
    }
    
}