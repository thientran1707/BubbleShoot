//
//  BubbleGraph.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 13/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//


class Graph {
    typealias N = BubbleNode
    typealias E = BubbleEdge
    
    var graph: [N : [E]]
    let isDirected: Bool
    
    //  A read-only computed property that contains all the nodes
    //  of the graphs.
    var nodes: [N] {
        
        var nodeSet = [N]()
        
        for node in graph.keys {
            nodeSet.append(node)
        }
        
        return nodeSet // Please remove this line in actual implementation.
    }
    

    //  A read-only computed property that contains all the edges
    //  of the graphs.
    var edges: [E] {
        
        var edgeSet = [E]()
        
        for neighbors in graph.values {
            for edge in neighbors {
                if find(edgeSet, edge) == nil {
                    edgeSet.append(edge)
                }
            }
        }
        
        return edgeSet
    }
    
    
    //  5 points
    //  Construct a direct or undirected graph.
    init(isDirected: Bool) {
        self.isDirected = isDirected
        self.graph = [N : [E]]()
    }
    
    //  5 points
    //  Add `addedNode` to the graph. If `addedNode` already exists
    //  in the graph, do nothing.
    func addNode(addedNode: N) {
        
        if !containsNode(addedNode) {
            graph[addedNode] = [E]()
        }
        
    }
    
    //  5 points
    //  Remove `removedNode` from the graph. If `removedNode` does
    //  not exist in the graph, do nothing.
    func removeNode(removedNode: N) {
        
        //remove node
        if containsNode(removedNode) {
            graph.removeValueForKey(removedNode)
        }
        
        //remove all edges connecting to that node
        
        for (node, neighbors) in graph {
            var arr = neighbors
            for (index,edge) in enumerate(arr) {
                if edge.destination == removedNode {
                    arr.removeAtIndex(index)
                }
            }
            
            graph[node] = arr
        }
        
    }
    
    //  5 points
    //  Return true if `targetNode` exists in the graph.
    func containsNode(targetNode: N) -> Bool {
        return graph[targetNode] != nil
    }
    
    //  5 points
    //  Add `addedEdge` to the graph. If `addedEdge` already exists,
    //  do nothing. If any of the nodes referenced in `eddedEdge` does
    //  not exist, add it to the graph.
    func addEdge(addedEdge: E) {
        
        if !containsEdge(addedEdge) {
            let sourceNode = addedEdge.source
            let destNode = addedEdge.destination
            
            //if any of the nodes does not exist, add it to the graph
            if !containsNode(sourceNode) {
                addNode(sourceNode)
            }
            
            if !containsNode(destNode) {
                addNode(destNode)
            }
            
            //add the edge
            if var arr = graph[sourceNode]{
                arr.append(addedEdge)
                graph[sourceNode] = arr
            }
            
            // if the graph is undirected, add the reversed edge to dest node
            if isDirected == false {
                let destNode = addedEdge.destination
                if var array = graph[destNode]{
                    array.append(addedEdge.reverse())
                    graph[destNode] = array
                }
            }
        }
        
    }
    
    //  5 points
    //  Remove `removedEdge` from the graph. If `removedEdge` does not
    //  exist, do nothing.
    func removeEdge(removedEdge: E) {
        
        if containsEdge(removedEdge) {
            
            let sourceNode = removedEdge.source
            if var arr = graph[sourceNode]{
                let index = find(arr,removedEdge)
                arr.removeAtIndex(index!)
                graph[sourceNode] = arr
            }
            
            
            if isDirected == false {
                let destNode = removedEdge.destination
                if var arr = graph[destNode]{
                    let index = find(arr,removedEdge.reverse())
                    arr.removeAtIndex(index!)
                    graph[destNode] = arr
                }
            }
        }
    }
    
    //  5 points
    //  Return true if `targetEdge` exists in the graph.
    func containsEdge(targetEdge: E) -> Bool {
        var isContained = false;
        
        for neighbors in graph.values {
            for edge in neighbors {
                if (edge == targetEdge) {
                    isContained = true
                    break
                }
            }
        }
        
        return isContained
    }
    
    //  5 points
    //  Return edges directed from `fromNode` to `toNode`.
    func edgesFromNode(fromNode: N, toNode: N) -> [E] {
        var edgeList = [E]()
        
        if let neighbors = graph[fromNode] {
            for edge in neighbors {
                if edge.destination == toNode {
                    edgeList.append(edge)
                }
            }
        }
        
        return edgeList
        
    }
    
    //  5 points
    //  Return adjacent nodes of the `fromNode` i.e. there
    //  is an directed edge from `fromNode` to its adjacent node.
    func adjacentNodesFromNode(fromNode: N) -> [N] {
        var adjacentNodes = [N]()
        
        if let neighbors = graph[fromNode] {
            for item in neighbors {
                adjacentNodes.append(item.destination)
            }
        }

        return adjacentNodes
    }
    
    
}

