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
    var stream: NSInputStream
    
    init(username: String, nbUsers: Int, stream: NSInputStream) {
        self.username = username
        self.nbUsers = nbUsers
        self.stream = stream
    }
}
