//
//  ProfileViewController.swift
//  Spitchy
//
//  Created by Kévin Rignault on 06/06/2016.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UITableViewController {

    let colors = Colors()

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var followBackground: UIView!
    @IBOutlet weak var followLabel: UILabel!
    
    
    @IBOutlet weak var settingsBackground: UIView!
    @IBOutlet weak var settingsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
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
    
        navBar.topItem?.title = "Profil"
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont(name : "Lato-Bold", size : 17)!, NSForegroundColorAttributeName : UIColor.whiteColor()]
    
        //-- Profile
        profilePicture.layer.cornerRadius = 60
        profilePicture.clipsToBounds = true
        
        //-- Follow
        followLabel.text = "Informations"
        followLabel.textColor = colors.white
        followLabel.font = UIFont(name: "Lato-BoldItalic", size: 18)
        followBackground.backgroundColor = colors.blue
        
        //-- TableView
        tableView.tableFooterView = UIView()    //-- No display cell empty
        tableView.bounces = false
    }
    
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        print("Jeambon")
        print(indexPath.row)
        print(indexPath.section)
        if indexPath.row == 2 && indexPath.section == 1 {
            
            //here you can enter the action you want to start when cell 1 is clicked
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("FollowingsViewController")
            navigationController?.pushViewController(vc, animated: true)
            
            print("Youhou")
            
        }
        
    }
    
}
