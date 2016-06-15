//
//  BufferManager.swift
//  Spitchy
//
//  Created by Kévin Rignault on 15/06/2016.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation

class BufferManager {
    
    var width:Int?
    var height:Int?
    var format:Int?
    var datas:NSData?
    
    init(width:Int, height:Int, format:Int, bytesPerRow:Int, datas:NSData){
        self.width = width
        self.height = height
        self.format = format
        self.datas = datas
    }

    
    
    
}