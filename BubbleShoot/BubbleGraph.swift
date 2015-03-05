//
//  BubbleGridGraph.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 14/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation
class BubbleGraph : Graph{
    
    //init to create a undirected graph
    init() {
        super.init(isDirected: false)
    }
    
    
    //used BFS to find the connected nodes with the same color with the start node
    func getNodesConnectedWithSameColorFrom(startNode: BubbleNode) -> [BubbleNode]{
        
        //return empty aray if start node does not have a color
        if startNode.label.type == BubbleType.NO_BUBBLE {
            return [BubbleNode]()
        }
        
        var queue = Queue<BubbleNode>()
        var isVisited = [BubbleNode: Bool]()
        var wantedType = startNode.label.type
        var nodesArray = [BubbleNode]()
        
        for node in graph.keys {
            isVisited[node] = false
        }
        
        queue.enqueue(startNode)
        isVisited[startNode] = true
        while !queue.isEmpty {
            
            if let vertex = queue.dequeue() {
                nodesArray.append(vertex)
                
                var neighbors = self.adjacentNodesFromNode(vertex)
                
                    for node in neighbors {
                        if isVisited[node] == false && node.label.type == wantedType {
                            isVisited[node] = true
                            queue.enqueue(node)
                    }
                }
            }
            
        }
        
        return nodesArray
    }
    
    //perfom BFS to find list of bubble nodes that are connected to start node
    func getNodesConnectedWith(startNode: BubbleNode) -> [BubbleNode]{
        var queue = Queue<BubbleNode>()
        var isVisited = [BubbleNode: Bool]()
        
        var nodesArray = [BubbleNode]()
        
        //mark as unvisited
        for node in graph.keys {
            isVisited[node] = false
        }
        
        queue.enqueue(startNode)
         isVisited[startNode] = true
        while !queue.isEmpty {
            
            if let vertex = queue.dequeue() {
               
                nodesArray.append(vertex)
                
                if let neighbors = graph[vertex] {
                    for edge in neighbors {
                        var dest = edge.destination
                        if isVisited[dest] == false  && dest.label.type != BubbleType.NO_BUBBLE {
                            isVisited[dest] = true
                            queue.enqueue(dest)
                        }
                    }
                }
            }
        }
        
        return nodesArray
    }
    
    //get the nodes of a color
    func getNodesOfColor(type: BubbleType) -> [BubbleNode] {
        var nodesArray = [BubbleNode]()
        
        for node in nodes {
            if node.label.type == type {
                nodesArray.append(node)
            }
        }
        
        return nodesArray
    }
    
    //get the neighbors of a node
    func getNeighborOf(node: BubbleNode) -> [BubbleNode] {
        
        return self.adjacentNodesFromNode(node)
    }
    
    func getNodesInTheSameRowWith(startNode: BubbleNode) -> [BubbleNode] {
        var nodesArray = [BubbleNode]()
        for node in nodes {
            if node.label.row == startNode.label.row {
                nodesArray.append(node)
            }
        }
        
        return nodesArray
    }
    
    
    func getNodesNotConnectedWith(startNodeArray: [BubbleNode]) -> [BubbleNode] {
        
        var nodesInGraph = nodes
        var nodesArray = [BubbleNode]()
     
        var nodesConnected = [BubbleNode]()
        
        //find the list of nodes connected to nodes in start node array
        for start in startNodeArray {
            var nodeArray = getNodesConnectedWith(start)
            for node in nodeArray {
                if find(nodesConnected, node) == nil {
                    nodesConnected.append(node)
                }
            }
        }
        
        //find the list of nodes not connected to nodes in start node array
        for node in nodesInGraph {
            if find(nodesConnected, node) == nil {
                nodesArray.append(node)
            }
        }
        return nodesArray
    }
    
    
    func removeNodes(nodeArray: [BubbleNode]) {
        
        for node in nodeArray {
            removeNode(node)
        }
    }
    
}
