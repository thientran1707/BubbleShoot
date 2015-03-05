//
//  Vector.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 11/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//
import UIKit
import Darwin

struct Vector {
    var x: CGFloat
    var y: CGFloat
    
    //default constructor, this will create a zero vector
    init() {
        self.x = 0
        self.y = 0
    }
    
    //init with xValue and yValue
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    //init with a vector
    init(vector: Vector) {
        self.x = vector.x
        self.y = vector.y
    }
    
    //init with 2 points
    init(from: CGPoint, to: CGPoint) {
        self.x = to.x - from.x
        self.y = to.y - from.y
    }
    
    func add(vector: Vector) -> Vector{
        var newX = self.x + vector.x
        var newY = self.y + vector.y
        
        return Vector(x: newX, y: newY)
    }
    
    func subtract(vector: Vector) -> Vector {
        var newX = self.x - vector.x
        var newY = self.y - vector.y
        
        return Vector(x: newX, y: newY)
    }
    
    func scalarMultiplyWith(scalar: CGFloat) -> Vector {
        return Vector(x: scalar * self.x, y: scalar * self.y)
    }
    
    func dotProductWith(vector: Vector) -> CGFloat {
        return self.x * vector.x + self.y * vector.y
    }
    
    func magnitude() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    
    //return the angle in radians
    func angleWith(vector: Vector) -> CGFloat {
        
        if self.isZero() {
            return 0
        } else {
            return acos(self.dotProductWith(vector) / (self.magnitude() * vector.magnitude()))
        }
    }
    
    func projectionOfVector(vector: Vector) -> Vector {
        
        if self.isZero() {
            return Vector(x: 0, y: 0)
        } else {
            var scalar = self.dotProductWith(vector)/(self.magnitude() * self.magnitude())
            return self.scalarMultiplyWith(scalar)
        }
    }
    
    
    func vectorTranslation(sourcePoint: CGPoint) -> CGPoint {
        return CGPointMake(sourcePoint.x + self.x, sourcePoint.y + self.y)
    }
    
    
    func reflectionBy(vector: Vector) -> Vector{
        if vector.isZero() {
            return Vector()
        } else {
            var scalar = 2.0  * self.dotProductWith(vector) /   (vector.magnitude() * vector.magnitude())
            
            return self.subtract(vector.scalarMultiplyWith(scalar))
        }
    }
    
    
    //normalize the vector to has length 1
    func normalize() -> Vector {
        var scalar = 1 / (self.magnitude())
        return self.scalarMultiplyWith(scalar)
    }
    
    
    //check if the vector is zero vector
    func isZero() -> Bool {
        return self.x == 0 && self.y == 0
    }
    
    
    
}

