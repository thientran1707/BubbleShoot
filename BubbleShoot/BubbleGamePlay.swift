//
//  BubbleGamePlay.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 14/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import AVFoundation
import UIKit

private var backgroundMusicPlayer: AVAudioPlayer!

class BubbleGamePlay: GamePlay, PhysicsContactDelegate {
    var bubbleGrid: [[Bubble]]
    var bubbleGraph: BubbleGraph
    let THRESHOLD = 12

    init(inputGrid: [[Bubble]], wall: [GameObject]) {
        self.bubbleGraph = BubbleGraph()
        self.bubbleGrid = inputGrid
        super.init()
        
        self.contactDelegate = self
        self.addStaticGameObjectFromArray(wall)
        
        for var row = 0; row < bubbleGrid.count; row++ {
            var bubbleRow = bubbleGrid[row]
            for var col = 0; col < bubbleRow.count; col++ {
                
                var bubbleModel = bubbleRow[col]
                if bubbleModel.type == BubbleType.NO_BUBBLE {
                  continue
                }
                
                bubbleModel.physicsBody = PhysicsBody(circleOfRadius: bubbleModel.radius)
                bubbleModel.physicsBody.position = bubbleModel.center
                bubbleModel.physicsBody.category = GameObjectType.BUBBLE
                
                self.addStaticGameObject(bubbleModel)
                self.addNodeToBubbleGraphWithBubbleAt(row, col: col)
            }
        }
    }
    
    
    //PhysicContactDelegate
    func didBeginContact(contact: PhysicsContact) {
    
        var firstBody = contact.firstBody
        var secondBody = contact.secondBody
        //2 bodies are bubbles
        if firstBody.category == GameObjectType.BUBBLE && secondBody.category == GameObjectType.BUBBLE {
            
            var distance = distanceBetween(firstBody.position, pointB: secondBody.position)
            if distance > (firstBody.radius + secondBody.radius) {
                return
            }
            
            firstBody.velocity = 0
            firstBody.direction = Vector()
            
            secondBody.velocity = 0
            secondBody.direction = Vector()
            
            return
        }
        
        
        // one of the body is the wall
        if firstBody.category != GameObjectType.BUBBLE && secondBody.category == GameObjectType.BUBBLE {
            var tempBody = firstBody
            firstBody = secondBody
            secondBody = tempBody
    
        }
        
        if firstBody.category == GameObjectType.BUBBLE && secondBody.category == GameObjectType.TOP_WALL {
            firstBody.velocity = 0
            firstBody.direction = Vector(x: 0, y: 0)
            return
        }
        
        if firstBody.category == GameObjectType.BUBBLE && secondBody.category == GameObjectType.RIGHT_WALL {
            //reflect direction
       
            firstBody.direction = firstBody.direction.reflectionBy(Vector(x: -1, y: 0))
            
            return
        }
        
        if firstBody.category == GameObjectType.BUBBLE && secondBody.category == GameObjectType.LEFT_WALL {
            //reflect direction 
            firstBody.direction = firstBody.direction.reflectionBy(Vector(x: 1, y: 0))
            return
        }
    
        
    }

    
    func addBubbleToGrid(bubble: Bubble) -> (Int, Int)? {
        
        //add the bubble to the nearest empty cell in grid
        var minDist: CGFloat = CGFloat.infinity
        var rowNum = -1
        var colNum = -1
        let THRESHOLD = 2.5 * bubble.radius
                for var row = 0; row < bubbleGrid.count; row++ {
            var bubbleRow = bubbleGrid[row]
            for var col = 0; col < bubbleRow.count; col++ {
                var bubbleModel = bubbleRow[col]

                if bubbleModel.type == BubbleType.NO_BUBBLE {
                    var dist = distanceBetween(bubbleModel.center, pointB: bubble.center)
                    
                    //this will prevent the bubble to be attached in wrong places
                    if dist > THRESHOLD {
                        continue
                    }
                    
                    if dist < minDist {
                        minDist = dist
                        rowNum =  row
                        colNum = col
                    }
                }
            }
        }
        
        //no available cell
        if rowNum == -1 || colNum == -1 {
            return nil
        } else {
       
            
            var nearestBubbleInGrid = getBubbleInGridAt(rowNum, col: colNum)!
            nearestBubbleInGrid.updateType(bubble.type)
            
            self.removeGameObject(bubble)
            self.addStaticGameObject(nearestBubbleInGrid)
            
            //update bubble graph
            self.addNodeToBubbleGraphWithBubbleAt(rowNum, col: colNum)
            return (rowNum, colNum)
        }
    }
    
