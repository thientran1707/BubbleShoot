//
//  BubbleNode.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 14/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
class BubbleNode: Hashable{
    var label: BubbleLabel
    var hashValue: Int {
        return label.hashValue
    }
    
    //init from a bubble Node
    init(bubbleLabel: BubbleLabel) {
        self.label = bubbleLabel
    }

    //init from row, col and bubble type
    init(row: Int, col: Int, type: BubbleType) {
        self.label = BubbleLabel(row: row, col: col, type: type)
    }
}

extension BubbleNode: Equatable {
    
}
//  Return true if `lhs` node is equal to `rhs` node.
func ==(lhs: BubbleNode, rhs: BubbleNode) -> Bool {
    return lhs.label == rhs.label
}

