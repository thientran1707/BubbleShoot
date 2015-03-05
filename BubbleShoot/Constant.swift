//
//  Constant.swift
//  LevelDesigner
//
//  Created by Tran Cong Thien on 8/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit
import AVFoundation

struct Constant {
    
    static let EXTENSION_FOR_SAVING = ".out"
    static let KEY_FOR_GAME_LEVEL = "modelKeyString"
    static let GAME_LEVEL_FILE = "gameLevel.plist"
    static let TOP_SCORE_FILE = "topScore.plist"
    static let SYSTEM_LEVEL_1 = "System Level 1"
    static let SYSTEM_LEVEL_2 = "System Level 2"
    static let SYSTEM_LEVEL_3 = "System Level 3"
    static let SYSTEM_LEVEL_4 = "System Level 4"
    static let BLUE_BUBBLE_IMAGE = "bubble-blue.png"
    static let GREEN_BUBBLE_IMAGE = "bubble-green.png"
    static let ORANGE_BUBBLE_IMAGE = "bubble-orange.png"
    static let RED_BUBBLE_IMAGE = "bubble-red.png"
    static let INDESTRUCTIVE_BUBBLE_IMAGE = "bubble-indestructible.png"
    static let LIGHTNING_BUBBLE_IMAGE = "bubble-lightning.png"
    static let BOMB_BUBBLE_IMAGE = "bubble-bomb.png"
    static let STAR_BUBBLE_IMAGE = "bubble-star.png"
    static let CANNON_BASE_IMAGE = "cannon-base.png"
    static let CANNON_IMAGE = "cannon.png"
    static let BURST_IMAGE = "bubble-burst.png"
    static let SPARK_IMAGE = "spark.png"
    static let BACKGROUND_IMAGE = "background.png"
    static let NUM_OF_SECTION = 13
    static let DEFAULT_LEVEL_NAME = "Default"
    static let NUM_OF_NORMAL_BUBBLE_TYPE = 4
    
    
    static func getSystemLevelList() -> [String]{
        
        return [SYSTEM_LEVEL_1, SYSTEM_LEVEL_2, SYSTEM_LEVEL_3, SYSTEM_LEVEL_4]
    }
    
    //return the image from the type of bubble
    static func getImageFromType(type: BubbleType) -> UIImage? {
        
        switch type {
        case .BLUE:
            return UIImage(named: BLUE_BUBBLE_IMAGE)
            
        case .GREEN:
            return UIImage(named: GREEN_BUBBLE_IMAGE)
            
        case .ORANGE:
            return UIImage(named: ORANGE_BUBBLE_IMAGE)
            
        case .RED:
            return UIImage(named: RED_BUBBLE_IMAGE)
         
        case .INDESTRUCTIVE:
            return UIImage(named: INDESTRUCTIVE_BUBBLE_IMAGE)
            
        case .LIGHTNING:
            return UIImage(named: LIGHTNING_BUBBLE_IMAGE)
            
        case .BOMB:
            return UIImage(named: BOMB_BUBBLE_IMAGE)
            
        case .STAR:
            return UIImage(named: STAR_BUBBLE_IMAGE)
            
        default:
            //return a circle for NO_BUBBLE
            return drawCircle()
        }
    }
    
    
    //draw a circle and return as an image
    static func drawCircle() -> UIImage {
        let RADIUS: CGFloat = 100
        let sizeFrame = CGSize(width: 2 * RADIUS  , height: 2 * RADIUS )
        
        var circle = CAShapeLayer()
        circle.frame = CGRectMake(0, 0, 2 * RADIUS, 2 * RADIUS)
        
        circle.path = UIBezierPath(roundedRect:CGRectMake(0, 0,
            2.0 * RADIUS, 2.0 * RADIUS), cornerRadius: RADIUS).CGPath;
        
        // Configure the apperence of the circle
        circle.fillColor = UIColor.lightGrayColor().CGColor
        circle.strokeColor = UIColor.blackColor().CGColor
        circle.lineWidth = 3;
        
        UIGraphicsBeginImageContext(sizeFrame)
        circle.renderInContext(UIGraphicsGetCurrentContext())
        var circleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return circleImage
    }
    
    
    
}