    //remove region with same color and from effect of special bubbles
    func removeRegionWithSameColorAt(row: Int, col: Int, minSizeToRemove: Int) -> [Bubble] {
        
        var returnArr = [Bubble]()
        var startNode = getBubbleNodeAt(row, col:col)!
        var nodesConnectedWithSameColor = self.bubbleGraph.getNodesConnectedWithSameColorFrom(startNode)
        
        //if there are at least minSizeToRemove bubbles to remove then remove
        if nodesConnectedWithSameColor.count >= minSizeToRemove {
            for removedNode in nodesConnectedWithSameColor {
                var nodeRow = removedNode.label.row
                var nodeCol = removedNode.label.col
            
                //set the type to no bubble and remove that bubble from game play
                var bubbleModel = getBubbleInGridAt(nodeRow, col: nodeCol)!
                
                returnArr.append(bubbleModel.getClone())
                self.removeStaticGameObject(bubbleModel)
                bubbleModel.updateType(BubbleType.NO_BUBBLE)

            }
            //remove nodes from the bubble graph
            bubbleGraph.removeNodes(nodesConnectedWithSameColor)

        }
        
        // if the bubble contacts a special bubble
        var neighborNodes = self.bubbleGraph.getNeighborOf(getBubbleNodeAt(row, col: col)!)
        
        //check the neighbors of contacting bubble
        for node in neighborNodes {
            var rowNum = node.label.row
            var colNum = node.label.col
            var bubbleModel = getBubbleInGridAt(rowNum, col: colNum)!
            
            if node.label.type == BubbleType.BOMB {
                returnArr += self.removeBubblesWithBombAt(rowNum, col: colNum)
                
            }
        
            if node.label.type == BubbleType.LIGHTNING {
                returnArr += self.removeBubblesWithLightningAt(rowNum, col: colNum)
              
            }
            
            if node.label.type == BubbleType.STAR {
                returnArr += self.removeBubblesWithStarAt(rowNum, col: colNum,type: startNode.label.type)
                
            }
        }
        
        return returnArr
    }
    
    
    //remove bubbles that are not connected to the ceilling bubbles (bubbles of row 0)
    func removeDisconnectedBubbles() -> [Bubble] {
        var bubblesAtCeiling = [BubbleNode]()
        var returnArr = [Bubble]()
        
        for var col = 0; col < bubbleGrid[0].count; col++ {
            
            var bubble = bubbleGrid[0][col]
            if bubble.type != BubbleType.NO_BUBBLE {
                bubblesAtCeiling.append(getBubbleNodeAt(0, col: col)!)
            }
        }
        
        
        var disconnectedBubbleNodes = self.bubbleGraph.getNodesNotConnectedWith(bubblesAtCeiling)
        
        if disconnectedBubbleNodes.count > 0 {
            for bubbles in disconnectedBubbleNodes {
                var rowNum = bubbles.label.row
                var colNum = bubbles.label.col
                var bubbleModel = getBubbleInGridAt(rowNum, col: colNum)!

                returnArr.append(bubbleModel.getClone())
                self.removeStaticGameObject(bubbleModel)
                bubbleModel.updateType(BubbleType.NO_BUBBLE)

            }
        }
        
        //remove all disconnected bubbles from graph
        self.bubbleGraph.removeNodes(disconnectedBubbleNodes)
        return returnArr
    }
    

    //for lighting bubbles
    func removeBubblesWithLightningAt(row: Int, col: Int) -> [Bubble] {
        var returnArr = [Bubble]()
        var indexArr = [(Int, Int)]()
        
        var lightningNode = self.getBubbleNodeAt(row, col: col)!
        
        if lightningNode.label.type == BubbleType.LIGHTNING {
            var nodesInRow = self.bubbleGraph.getNodesInTheSameRowWith(lightningNode)
            
            for node in nodesInRow {
                var rowNum = node.label.row
                var colNum = node.label.col
                
                var bubbleModel = self.getBubbleInGridAt(rowNum, col: colNum)!
                
                //just remove if this is not an indestructive or no bubble
                if isNormalBubble(bubbleModel) || bubbleModel.type == BubbleType.LIGHTNING {
                    indexArr.append((rowNum, colNum))
                }
            }
            
            returnArr += self.removeBubblesFromIndexArray(indexArr)
            
            for node in nodesInRow {
                var rowNum = node.label.row
                var colNum = node.label.col
                
                var bubbleModel = self.getBubbleInGridAt(rowNum, col: colNum)!
            
                if bubbleModel.type == BubbleType.BOMB {
                    returnArr += removeBubblesWithBombAt(rowNum, col: colNum)
                    
                }
            }
        }
        
        return returnArr
    }
    
