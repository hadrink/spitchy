//
//  SpitcherModel.swift
//  Spitchy
//
//  Created by Rplay on 04/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class SpitcherModel {
    
    var username: String
    var image: UIImage
    var topic: String
    
    init(username: String, image: UIImage, topic: String) {
        self.username = username
        self.image = image
        self.topic = topic
    }
    
}