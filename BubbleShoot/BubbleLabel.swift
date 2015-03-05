//
//  BubbleLabel.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 14/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//
import Foundation

struct BubbleLabel: Hashable {
    var row: Int
    var col: Int
    var type: BubbleType
    
    var hashValue: Int {
        //create hash value from string
        var stringToHash = NSString(format: "%ul-%ul", row, col)
        return stringToHash.hashValue
    }
    
    init() {
        self.row = 0
        self.col = 0
        self.type = BubbleType.NO_BUBBLE
    }
    
    init(row: Int, col: Int, type: BubbleType) {
        self.row = row
        self.col = col
        self.type = type
    }
    
}

extension BubbleLabel: Equatable {
    
}
//  Return true if `lhs` node is equal to `rhs` node.
func ==(lhs: BubbleLabel, rhs: BubbleLabel) -> Bool {
    return lhs.row == rhs.row && lhs.col == rhs.col
}