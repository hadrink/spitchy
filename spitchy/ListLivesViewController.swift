//
//  ListLivesViewController.swift
//  Spitchy
//
//  Created by Kévin Rignault on 07/06/2016.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class ListLivesViewController: UIViewController {

    var thisTopic:String!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        design()
    }
    
    func design(){
        navBar.topItem?.title = thisTopic
    }
    
}