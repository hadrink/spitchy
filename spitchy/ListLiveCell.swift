//
//  ListLiveCell.swift
//  Spitchy
//
//  Created by Kévin Rignault on 07/06/2016.
//  Copyright © 2016 rplay. All rights reserved.
//

import Foundation
import UIKit

class ListLiveCell: UICollectionViewCell {
    @IBOutlet var username: UILabel!
    @IBOutlet var nbViewers: UILabel!
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
}