    //for bomb bubbles
    func removeBubblesWithBombAt(row: Int, col: Int) -> [Bubble] {
        var returnArr = [Bubble]()
        var nodesToRemove = [BubbleNode]()
        var indexArr = [(Int, Int)]()
        
        var bombNode = self.getBubbleNodeAt(row, col: col)!
        if bombNode.label.type != BubbleType.BOMB {
            return returnArr
        }
        
        indexArr.append((row, col))
        
        var neighborOfBomb = self.getNeighborBubblesOfBubbleAt(row, col: col)
        //remove the neighbor of bomb
        for (rowNum, colNum) in neighborOfBomb {
            var bubbleModel = self.getBubbleInGridAt(rowNum, col: colNum)!
            if isNormalBubble(bubbleModel){
                indexArr.append((rowNum, colNum))
            }
        }

        returnArr += self.removeBubblesFromIndexArray(indexArr)
        
        for (rowNum, colNum) in neighborOfBomb {
            
            var bubbleModel = self.getBubbleInGridAt(rowNum, col: colNum)!
            if bubbleModel.type == BubbleType.LIGHTNING {
                returnArr += removeBubblesWithLightningAt(rowNum, col: colNum)
            } else if bubbleModel.type == BubbleType.BOMB {
                returnArr += removeBubblesWithBombAt(rowNum, col: colNum)
            }
        }
       
        return returnArr
    }
    
    
    // remove all bubbles having the same color of the bubble at index
    func removeBubblesWithStarAt(row: Int, col: Int, type: BubbleType) -> [Bubble] {
        var indexArr = [(Int, Int)]()
        
        var nodesArray = self.bubbleGraph.getNodesOfColor(type)
        var starBubble = getBubbleInGridAt(row, col: col)!
        indexArr.append((row, col))
        
        //get the array of bubbles of that color
        for node in nodesArray {
            var rowNum = node.label.row
            var colNum = node.label.col
            var bubbleModel = self.getBubbleInGridAt(rowNum, col: colNum)!
            
            indexArr.append((rowNum, colNum))
        }
        
        //remove from graph
        return self.removeBubblesFromIndexArray(indexArr)
        
    }
    
    //precond: row and col are valid
    func getBubbleInGridAt(row: Int, col: Int) -> Bubble? {
            return bubbleGrid[row][col]
      
    }
    
    func getBubbleNodeAt(row: Int, col: Int) -> BubbleNode? {
        
        if let bubbleModel = self.getBubbleInGridAt(row, col: col) {
            return BubbleNode(row: row, col: col, type: bubbleModel.type)
        } else {
            return nil
        }
    }
    
    
    
    func removeBubblesFromIndexArray(indexArr: [(Int,Int)]) -> [Bubble] {
        var nodesToRemove = [BubbleNode]()
        var returnArr = [Bubble]()
        
        for (rowIndex, colIndex) in indexArr {
            
            if let bubbleModel = getBubbleInGridAt(rowIndex, col: colIndex) {
                returnArr.append(bubbleModel.getClone())
                self.removeStaticGameObject(bubbleModel)
                bubbleModel.updateType(BubbleType.NO_BUBBLE)
            }
            
            if let bubbleNode = getBubbleNodeAt(rowIndex, col: colIndex) {
                nodesToRemove.append(bubbleNode)
            }
        }
        
        self.bubbleGraph.removeNodes(nodesToRemove)
        return returnArr
    }
    
    func getNeighborBubblesOfBubbleAt(row: Int, col: Int) -> [(Int, Int)] {
        var neighborsIndexArray = self.getNeighborsOfBubbleNodeAt(row, col: col)
        var indexArr = [(Int, Int)]()
        
        for index in neighborsIndexArray {
            if let bubbleModel = self.getBubbleInGridAt(index.0, col: index.1) {
                if bubbleModel.type != BubbleType.NO_BUBBLE {
                    indexArr.append(index)
                }
            }
        }
        
        return indexArr
        
    }
    
