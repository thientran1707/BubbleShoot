//
//  BubbleInGrid.swift
//  LevelDesigner
//
//  Created by Tran Cong Thien on 1/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//
import UIKit

//subclass of GameBubble class, BubbleInGrid represents the bubble in grid
class BubbleInGrid: GameBubble {
    
    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }
    
    //init with model and view
    override init(model: Bubble, view: BubbleView) {
        
        super.init(model: model, view: view)
        self.view.userInteractionEnabled = true
        //add tap gesture
        //use default properties of UITapGestureRecognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapHandler:"))
        self.view.addGestureRecognizer(tapGesture)
        
        //add long-press
        //use default properties of UILongPressGestureRecognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("longPressHandler:"))
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    
    func tapHandler(recognizer: UITapGestureRecognizer) {
        
        var bubbleView: BubbleView = self.view as BubbleView
        //update type and view
        if let nextType = getNextType(self.bubbleModel!) {
            self.bubbleModel!.type = nextType
            bubbleView.updateViewImage(Constant.getImageFromType(nextType)!)
            self.view = bubbleView
        }
    }
    
    
    func longPressHandler(recognizer: UILongPressGestureRecognizer) {
        
        var bubbleView: BubbleView = self.view as BubbleView
        //update type and view
        self.bubbleModel!.type = BubbleType.NO_BUBBLE
        bubbleView.updateViewImage(Constant.getImageFromType(BubbleType.NO_BUBBLE)!)
        self.view = bubbleView
    }
    
    
    //return the next type of a bubble
    //the order is blue -> green -> orange -> red -> blue
    //if not a bubble, return nil
    private func getNextType(bubbleModel: Bubble) -> BubbleType? {
        
        let type = bubbleModel.type
        switch type {
        case .BLUE:
            return .GREEN
        case .GREEN:
            return .ORANGE
        case .ORANGE:
            return .RED
        case .RED:
            return .BLUE
        default:
            return nil
        }
    }
}
