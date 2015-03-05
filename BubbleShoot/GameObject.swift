//
//  GameObject.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 11/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

enum GameObjectType: Int{
    case BUBBLE = 0
    case TOP_WALL = 1
    case LEFT_WALL = 2
    case RIGHT_WALL = 3
}

class GameObject: NSObject {
    
    var physicsBody: PhysicsBody
    
    override init() {
        physicsBody = PhysicsBody()
    }
    
    init(circleOfRadius: CGFloat) {
        self.physicsBody = PhysicsBody(circleOfRadius: circleOfRadius)
    }
    

    init(lineFromPoint: CGPoint, lineToPoint: CGPoint) {
        self.physicsBody = PhysicsBody(lineFromPoint: lineFromPoint, lineToPoint: lineToPoint)
    }
}