    func getNeighborsOfBubbleNodeAt(row: Int, col: Int) -> [(Int, Int)] {
        var neighborsIndexArray = [(Int, Int)]()
        
        var rowOffset = [-1, -1,  0, 0, 1, 1]
        // for odd row, the neighbors are (row-1, col), (row -1, col+1),(row, col -1),(row, col +1),(row +1, col), (row +1, col+1)
        var colOffsetForOddRow = [0, 1, -1, 1, 0,  1]
        //  for even row the neighbors are (row-1, col -1), (row -1, col),(row, col -1),(row, col +1),(row +1, col-1), (row +1, col)
        var colOffsetForEvenRow = [-1, 0, -1, 1, -1, 0]
        var colOffset: [Int]
        if row % 2 == 0 {
            colOffset = colOffsetForEvenRow
        } else {
            colOffset = colOffsetForOddRow
        }
        
        for var i = 0; i < 6; i++ {
            var newRow = row + rowOffset[i]
            var newCol = col + colOffset[i]
            
            //check for validity
            if newRow < 0 || newCol < 0 || newRow >= bubbleGrid.count || newCol >= bubbleGrid[newRow].count {
                continue
            }
            
            neighborsIndexArray.append((newRow, newCol))

        }
        
        return neighborsIndexArray
    }
    
    func addNodeToBubbleGraphWithBubbleAt(row: Int, col: Int)  {
        
        var newNode = getBubbleNodeAt(row, col: col)!
        self.bubbleGraph.addNode(newNode)
        
        //add the edges
        var neighborIndexArray = getNeighborsOfBubbleNodeAt(row, col: col)
        for (row, col) in neighborIndexArray {
            
            var bubbleModel = getBubbleInGridAt(row,col: col)!
            
            if bubbleModel.type != BubbleType.NO_BUBBLE {
                var neighborNode = getBubbleNodeAt(row, col: col)!
                var newEdge = BubbleEdge(source: newNode, destination: neighborNode)
                self.bubbleGraph.addEdge(newEdge)
            }
        }
        
    }
    
    func distanceBetween(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
        var xComponent: CGFloat = (pointA.x - pointB.x) * (pointA.x - pointB.x)
        var yComponent: CGFloat = (pointA.y - pointB.y) * (pointA.y - pointB.y)

        return sqrt(xComponent + yComponent)
        
    }
    
    
    //return number of bubbles in the grid
    func numberOfBubbles() -> Int {
        var count = 0
        for bubbleRow in bubbleGrid {
            for bubble in bubbleRow {
                if isNormalBubble(bubble) {
                    count++
                }
            }
        }
        return count
    }
    
    
    func isNormalBubble(bubble: Bubble) -> Bool {
        if bubble.type == BubbleType.BLUE || bubble.type == BubbleType.GREEN || bubble.type == BubbleType.ORANGE || bubble.type == BubbleType.RED {
            return true
        } else {
            return false
        }
    }
    
    //return the number of bubble of a certain type
    func getNumberBubblesOfType(type: BubbleType) -> Int {
        var count = 0
        for bubbleRow in bubbleGrid {
            for bubble in bubbleRow {
                if bubble.type == type {
                    count++
                }
            }
        }
        return count
    }
    
    func getBubbleHistogram() -> [BubbleType: Int] {
        
        var histogram = [BubbleType: Int]()
        // bubbles are  numbers from 1 to 4
        for var index = 1; index <= 4; index++ {
            if let bubbleType = BubbleType(rawValue: Int32(index)) {
                histogram[bubbleType] = getNumberBubblesOfType(bubbleType)
            }
        }
        return histogram
    }
    
    
    //keep a threshold to decide the scheme for generating bubbles
    func generateNextBubble() -> BubbleType {
        
        //if the number of bubbles are more than THRESHOLD, just generate the bubble randomly
        if numberOfBubbles() >= THRESHOLD || numberOfBubbles() == 0 {
            //generate a random number from 1 to 4
            var number = Int(arc4random()) % Constant.NUM_OF_NORMAL_BUBBLE_TYPE + 1
            return BubbleType(rawValue: Int32(number))!
        } else {
            //do not generate bubble types not in the grid
            
            var histogram = getBubbleHistogram()
            
            var bubbleSet = [Int: BubbleType]()
            var count = 0
            
            for var index = 1; index <= 4; index++ {
                if let bubbleType = BubbleType(rawValue: Int32(index)) {
                    if histogram[bubbleType] != 0  {
                        bubbleSet[count] = bubbleType
                        count++
                    }
                }
            }
            
            //now bubbleSet contains all types of bubble in the grid
            var number = Int(arc4random()) % count
            return bubbleSet[number]!
        }
    }

}
