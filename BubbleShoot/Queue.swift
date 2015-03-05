//
//  Queue.swift
//  GamePlay
//
//  Created by Tran Cong Thien on 14/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import Foundation

struct Queue<T> {
    private var items = [T]()
    
    mutating func enqueue(item: T) {
        items.append(item)
        
    }
    
    //  Removes an element the head of the queue and return it.
    //  If the queue is empty, return nil.
    mutating func dequeue() -> T? {
        if items.count == 0 {
            return nil
        } else {
            return items.removeAtIndex(0)
        }
    }
    
    //  Returns, but does not remove, the element at the head of the queue.
    //  If the queue is empty, returns nil.
    func peek() -> T? {
        if items.count == 0 {
            return nil
        } else {
            return items[0]
        }
    }
    
    // Returns the number of elements currently in the queue.
    var count: Int {
        return items.count
    }
    
    //  Returns true if the queue is empty and false otherwise.
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    //  Removes all elements in the queue.
    mutating func removeAll() {
        items.removeAll()
    }
    
    //  Returns the array of elements of the queue in the order
    //  that they are dequeued i.e. first element in the array
    //  is the first element dequeued.
    func toArray() -> [T] {
        return items
    }
}
