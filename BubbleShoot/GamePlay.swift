//
//  GameWorld.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 12/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
import UIKit

class GamePlay: NSObject {
    
    var contactDelegate: PhysicsContactDelegate?
    var gameObjectArray: [GameObject]
    var staticGameObjectArray: [GameObject]
    
    override init() {
        gameObjectArray = [GameObject]()
        staticGameObjectArray = [GameObject]()
        super.init()
    }
    
    
    func addGameObject(gameObject: GameObject) {
        gameObjectArray.append(gameObject)
    }
    
    func addStaticGameObject(gameObject: GameObject) {
        staticGameObjectArray.append(gameObject)
    }
    
    
    func addGameObjectFromArray(gameObjectInput: [GameObject]) {
        for gameObject in gameObjectInput {
            addGameObject(gameObject)
        }
    }
    
    func addStaticGameObjectFromArray(gameObjectInput: [GameObject]) {
        for gameObject in gameObjectInput {
            addStaticGameObject(gameObject)
        }
    }
    
    
    func removeGameObject(gameObject: GameObject) {
        
        //if the gameObject is in the array, remove it
        if let index = find(gameObjectArray, gameObject) {
            self.gameObjectArray.removeAtIndex(index)
        }
    }
    
    func removeStaticGameObject(gameObject: GameObject) {
        
        //if the gameObject is in the array, remove it
        if let index = find(staticGameObjectArray, gameObject) {
            self.staticGameObjectArray.removeAtIndex(index)
    
        }
    }
    
  
    func removeGameObjectFromArray(gameObjectInput: [GameObject]) {
        for gameObjectToRemove in gameObjectInput {
            self.removeGameObject(gameObjectToRemove)
        }
        
    }
    
    func removeStaticGameObjectFromArray(gameObjectInput: [GameObject]) {
        for gameObjectToRemove in gameObjectInput {
            self.removeStaticGameObject(gameObjectToRemove)
        }
        
    }
    
    func updatePhysicsAndContact(timeInterval: NSTimeInterval) {
        
        //just update dynamic gameObjects
        PhysicsEngine.updatePhysicsOfGameObjects(gameObjectArray, timeInterval: timeInterval)
       
        //update contact 
        //check contact between objects
       for var i = 0; i < gameObjectArray.count; i++ {
            var objectOne = gameObjectArray[i]
            for var j = i+1  ; j < gameObjectArray.count; j++ {
                var objectTwo = gameObjectArray[j]
                    
                //if the contact is possible, set the contact
                if PhysicsEngine.checkContact(objectOne, objectB: objectTwo) {
            
                    var contact = PhysicsContact(firstBody: objectOne.physicsBody, secondBody: objectTwo.physicsBody)
                    self.contactDelegate!.didBeginContact(contact)
                }
            }
        }
        
        for var i = 0; i < gameObjectArray.count; i++ {
            var objectOne = gameObjectArray[i]
            for var j = 0  ; j < staticGameObjectArray.count; j++ {
            
                var objectTwo = staticGameObjectArray[j]
                    
                    //if the contact is possible, set the contact
                    if PhysicsEngine.checkContact(objectOne, objectB: objectTwo) {
                        
                        var contact = PhysicsContact(firstBody: objectOne.physicsBody, secondBody: objectTwo.physicsBody)
                        self.contactDelegate!.didBeginContact(contact)
                }
            }
        }
        
    }
}