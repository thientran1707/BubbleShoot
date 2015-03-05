//
//  BubbleView.swift
//  LevelDesigner
//
//  Created by Tran Cong Thien on 1/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

//the view for bubble
class BubbleView: UIImageView {
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    
    //init with an image and center
    init(image: UIImage, center: CGPoint, radius: CGFloat) {
        
        super.init(frame: CGRectMake(center.x - radius, center.y - radius, 2.0 * radius, 2.0 * radius))
        self.image = image
    }

    
    //update the view with new image
    func updateViewImage(image: UIImage) {
        
        self.image = image
    }
    
    
    //update the view with new center and radius
    func updateViewCenterAndRadius(center: CGPoint, radius: CGFloat) {
        
          self.frame = CGRectMake(center.x - radius, center.y - radius, 2.0 * radius, 2.0 * radius)
    }
}
