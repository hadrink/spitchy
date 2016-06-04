//
//  TopicCellModel.swift
//  Spitchy
//
//  Created by Rplay on 04/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class TopicModel {
    
    var topicName: String
    var nbLives: Int
    
    init(topicName: String, nbLives: Int) {
        self.topicName = topicName
        self.nbLives = nbLives
    }
}
