//
//  Bubble.swift
//  LevelDesigner
//
//  Created by Tran Cong Thien on 1/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//
import UIKit
let KEY_FOR_TYPE = "type"
let KEY_FOR_RADIUS = "radius"
let KEY_FOR_CENTERX = "centerX"
let KEY_FOR_CENTERY = "centerY"

enum BubbleType: Int32 {
    case BLUE = 1
    case GREEN = 2
    case ORANGE = 3
    case RED = 4
    case INDESTRUCTIVE = 5
    case LIGHTNING = 6
    case BOMB = 7
    case STAR = 8
    case NO_BUBBLE = 0
}

class Bubble : GameObject {
    
    var type: BubbleType
    var radius: CGFloat
    var center: CGPoint
    var delegate: BubbleDelegate?
    
    //default constructor,type is NO_BUBBLE, radius is 1 , center is (0, 0)
    override init() {
        
        self.type = BubbleType.NO_BUBBLE
        self.radius = 0.0
        self.center = CGPoint(x: 0.0,y: 0.0)
        super.init()
    }
    
    
    //constructor with type, radius and center
    init(type: BubbleType, radius: CGFloat, center: CGPoint) {
        
        self.type = type
        self.radius = radius
        self.center = center
        super.init()
    }
    
    
    //update new type for self
    func updateType(type: BubbleType){
        
        self.type = type
        self.delegate!.changeBubbleType(self)
    }
    
    
    //update new radius for self
    func updateRadius(radius: CGFloat){
        
        self.radius = radius
        self.delegate!.changeBubbleCenterAndRadius(self)
    }
    
    
    //update the new center for self
    func updateCenter(center: CGPoint) {
        
        self.center = center
        self.delegate!.changeBubbleCenterAndRadius(self)
    }
    
    
    func updateCenterAndRadius(center: CGPoint, radius: CGFloat) {
        
        self.center = center
        self.radius = radius
        self.delegate!.changeBubbleCenterAndRadius(self)
    }
    
    func getClone() -> Bubble {
        var newType = self.type
        var newRadius = self.radius
        var newCenter = self.center
        
        return Bubble(type: newType, radius: newRadius, center: newCenter)
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        
        //This tells the archiver how to encode the object
        coder.encodeInt(self.type.rawValue, forKey: KEY_FOR_TYPE)
        coder.encodeDouble(Double(self.radius), forKey: KEY_FOR_RADIUS)
        coder.encodeDouble(Double(self.center.x), forKey: KEY_FOR_CENTERX)
        coder.encodeDouble(Double(self.center.y), forKey: KEY_FOR_CENTERY)
    }
    
    
    required convenience init(coder decoder: NSCoder) {
        
        self.init()
        //this tells the archiver how to decode the object
        self.type = BubbleType(rawValue: decoder.decodeIntForKey(KEY_FOR_TYPE))!
        self.radius = CGFloat(decoder.decodeDoubleForKey(KEY_FOR_RADIUS))
        self.center = CGPointMake(CGFloat(decoder.decodeDoubleForKey(KEY_FOR_CENTERX)), CGFloat(decoder.decodeDoubleForKey(KEY_FOR_CENTERY)))
    }
}


//this protocol will notify the bubble controller about the change of model when we load new level to the game
protocol BubbleDelegate {
    
    //change the type of the bubble
    func changeBubbleType(bubbleEntity: Bubble)
    
    //change the center and radius of the bubble
    func changeBubbleCenterAndRadius(bubbleEntity: Bubble)
}


