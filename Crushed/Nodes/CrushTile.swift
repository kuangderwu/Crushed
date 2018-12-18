//
//  CrushTile.swift
//  Crushed
//
//  Created by apple on 2018/12/11.
//  Copyright © 2018 Kuang-Der Wu. All rights reserved.
//

import UIKit
import SpriteKit

class CrushTile: SKSpriteNode {

    var tileType = 0
    var outerIndex = 0
    let selectedSoundAction = SKAction.playSoundFileNamed(GameConstants.musicSelected, waitForCompletion: false)
    let magicSoundAction = SKAction.playSoundFileNamed(GameConstants.musicMagic, waitForCompletion: false)
    
    func wasSelected() {
        self.run(selectedSoundAction)
    }
    
    
    func remove() {
        self.run(self.magicSoundAction)
        //Fade out tile
        let tileActions = [SKAction.scale(to: 1.5, duration:0.5),SKAction.scale(to: 0.1, duration: 0.5),SKAction.fadeAlpha(to: 0, duration: 1)]
        let tileSequence = SKAction.sequence(tileActions)
        self.run(tileSequence)
        
        //particles
        let exploder = (NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "match", ofType: "sks")!) as! SKEmitterNode)
        
        exploder.alpha = 0
        exploder.position = self.position
        exploder.zPosition = GameConstants.zHeight
        
        self.parent!.addChild(exploder)
        
        let actions = [SKAction.fadeAlpha(to: 1, duration: 1),SKAction.fadeAlpha(to: 0, duration: 1)]
        
        let explodesequence = SKAction.sequence(actions)
        
        exploder.run(explodesequence, completion: {
            self.removeFromParent()
            exploder.removeFromParent()
        })
        
    }
}
