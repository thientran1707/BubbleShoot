//
//  GameLevel.swift
//  LevelDesigner
//
//  Created by Tran Cong Thien on 4/2/15.
//  Copyimport Foundation
import UIKit

let KEY_FOR_LEVEL_NAME = "levelName"
let KEY_FOR_BUBBLE_GRID = "bubbleGrid"
let DEFAULT_NAME = "Default"

class GameLevel:  NSObject, NSCoding {
    //each game level will the name and the array of bubble model
    var levelName: String
    var bubbleGrid: [[Bubble]]
    
    override init() {
        
        levelName = DEFAULT_NAME
        bubbleGrid = [[Bubble]]()
    }
    
    //init with name, number of row and col
    init(name: String, rowNum: Int) {
        
        levelName = name
        bubbleGrid = [[Bubble]]()
        
        for var row = 0; row < rowNum; row++ {
            //if the row is odd (0- index), just create an array of colNum - 1 elements
            var bubbleInRow = [Bubble]()
            bubbleGrid.append(bubbleInRow)
        }
        
    }
    
    
    init(gameLevel: GameLevel) {
        self.levelName = gameLevel.levelName
        self.bubbleGrid = [[Bubble]]()

        for var row = 0; row < gameLevel.bubbleGrid.count; row++ {
            var bubbleRow = [Bubble]()
            for var col = 0; col < gameLevel.bubbleGrid[row].count; col++ {
                bubbleRow.append(gameLevel.bubbleGrid[row][col].getClone())
            }
            self.bubbleGrid.append(bubbleRow)
        }
    }
    
    
    //add the bubble to at paticular row
    func addBubbleToGrid(bubble: Bubble, row: Int){
        
        if row < bubbleGrid.count {
            bubbleGrid[row].append(bubble)
        }
    }
    
    
    func encodeWithCoder(coder: NSCoder) {
        
        //This tells the archiver how to encode the object
        coder.encodeObject(self.levelName, forKey: KEY_FOR_LEVEL_NAME)
        coder.encodeObject(self.bubbleGrid, forKey: KEY_FOR_BUBBLE_GRID)
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        
        self.init()
        //This tells the unarchiver how to decode the object
        self.levelName = aDecoder.decodeObjectForKey(KEY_FOR_LEVEL_NAME) as String!
        self.bubbleGrid = aDecoder.decodeObjectForKey(KEY_FOR_BUBBLE_GRID) as [[Bubble]]!
    }
}


