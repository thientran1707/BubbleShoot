//
//  Edge.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 13/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

class BubbleEdge {
    typealias N = BubbleNode
    
    var source: N
    var destination: N
    var weight = 1.0
    
    //  Construct an edge from `source` to `destination` with the
    //  default cost of 1.0.
    init(source: N, destination: N) {
        self.source = source
        self.destination = destination
    }
    
    //  Construct an edge from `source` to `destination` with the
    //  cost of `weight`.
    init(source: N, destination: N, weight: Double) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
    
    //  Return an edge in the opposite direction with the same cost.
    func reverse() -> BubbleEdge{
        return BubbleEdge(source: destination, destination: source, weight: weight)
    }
    
    //  Check the representation invariants.
    private func _checkRep() {
        assert(weight >= 0, "Edge's weight cannot be negative.")
    }
}


extension BubbleEdge : Equatable {
}


//  Return true if `lhs` edge is equal to `rhs` edge.
func ==(lhs: BubbleEdge, rhs: BubbleEdge) -> Bool {
    return lhs.source == rhs.source && lhs.destination == rhs.destination && lhs.weight == rhs.weight
}