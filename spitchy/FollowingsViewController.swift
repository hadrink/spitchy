//
//  FollowingsViewController.swift
//  Spitchy
//
//  Created by Rplay on 07/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class FollowingsViewController: UIViewController {
    
    let colors = Colors()
    var followingUsers = [FollowingsCellModel]()
    
    var fakeFollowings = [
        ["image_name" : "following-test", "username" : "Jean-mi"],
        ["image_name" : "following-test", "username" : "Paul"],
        ["image_name" : "following-test", "username" : "Carlos"],
        ["image_name" : "following-test", "username" : "Micheline"],
        ["image_name" : "following-test", "username" : "Sébi"],
        ["image_name" : "following-test", "username" : "Jean"],
        ["image_name" : "following-test", "username" : "Patrick"],
        ["image_name" : "following-test", "username" : "Pascal"],
        ["image_name" : "following-test", "username" : "Raymond"],
        ["image_name" : "following-test", "username" : "Claude"]
    ]
    
    @IBOutlet var backgroundStatusBar: UIView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFakeFollowings()
        design()
        
        //-- Tap gesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        //LightContent
        return UIStatusBarStyle.LightContent
        
        //Default
        //return UIStatusBarStyle.Default
        
    }
    
    func initFakeFollowings() {
        for fakeFollowing in fakeFollowings {
            followingUsers.append(FollowingsCellModel(imageName: fakeFollowing["image_name"]!, username: fakeFollowing["username"]!))
        }
    }
    
    func design() {
        
        //-- Status bar
        backgroundStatusBar.backgroundColor = colors.green
        
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
        navBar.topItem?.title = "Abonnements"
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name : "Lato-Bold", size : 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        //-- Search bar
        searchBar.barTintColor = colors.blue
        
        let customSearchInputAttributesPlaceholder = [
            NSFontAttributeName : UIFont(name : "Lato-Italic", size: 14)!,
            NSForegroundColorAttributeName : colors.blue
        ]
        
        let customSearchInputAttributesText = [
            NSFontAttributeName : UIFont(name : "Lato-Regular", size: 14)!,
            NSBackgroundColorAttributeName : colors.blue
        ]
        
        
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.attributedPlaceholder =  NSAttributedString(string: "Recheche un Spitcher", attributes: customSearchInputAttributesPlaceholder)
                    
                    textField.attributedText = NSAttributedString(string: "", attributes: customSearchInputAttributesText)
                    textField.textColor = colors.blue
                }
            }
        }
        
        //-- TableView
        tableView.rowHeight = 60
        tableView.separatorColor = colors.lightGreen
        
    }
}

extension FollowingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FollowingsCustomCell = tableView.dequeueReusableCellWithIdentifier("FollowingCell", forIndexPath: indexPath) as! FollowingsCustomCell
        
        let profileImage = UIImage(named: followingUsers[indexPath.row].imageName)
        let cellImageLayer: CALayer = cell.profileImage.layer
        cellImageLayer.cornerRadius = 20
        cellImageLayer.masksToBounds = true
        cell.profileImage.image = profileImage
        
        cell.username.font = UIFont(name: "Lato-Regular", size: 14)
        cell.username.text = followingUsers[indexPath.row].username
        
        return cell
    }
}

extension FollowingsViewController: UIGestureRecognizerDelegate {
    func dismissKeyboard() {
        searchBar.endEditing(true)
    }
}