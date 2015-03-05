
//
//  File.swift
//  BubbleShoot
//
//  Created by Tran Cong Thien on 25/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//
import UIKit

extension PlayViewController {
    
    func loadSystemLevelWithName(name: String) {
        
        if name == Constant.SYSTEM_LEVEL_1 {
            self.createPrepackageLevel1()
            return
        }
        
        if name == Constant.SYSTEM_LEVEL_2 {
            self.createPrepackageLevel2()
            return
        }
        
        if name == Constant.SYSTEM_LEVEL_3 {
            self.createPrepackageLevel3()
            return
        }
        
        self.createPrepackageLevel4()
        return
    }

    
    func createPrepackageLevel1() {
        
        self.prepareDefaultLevel()
        var bubblesInGrid = gameLevel!.bubbleGrid
        //row 0 to 2
        for var row = 0; row < 3; row++ {
            var bubbleRow = bubblesInGrid[row]
            for var col = 0; col < bubbleRow.count; col++ {
                bubbleRow[col].type = BubbleType.RED
            }
        }
        
        //row 3
        for var col = 1; col < 10; col++ {
            bubblesInGrid[3][col].type = BubbleType.GREEN
        }
        
        //row 4
        for var col = 3; col < 9; col++ {
            bubblesInGrid[4][col].type = BubbleType.ORANGE
        }
        
        //row 5
        for var col = 4; col < 10; col++ {
            bubblesInGrid[5][col].type = BubbleType.BLUE
        }
        
        //row 6
        for var col = 1; col < 6; col++ {
            bubblesInGrid[6][col].type = BubbleType.GREEN
        }
        
    }
    
    
    func createPrepackageLevel2() {
        
        self.prepareDefaultLevel()
        var bubblesInGrid = gameLevel!.bubbleGrid
        //row 0 to 2
        for var row = 0; row < 3; row++ {
            var bubbleRow = bubblesInGrid[row]
            for var col = 0; col < bubbleRow.count; col++ {
                bubbleRow[col].type = BubbleType.BLUE
            }
        }
        
        bubblesInGrid[0][5].type = BubbleType.GREEN
        bubblesInGrid[1][5].type = BubbleType.ORANGE
        bubblesInGrid[2][5].type = BubbleType.RED
        bubblesInGrid[2][6].type = BubbleType.ORANGE
        bubblesInGrid[3][7].type = BubbleType.INDESTRUCTIVE
        
        //row 3
        for var col = 1; col < 10; col++ {
            bubblesInGrid[3][col].type = BubbleType.RED
        }
        bubblesInGrid[3][5].type = BubbleType.ORANGE
        //row 4
        for var col = 3; col < 9; col++ {
            bubblesInGrid[4][col].type = BubbleType.ORANGE
        }
        
        //row 5
        for var col = 4; col < 10; col++ {
            bubblesInGrid[5][col].type = BubbleType.INDESTRUCTIVE
        }
        
        //row 6
        for var col = 1; col < 6; col++ {
            bubblesInGrid[6][col].type = BubbleType.GREEN
        }
        
        //row 7
        for var col = 4; col < 10; col++ {
            bubblesInGrid[7][col].type = BubbleType.BLUE
        }
        bubblesInGrid[7][1].type = BubbleType.BOMB
        bubblesInGrid[7][2].type = BubbleType.BOMB
    }
    
    
    func createPrepackageLevel3() {
        
        self.prepareDefaultLevel()
        var bubblesInGrid = gameLevel!.bubbleGrid
        //row 0 to 2
        for var row = 0; row < 3; row++ {
            var bubbleRow = bubblesInGrid[row]
            for var col = 0; col < bubbleRow.count; col++ {
                bubbleRow[col].type = BubbleType.ORANGE
            }
        }
        
        bubblesInGrid[0][5].type = BubbleType.RED
        bubblesInGrid[1][5].type = BubbleType.BOMB
        bubblesInGrid[2][5].type = BubbleType.RED
        bubblesInGrid[2][6].type = BubbleType.ORANGE
        bubblesInGrid[2][7].type = BubbleType.LIGHTNING
        
        //row 3
        for var col = 1; col < 10; col++ {
            bubblesInGrid[3][col].type = BubbleType.BLUE
        }
        bubblesInGrid[3][5].type = BubbleType.ORANGE
        //row 4
        for var col = 3; col < 9; col++ {
            bubblesInGrid[4][col].type = BubbleType.GREEN
        }
        
        //row 5
        for var col = 4; col < 10; col++ {
            bubblesInGrid[5][col].type = BubbleType.INDESTRUCTIVE
        }
        
        //row 6
        for var col = 1; col < 6; col++ {
            bubblesInGrid[6][col].type = BubbleType.RED
        }
        
        //row 7
        for var col = 4; col < 10; col++ {
            bubblesInGrid[7][col].type = BubbleType.ORANGE
        }
        bubblesInGrid[7][1].type = BubbleType.STAR
        bubblesInGrid[7][2].type = BubbleType.STAR
    }
    
    
    func createPrepackageLevel4() {
        
        self.prepareDefaultLevel()
        var bubblesInGrid = gameLevel!.bubbleGrid
        //row 0 to 2
        for var row = 0; row < 3; row++ {
            var bubbleRow = bubblesInGrid[row]
            for var col = 0; col < bubbleRow.count; col++ {
                bubbleRow[col].type = BubbleType.GREEN
            }
        }
        
        bubblesInGrid[0][5].type = BubbleType.RED
        bubblesInGrid[1][5].type = BubbleType.BOMB
        bubblesInGrid[2][5].type = BubbleType.RED
        bubblesInGrid[2][6].type = BubbleType.ORANGE
        bubblesInGrid[2][7].type = BubbleType.LIGHTNING
        
        //row 3
        for var col = 1; col < 10; col++ {
            bubblesInGrid[3][col].type = BubbleType.LIGHTNING
        }
        bubblesInGrid[3][5].type = BubbleType.ORANGE
        //row 4
        for var col = 3; col < 9; col++ {
            bubblesInGrid[4][col].type = BubbleType.RED
        }
        
        //row 5
        for var col = 4; col < 10; col++ {
            bubblesInGrid[5][col].type = BubbleType.BOMB
        }
        
        //row 6
        for var col = 1; col < 6; col++ {
            bubblesInGrid[6][col].type = BubbleType.BLUE
        }
        
        //row 7
        for var col = 4; col < 10; col++ {
            bubblesInGrid[7][col].type = BubbleType.RED
        }
        bubblesInGrid[7][1].type = BubbleType.STAR
        bubblesInGrid[7][2].type = BubbleType.STAR
        
        //row 8
        for var col = 4; col < 9; col++ {
            bubblesInGrid[8][col].type = BubbleType.INDESTRUCTIVE
        }
        
        //row 9 
        for var col = 5; col < 9; col++ {
            bubblesInGrid[9][col].type = BubbleType.INDESTRUCTIVE
        }
    }
    
    
    func showCongratulationScreen() {
        
        //firework emitter layer
        var emitterLayer = CAEmitterLayer()
        var emitterFrame = self.gameArea.frame
        
        emitterLayer.emitterPosition = CGPointMake(emitterFrame.origin.x + emitterFrame.size.width / 2, emitterFrame.origin.y + emitterFrame.size.height / 2)
        emitterLayer.renderMode = kCAEmitterLayerAdditive
        emitterLayer.birthRate = 30
        
        //fire work rocket
        var firework = CAEmitterCell()
        firework.emissionLongitude = -CGFloat(M_PI ) / CGFloat(2)
        firework.emissionLatitude = 0
        firework.emissionRange = 2 * CGFloat(M_PI)
        firework.lifetime = 1.5
        firework.birthRate = 2
        firework.velocity = 500
        firework.velocityRange = 250
        firework.yAcceleration = -60
        firework.color = UIColor.grayColor().CGColor
        firework.redRange = 0.5
        firework.greenRange = 0.5
        firework.blueRange = 0.5
        
        //firework rocket flare
        var flare = CAEmitterCell()
        flare.contents = UIImage(named: Constant.SPARK_IMAGE)!.CGImage!
        flare.emissionLongitude = CGFloat(4 * M_PI) / 2
        flare.scale = 0.4
        flare.velocity = 100
        flare.birthRate = 45
        flare.lifetime = 3
        flare.yAcceleration = 350
        flare.emissionRange = 2 * CGFloat(M_PI)
        flare.alphaSpeed = -0.7
        flare.scaleSpeed = -0.1
        flare.scaleRange = 0.1
        flare.beginTime = 0.01
        flare.duration = 0.7
        
        //explosion
        var explosion = CAEmitterCell()
        explosion.contents = UIImage(named: Constant.SPARK_IMAGE)!.CGImage!
        explosion.birthRate = 9000
        explosion.scale = 0.6
        explosion.velocity = 100
        explosion.lifetime = 1
        explosion.alphaSpeed = -0.2
        explosion.yAcceleration = 50
        explosion.beginTime = 0.95
        explosion.duration = 0.1
        explosion.emissionRange = 2 * CGFloat(M_PI)
        explosion.scaleSpeed = -0.5
        explosion.spin = 2
        
        //preSpark
        var preSpark = CAEmitterCell()
        preSpark.birthRate = 80
        preSpark.velocity = explosion.velocity * 0.8
        preSpark.lifetime = 1.5
        preSpark.yAcceleration = -explosion.yAcceleration * 0.5
        preSpark.beginTime = explosion.beginTime - 0.1
        preSpark.emissionRange = explosion.emissionRange
        preSpark.color = UIColor.whiteColor().CGColor
        preSpark.redSpeed = 100
        preSpark.greenSpeed = 100
        preSpark.blueSpeed = 100
        preSpark.scale = 1.2
        
        //spark
        var spark = CAEmitterCell()
        spark.contents = UIImage(named: Constant.SPARK_IMAGE)!.CGImage!
        spark.lifetime = 0.05
        spark.yAcceleration = -250
        spark.beginTime = 0.7
        spark.scale = 0.4
        spark.birthRate = 10
        
        //configure the emitter cells
        preSpark.emitterCells = [spark]
        firework.emitterCells = [flare, explosion, preSpark]
        emitterLayer.emitterCells = [firework]
        
        self.gameArea.layer.addSublayer(emitterLayer)
    }    
}