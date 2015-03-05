//
//  ViewController.swift
//  BubbleShoot
//
//  Created by Tran Cong Thien on 28/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//
import UIKit
import AVFoundation

class ViewController: UIViewController, LoadViewControllerDelegate {
    
    
    @IBOutlet var menuScreen: UIView!
    @IBOutlet weak var designLevelButton: UIButton!
    @IBOutlet weak var selectLevelButton: UIButton!
    
    let SEGUE_TO_PLAY_LEVEL = "goToPlayLevel"
    let SEGUE_TO_LOAD_LEVEL = "goToLoadLevel"
    var levelName:String?
    var isPrePackage = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: Constant.BACKGROUND_IMAGE)
        var background = UIImageView(image: backgroundImage)
        let viewHeight = self.menuScreen.frame.size.height
        let viewWidth = self.menuScreen.frame.size.width
        
        background.frame = CGRectMake(0, 0, viewWidth, viewHeight)
        self.menuScreen.addSubview(background)
        background.layer.zPosition = -1
        
        self.designLevelButton.layer.zPosition = 1
        self.selectLevelButton.layer.zPosition = 1
  
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //load view controller delegate
    func loadView(view: UIView, didSelectCellWithText text: NSString, isPrepackaged: Bool) {
        
        levelName = text
        isPrePackage = isPrepackaged
        self.performSegueWithIdentifier(SEGUE_TO_PLAY_LEVEL, sender: self)
    }
    
    
    //prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == SEGUE_TO_LOAD_LEVEL {
            var loadViewController = segue.destinationViewController as LoadViewController
            
            loadViewController.gameLevelList = self.getListOfLevelSaved()
            loadViewController.prepackagedLevelList = Constant.getSystemLevelList()
            loadViewController.delegate = self
        }
        
        if segue.identifier == SEGUE_TO_PLAY_LEVEL {
            var playViewController = segue.destinationViewController as PlayViewController
            
            //load the data to play level
            if isPrePackage {
                playViewController.savedGameLevel = nil
                playViewController.prePackageLevel = levelName!
            } else {
                playViewController.savedGameLevel = levelName!
                playViewController.prePackageLevel = nil
            }
        }
    }
    

    //get the list of level saved
    func getListOfLevelSaved() -> [String] {
        
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        var returnArr = [String]()
        
        if dirs != nil {
            let documentsDirectory = dirs![0];
            let path = documentsDirectory.stringByAppendingPathComponent(Constant.GAME_LEVEL_FILE)
            
            let fileManager = NSFileManager.defaultManager()
            
            // Check if file exists
            if(fileManager.fileExistsAtPath(path)) {
                var data = NSArray(contentsOfFile: path)
                returnArr = data as [String]
            }
        }
        return returnArr
    }
}
