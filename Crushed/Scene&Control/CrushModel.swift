//
//  CrushModel.swift
//  Crushed
//
//  Created by apple on 2018/12/11.
//  Copyright © 2018 Kuang-Der Wu. All rights reserved.
//

import UIKit
import SpriteKit

class CrushModel: Any {
    
    var matchLengthRequired = 3
    var TwoDArray = [[CrushTile]]()
    weak var myGameScene: GameScene!
    var currentScore = 0 {
        didSet {
            self.myGameScene.scoreBoard.setScore(score: self.currentScore)
        }
    }
    var currentLevel = 0 {
        didSet {
            // TODO:
            // Display level info on scoreBoard
        }
    }
    let dimIns = [6,6,7,7,8,8,9,9,10,10]
    let dimOuts = [6,6,7,7,8,8,9,9,10,10]
    
    
    var xIndex: Int!
    var yIndex: Int!
    
    func setupModel() {
        var i = 0
        while i < GameConstants.dimIn {
            let newArray = [CrushTile]()
            self.TwoDArray.append(newArray)
            i += 1
        }
    }
  
    
    func populateModel() {
        var i = 0
        while  i < GameConstants.dimOut {
            while self.TwoDArray[i].count < GameConstants.dimIn {
                let dice = CrushUtils.randomNumberBetweenOneAndSome(number: 7)
                let CrushTile = self.myGameScene.setupSprite(dice)
                CrushTile.outerIndex = i
                self.TwoDArray[i].append(CrushTile)
            }
            i += 1
        }
    }
 

    func switchTiles(_ firstPiece:CrushTile,otherPiece:CrushTile) {
        
        let firstPieceOuterIndex = firstPiece.outerIndex
        let otherPieceOuterIndex = otherPiece.outerIndex
        
        let firstPieceInnerIndex = self.TwoDArray[firstPieceOuterIndex].index(of: firstPiece)
        let otherPieceInnerIndex = self.TwoDArray[otherPieceOuterIndex].index(of: otherPiece)
        
        if abs(firstPieceOuterIndex - otherPieceOuterIndex) >= 2 || abs(firstPieceInnerIndex! - otherPieceInnerIndex!) >= 2 {
            return
        }
        
        self.TwoDArray[firstPieceOuterIndex].remove(at: firstPieceInnerIndex!)
        
        self.TwoDArray[firstPieceOuterIndex].insert(otherPiece, at: firstPieceInnerIndex!)
        
        self.TwoDArray[otherPieceOuterIndex].remove(at: otherPieceInnerIndex!)
        
        self.TwoDArray[otherPieceOuterIndex].insert(firstPiece, at: otherPieceInnerIndex!)
        
        firstPiece.outerIndex = otherPieceOuterIndex
        otherPiece.outerIndex = firstPieceOuterIndex
        xIndex = otherPiece.outerIndex
        yIndex = firstPieceInnerIndex
        
    }
    
    func findMatches() -> [CrushTile] {
        
        var matches = [CrushTile]()
        
        //TODO - We need to work out where the matching rows are here....
        
        let verticalMatches =   self.findMatches(inStrips:self.TwoDArray)
        if verticalMatches.count != 0 {
            print("vertical =: \(verticalMatches.count)")
            if verticalMatches.count >= 5 {
                for tile in self.TwoDArray[xIndex] {
                    matches.append(tile)
                }
            }
        }
        matches.append(contentsOf: verticalMatches)

        let horizontalMatches = self.findMatches(inStrips:self.rotatedGrid())
        if horizontalMatches.count != 0 {
            print("Horizontal =: \(horizontalMatches.count)")
            if horizontalMatches.count >= 5 {
                for i in 0...GameConstants.dimOut - 1 {
                    let tile = self.TwoDArray[i][yIndex]
                    matches.append(tile)
                }
            }
        }
        matches.append(contentsOf: horizontalMatches)
        return matches
    }
    
    func findMatches(inStrips:[[CrushTile]]) -> [CrushTile] {
        
        var foundPieces = [CrushTile]()
        
        for strip in inStrips {
            
            var currentType = strip[0].tileType
            var i = 1
            
            var stack = [CrushTile]()
            
            stack.append(strip[0])
            
            while (i < strip.count) {
                let cp = strip[i]
                
                if (cp.tileType == currentType) {
                    stack.append(cp)
                } else {
                    if (stack.count >= self.matchLengthRequired) {
                        foundPieces.append(contentsOf: stack)
                    }
                    stack.removeAll()
                    currentType = strip[i].tileType
                    
                    stack.append(strip[i])
                }
                
                i += 1
            }
            if (stack.count >= self.matchLengthRequired) {
                foundPieces.append(contentsOf: stack)
                stack.removeAll()
            }
        }
        return foundPieces
    }

    
    func rotatedGrid() ->  [[CrushTile]] {
        let length = self.TwoDArray[0].count
        var returnValue = [[CrushTile]](repeating: [CrushTile](), count: length)
        for index in 0..<length {
            returnValue[index] = self.TwoDArray.map{ $0[index] }.reversed()
        }
        return returnValue
    }
    
    func removeTiles(_ tilesToRemove:[CrushTile]) {

        for tile in tilesToRemove {
            self.removeTile(tile)
        }
    }
    
    func removeTile(_ tile:CrushTile) {
        var  i = 0
        self.currentScore += 10
    
        tile.remove() // for particle effect
        while (i < self.TwoDArray.count) {
            let verticalstrip = self.TwoDArray[i]
            if (verticalstrip.index(of: tile) != nil) {
                self.TwoDArray[i].remove(at: verticalstrip.index(of: tile)!)
            }
            i += 1
        }
        
    }
}
