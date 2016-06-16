//
//  ListLiveModel.swift
//  Spitchy
//
//  Created by Rplay on 09/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class ListLiveModel {
    var username: String
    var nbUsers: Int
    var image: UIImage?
    var videoWidth: Int
    var videoHeight: Int
    var bytesPerRow: Int
    var pixelFormat: Int
    var bufferID: String
    
    init(bytesPerRow: Int, videoWidth: Int, videoHeight: Int, pixelFormat: Int) {
        self.username = "Romain"
        self.nbUsers = 10
        self.bufferID = "bufferID"
        self.videoWidth = videoWidth
        self.videoHeight = videoHeight
        self.bytesPerRow = bytesPerRow
        self.pixelFormat = pixelFormat
        
        //self.image = bufferManager?.bufferToImage(buffer, bytesPerRow: bytesPerRow, width: videoWidth, height: videoHeight, pixelFormatType: pixelFormat)
        
        self.image = UIImage(named: "topic-economy")
    }
}
