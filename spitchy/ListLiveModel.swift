//
//  ListLiveModel.swift
//  Spitchy
//
//  Created by Rplay on 09/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation

class ListLiveModel {
    var username: String
    var nbUsers: Int
    var image: NSInputStream
    
    init(image: NSInputStream) {
        self.username = "Romain"
        self.nbUsers = 10
        self.image = image
    }
}
