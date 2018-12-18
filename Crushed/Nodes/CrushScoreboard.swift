//
//  CrushScoreboard.swift
//  Crushed
//
//  Created by apple on 2018/12/14.
//  Copyright © 2018 Kuang-Der Wu. All rights reserved.
//

import UIKit
import SpriteKit

class CrushScoreboard: SKSpriteNode {
    
    var scoreLabel: SKLabelNode!
    
    func setup() {
        self.scoreLabel = SKLabelNode(fontNamed: GameConstants.scoreboardFont)
        self.scoreLabel.horizontalAlignmentMode = .center
        self.scoreLabel.fontSize = GameConstants.scoreboardFontSize
        self.scoreLabel.zPosition = GameConstants.zHeight
        self.scoreLabel.text = "0"
        
        self.addChild(scoreLabel)
    }
    
    func setScore(score: Int) {
        self.scoreLabel.text = String(score)
        
        let actions = [SKAction.scale(to: 2, duration:0.2),SKAction.scale(to: 1, duration: 0.5)]
        let scoreChangedAction = SKAction.sequence(actions)
        self.scoreLabel.removeAllActions()
        self.scoreLabel.run(scoreChangedAction)
        
    }
}
