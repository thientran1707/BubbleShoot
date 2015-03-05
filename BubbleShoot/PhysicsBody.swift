//
//  PhysicBody.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 11/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//
import UIKit

enum BodyType : Int {
    case CIRCLE_BODY = 0
    case LINE_BODY = 1
}

//Physic Body will have circle body or line body
class PhysicsBody: NSObject{
    
    //direction is the unit vector
    var direction: Vector
    var position: CGPoint
    var velocity: CGFloat
    var bodyType: BodyType
    
    var category: GameObjectType
    
    //for circle body
    var radius: CGFloat
    
    
    //for line body
    var fromPoint: CGPoint
    var toPoint: CGPoint
    
    //default init
    override init() {
        self.direction = Vector(x: 0, y: 0)
        self.position = CGPointMake(0, 0)
        self.velocity = 0
        self.bodyType = BodyType.CIRCLE_BODY
        
        self.category = GameObjectType.BUBBLE
        
        self.radius = 0
        
        self.fromPoint = CGPointMake(0, 0)
        self.toPoint = CGPointMake(0, 0)
        super.init()
        
        
    }
    
    convenience init(circleOfRadius: CGFloat) {
        self.init()
        self.bodyType = BodyType.CIRCLE_BODY
        self.radius = circleOfRadius
        
    }
    
    convenience init(lineFromPoint: CGPoint, lineToPoint: CGPoint) {
        self.init()
        self.bodyType = BodyType.LINE_BODY
        self.fromPoint = lineFromPoint
        self.toPoint = lineToPoint
    }
    
    //set the direction 
    func setDirection( direction: Vector) {
        if direction.isZero() {
            self.direction = Vector()
        } else {
            self.direction = direction.normalize()
    }
        }
}
