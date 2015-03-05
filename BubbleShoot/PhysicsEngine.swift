//
//  PhysicEngine.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 12/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class PhysicsEngine: NSObject{
    
    
    class func updatePhysicsOfGameObject(gameObject: GameObject, timeInterval: NSTimeInterval) {
        
        var scalar = gameObject.physicsBody.velocity * CGFloat(timeInterval)
        var moveVector = gameObject.physicsBody.direction.scalarMultiplyWith(scalar)
       
        if gameObject.physicsBody.bodyType == BodyType.CIRCLE_BODY {
            gameObject.physicsBody.position = moveVector.vectorTranslation(gameObject.physicsBody.position)
        } else {
            gameObject.physicsBody.position = moveVector.vectorTranslation(gameObject.physicsBody.position)
            gameObject.physicsBody.fromPoint = moveVector.vectorTranslation(gameObject.physicsBody.fromPoint)
            gameObject.physicsBody.toPoint = moveVector.vectorTranslation(gameObject.physicsBody.toPoint)
        }
    }
    
    
    class func updatePhysicsOfGameObjects(gameObjectArray: [GameObject], timeInterval: NSTimeInterval) {
        
        for gameObject in gameObjectArray {
            if !gameObject.physicsBody.direction.isZero() {
                //the object moves
                updatePhysicsOfGameObject(gameObject, timeInterval: timeInterval)
                
            }
            
        }
    }
        
    class func checkContactBetweenCircleBodies(circleA: PhysicsBody, circleB: PhysicsBody) -> Bool{
        
        var centerVector = Vector(from: circleA.position, to: circleB.position)
        
        if centerVector.magnitude() <= circleA.radius + circleB.radius {
            return true
        } else {
            return false
        }
    }
    
    
    class func checkContactBetweenCircleAndLineBody(circleBody: PhysicsBody, lineBody: PhysicsBody) -> Bool {
        
        var distanceFromCenterToLine = PhysicsEngine.computeDistanceFromPointToLine(circleBody.position, startLinePoint: lineBody.fromPoint, endLinePoint: lineBody.toPoint)
        
        if distanceFromCenterToLine <= circleBody.radius {
            return true
        } else {
            return false
        }
    }
    
    //check contact between 2 objects
    class func checkContact(objectA: GameObject, objectB: GameObject) -> Bool {
        
        if objectA.physicsBody.bodyType == BodyType.CIRCLE_BODY && objectB.physicsBody.bodyType == BodyType.CIRCLE_BODY {
            return checkContactBetweenCircleBodies(objectA.physicsBody, circleB: objectB.physicsBody)
        }
        
        if objectA.physicsBody.bodyType == BodyType.CIRCLE_BODY && objectB.physicsBody.bodyType == BodyType.LINE_BODY {
            return checkContactBetweenCircleAndLineBody(objectA.physicsBody, lineBody: objectB.physicsBody)
        }
        
        if objectA.physicsBody.bodyType == BodyType.LINE_BODY && objectB.physicsBody.bodyType == BodyType.CIRCLE_BODY {
            return checkContactBetweenCircleAndLineBody(objectB.physicsBody, lineBody: objectA.physicsBody)
        }
        
        return false
    }
    
    class func computeDistanceFromPointToLine(point: CGPoint, startLinePoint: CGPoint, endLinePoint: CGPoint) -> CGFloat{
        
        var lineVector = Vector(from: startLinePoint, to: endLinePoint)
        return fabs(lineVector.y * (point.x - startLinePoint.x) - lineVector.x * (point.y - startLinePoint.y)) / lineVector.magnitude()
    }
    
    
}
