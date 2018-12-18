//
//  GameScene.swift
//  Crushed
//
//  Created by apple on 2018/12/11.
//  Copyright © 2018 Kuang-Der Wu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameModel = CrushModel()
    var selectedTile: CrushTile?
    var scoreBoard: CrushScoreboard!
    var backgroundSound = SKAction.playSoundFileNamed(GameConstants.bgMusic, waitForCompletion: false)
    var currentLevel: Int?
    
    func setup() {
        self.gameModel.myGameScene = self
        self.initSetup()
        self.gameModel.setupModel()
        self.gameModel.populateModel()
        self.arrangeTiles()
        self.setupBackground()
        self.setupScoreboard()
        self.run(backgroundSound)

    }
    
    
    
    func arrangeTiles() {
        
        let gridInfo = self.gridInformation()
        
        var location = CGPoint(x: gridInfo.margin + (gridInfo.tileSize/2),y: gridInfo.startY)
        
        var i = 0
        for verticalStrip in self.gameModel.TwoDArray {
            
            var verticalCounter = 1
            for gameTile in verticalStrip {
                
                let convertedLocation = self.convertPoint(fromView: location )
                
                gameTile.run(SKAction.move(to: convertedLocation, duration: 0.05 * Double(verticalCounter)))
                location.y -= gridInfo.tileSize
                
                gameTile.outerIndex = i
                verticalCounter += 1
            }
            
            location.x += gridInfo.tileSize
            location.y = gridInfo.startY
            
            i += 1
        }
    }
    
    func setupSprite(_ withImage: Int) -> CrushTile {
        
        let sprite = CrushTile(imageNamed: GameConstants.tileImage  + String(withImage))
        sprite.tileType = withImage
        if UIScreen.main.bounds.size.width == 375 {
            sprite.setScale(GameConstants.factorNotX)
        } else {
            sprite.setScale(GameConstants.factorNotX)
        }
        self.addChild(sprite)
        return sprite
    }
    
    func setupScoreboard() {
        self.scoreBoard = CrushScoreboard(imageNamed:"scoreboard")
        self.scoreBoard.xScale = 0.5
        self.scoreBoard.yScale = 0.5
        self.scoreBoard.position = CGPoint(x: 0,y: -(self.frame.size.height / 2) + 80)
        self.addChild( self.scoreBoard)
        self.scoreBoard.setup()

    }
    
    func tileWasPressed(_ pressedTile: CrushTile) {
        
        //Do we spin once, or forever…
        pressedTile.wasSelected()
        var spinForever = true
        if (self.selectedTile == nil) {//we don't currently have a selection, so let's select it
            self.selectedTile = pressedTile
            spinForever = true
        } else {
            spinForever = false
        }
        
        //Let’s create an animation action, it might run once, or it might run until another tile is clicked.
        let action = SKAction.rotate(byAngle: CGFloat.pi/2, duration:0.15)
       
        if (spinForever) {
            pressedTile.run(SKAction.repeatForever(action)) //let’s repeat the animation action forever!
        } else {
            
            //We’ll run the action once, and then process the moving of the tiles
            pressedTile.run(action,completion: {
                
                self.selectedTile!.removeAllActions()
                self.gameModel.switchTiles(pressedTile,otherPiece: self.selectedTile!)
                self.selectedTile = nil
                self.findMatchesAndRepopulate()
            })
        }
    }
    
    func findMatchesAndRepopulate() {
        
        self.arrangeTiles()
        
        let tilesToRemove = self.gameModel.findMatches()
        
        self.gameModel.removeTiles(tilesToRemove)

        if (tilesToRemove.count == 0) {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { (_) in
            self.gameModel.populateModel()
            self.arrangeTiles()
            self.findMatchesAndRepopulate()
        }
    }
    
    func setupBackground() {
  //      self.backgroundColor = CrushUtils.randomColor()
  //      let background = SKSpriteNode()
        let background = SKSpriteNode(imageNamed: GameConstants.backgroundpng)
        background.scale(to:  self.frame.size )
        background.zPosition = -1
        background.position = CGPoint(x: 0, y: 0)
        self.addChild(background)
 
    }

    
    override func didMove(to view: SKView) {
        self.setup()
    }
    
    
    func touchDown(atPoint pos : CGPoint) { }
    
    func touchMoved(toPoint pos : CGPoint) { }
    
    func touchUp(atPoint pos : CGPoint) { }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let clickLocation = touches.first?.location(in: self.view)
        let convertedLocation = self.convertPoint(fromView: clickLocation!)
        
        let clickedNode = self.atPoint(convertedLocation)
        if clickedNode.isKind(of: CrushTile.self) == false {
            print("you didn't click a tile!")
            return
        } 
        
        let pressedTile = clickedNode as! CrushTile
        self.tileWasPressed(pressedTile)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

    }
    
    func gridInformation() -> (margin:CGFloat,tileSize:CGFloat,startY:CGFloat) {
        
        let gridMargin = CGFloat(32)
        let tileSize = (UIScreen.main.bounds.size.width - CGFloat(gridMargin * 2)) / CGFloat(GameConstants.dimIn)
        let startY = (tileSize * CGFloat(GameConstants.dimIn)) + gridMargin
        
        return (margin:gridMargin,tileSize:tileSize,startY:startY)
    }
    
    /*
    func setupNode() -> CrushTile {
        // Personal test concept
        let color = CrushUtils.randomColor()
        let node = CrushTile(color: color, size: CGSize.zero)
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width/2.0)
        node.physicsBody?.affectedByGravity = false
        self.addChild(node)
        return node
    }
 */
}
