//
//  PhysicContact.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 12/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

//represent a physical contact between 2 bodies
class PhysicsContact: NSObject {
    
    var firstBody: PhysicsBody
    var secondBody: PhysicsBody
    
    init(firstBody: PhysicsBody, secondBody: PhysicsBody) {
        self.firstBody = firstBody
        self.secondBody = secondBody
        super.init()
    }
}

