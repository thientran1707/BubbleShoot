//
//  GameBubble.swift
//  LevelDesigner
//
//  Created by Tran Cong Thien on 1/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class GameBubble: UIViewController , BubbleDelegate {
    
    var bubbleModel: Bubble?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    //init with model and view
    init(model: Bubble, view: BubbleView) {
        
        bubbleModel = model
        super.init(nibName: nil, bundle: nil)
        bubbleModel!.delegate = self
        self.view = view
    }
    
    
    //update the type of the bubble then update the view
    func updateBubbleType(type: BubbleType) {
        
        var bubbleView: BubbleView = self.view as BubbleView
        bubbleModel!.type = type
        
        var newImage = Constant.getImageFromType(type)!
        bubbleView.updateViewImage(newImage)
        self.view = bubbleView
    }
    
    
    //update the center and radius of the bubble and update the view
    func updateBubbleCenterAndRadius(center: CGPoint, radius: CGFloat) {
        
        var bubbleView: BubbleView = self.view as BubbleView
        bubbleModel!.center = center
        bubbleModel!.radius = radius
        
        //update the bubbleView
        bubbleView.updateViewCenterAndRadius(center,radius: radius)
        self.view = bubbleView
    }
    
    
    //update the type from delegate
    func changeBubbleType(bubbleEntity: Bubble) {
        
        //update the bubbleModel
        updateBubbleType(bubbleEntity.type)
        
    }
    
    
    //update center and radius from delegate
    func changeBubbleCenterAndRadius(bubbleEntity: Bubble) {
        
        //update the bubble center and radius
        updateBubbleCenterAndRadius(bubbleEntity.center, radius: bubbleEntity.radius)
        
        
    }
}
