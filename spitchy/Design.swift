//
//  Design.swift
//  Spitchy
//
//  Created by Rplay on 02/06/16.
//  Copyright © 2016 rplay. All rights reserved.
//

import UIKit

struct Design {
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

struct Colors {
    let green = Design().UIColorFromRGB(0x5DD8CD)
    let white = Design().UIColorFromRGB(0xFFFFFF)
    let lightGreen = Design().UIColorFromRGB(0xE9F1E0)
    let blue = Design().UIColorFromRGB(0x40A1BD)
}
