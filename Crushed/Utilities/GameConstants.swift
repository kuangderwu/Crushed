//
//  GameConstants.swift
//  Crushed
//
//  Created by Mac on 2018/12/14.
//  Copyright © 2018 Kuang-Der Wu. All rights reserved.
//

import Foundation
import CoreGraphics

struct GameConstants {
    
    static var debug = true
    // music constants & backgound
    static var musicSelected = "selected.wav"
    static var musicMagic = "magic.wav"
    static var bgMusic = "background.mp3"
    static var backgroundpng = "background5.png"
    
    // zHeight
    static var zHeight: CGFloat = 99
    // Dimension
    static var dimOut = 8 // 寬
    static var dimIn = 8  //高
    
    // Scale factor
    static var factorX: CGFloat = 1.6
    static var factorNotX: CGFloat = 0.9
    
    // Scoreboard
    static var scoreboardFont = "Chalkduster"
    static var scoreboardFontSize: CGFloat = 140
    
    // Tile image Asset Name
    static var tileImage: String = "circle_"    //"jewel_"
    
    static var levelNumber = 10
}
