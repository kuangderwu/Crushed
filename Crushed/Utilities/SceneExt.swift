//
//  SceneExt.swift
//  Crushed
//
//  Created by apple on 2018/12/18.
//  Copyright © 2018 Kuang-Der Wu. All rights reserved.
//

import UIKit
import SpriteKit


extension SKScene {
   
    func initSetup() {
        print("init setup Here!")
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            print("The device is iPad")
        } else {
            print("The device is iPhone")
        }
        
        let screenWidth = self.view!.bounds.width
        let screenHeight = self.view!.bounds.height
        print("Screen Width: \(screenWidth), Height: \(screenHeight)")
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)  // could be adjust based on app design
        
    }
}
