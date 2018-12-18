//
//  CrushUtils.swift
//  Crushed
//
//  Created by apple on 2018/12/11.
//  Copyright © 2018 Kuang-Der Wu. All rights reserved.
//

import UIKit
import SpriteKit

class CrushUtils: Any {
    
    class func randomNumberBetweenOneAndSome(number: Int) -> Int {
        return Int(arc4random_uniform(UInt32(number))) + 1
    }
    
    class func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(UInt32(256)))
        let green = CGFloat(arc4random_uniform(UInt32(256)))
        let blue = CGFloat(arc4random_uniform(UInt32(256)))
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}
