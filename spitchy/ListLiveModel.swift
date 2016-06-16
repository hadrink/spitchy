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
    var username: String?
    var nbUsers: String?
    var image: UIImage?
    var liveID: String?
    
    init(username: String, nbUsers: Int, liveID: String, imageName: String) {
        self.username = username
        self.nbUsers = String(nbUsers)
        self.liveID = "bufferID"
        
        //self.image = bufferManager?.bufferToImage(buffer, bytesPerRow: bytesPerRow, width: videoWidth, height: videoHeight, pixelFormatType: pixelFormat)
        
        self.image = UIImage(named: imageName)
    }
}
