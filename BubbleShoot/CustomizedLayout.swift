//
//  myFlowLayout.swift
//  LevelDesigner
//
//  Created by Tran Cong Thien on 31/1/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit
import Darwin // to use Math function

//customize the layout
class CustomizedLayout: UICollectionViewFlowLayout {
    
    var radius: CGFloat?
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    
    init(_radius: CGFloat) {
        
        self.radius = _radius
        super.init()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.estimatedItemSize = CGSizeMake ( 2 * radius!, 2 * radius!)
        self.itemSize = CGSizeMake ( 2 * radius!, 2 * radius!)
    }
    
    
    override func layoutAttributesForElementsInRect( rect: CGRect) -> [AnyObject]? {
        
        let allAttributesInRect = super.layoutAttributesForElementsInRect(rect)
        var newAttributesArray = [AnyObject]()
        for cellAttributes in allAttributesInRect! {
            newAttributesArray.append(layoutAttributesForItemAtIndexPath(cellAttributes.indexPath!))
        }
        
        return newAttributesArray
    }
    
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        
       let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        
        var row = indexPath.section
        var col = indexPath.item
        

        var xCoord = CGFloat(col) * 2.0 * radius!
        var yCoord = CGFloat(row) * sqrt(3.0) * radius!
        
        //if the row is odd, move it to the right
        if row % 2 == 1 {
            xCoord += radius!
        }
        
        xCoord += self.radius!
        yCoord += self.radius!
        
        attributes.center = CGPointMake(xCoord, yCoord)
        attributes.frame = CGRectMake(xCoord - self.radius!, yCoord - self.radius!, 2 * radius!, 2 * radius!)
        
        return attributes
    }
}
