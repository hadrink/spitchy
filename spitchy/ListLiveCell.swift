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
    @IBOutlet var image: UIImageView!
    @IBOutlet var headerView: UIView!
    
    let colors = Colors()
    
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
    
    func designCell() {
        username.font = UIFont(name: "Lato-Regular", size: 14)
        username.textColor = colors.white
        
        nbViewers.font = UIFont(name: "Lato-Light", size: 12)
        nbViewers.textColor = colors.white
        
        headerView.backgroundColor = colors.blue
    }
}