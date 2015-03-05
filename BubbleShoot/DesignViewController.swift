//
//  ViewController.swift
//  LevelDesigner
//
//  Created by YangShun on 26/1/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class DesignViewController: UIViewController,  UICollectionViewDataSource , UICollectionViewDelegate, UIAlertViewDelegate,TableViewControllerDelegate {

    @IBOutlet var buttonControl: UIView!
    @IBOutlet var gameArea: UIView!
    @IBOutlet var control: UIView!
    @IBOutlet var palette: UIView!
    @IBOutlet var bubbleGrid: UICollectionView!
    
    @IBOutlet var blueBubble: UIButton!
    @IBOutlet var greenBubble: UIButton!
    @IBOutlet var orangeBubble: UIButton!
    @IBOutlet var redBubble: UIButton!
    
    @IBOutlet var indestructiveBubble: UIButton!
    @IBOutlet var lightningBubble: UIButton!
    @IBOutlet var bombBubble: UIButton!
    @IBOutlet var starBubble: UIButton!
    @IBOutlet var eraser: UIButton!
    @IBOutlet var buttonPalette: [UIButton]!
    
    let MAX_BUBBLE_PER_SECTION = 12
    let FULL_ALPHA: CGFloat = 1.0
    let HALF_ALPHA: CGFloat = 0.5
    let IDENTIFIER_FOR_CELL_IN_GRID = "cellInGrid"
    let DEFAULT_LEVEL_NAME = "Default"
    let SEGUE_TO_LOAD_DESIGNER = "loadDesigner"
    let SEGUE_TO_PLAY_LEVEL = "toGamePlay"
    
    var bubbleRadius: CGFloat?
    var paletteState: BubbleType
    var bubbleInPaletteSelected: Bool
    var gameLevel: GameLevel?
    var bubbleControllerArray: [[BubbleInGrid]]
    
    var gameLevelList: [String]
    
    required init(coder aDecoder: NSCoder){
        
        //init variables
        paletteState = BubbleType.NO_BUBBLE
        bubbleInPaletteSelected = false
        bubbleControllerArray = [[BubbleInGrid]]()
        gameLevelList = [String]()
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bubbleRadius = self.view.frame.size.width / CGFloat(MAX_BUBBLE_PER_SECTION * 2)
        //load the file list
        self.loadGameLevelList()
        self.loadBackGroundForGameArea()
        self.preparePalette()
        self.prepareDefaultModelInGrid()
        self.prepareBubbleForGrid()
        self.bubbleGrid.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: IDENTIFIER_FOR_CELL_IN_GRID)
        self.bubbleGrid.collectionViewLayout = CustomizedLayout(_radius: bubbleRadius!)
        self.bubbleGrid.layer.opacity = 1.0
        self.gameArea.addSubview(bubbleGrid)
        self.addPanGestureToGrid()
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func loadBackGroundForGameArea() {
        
        let backgroundImage = UIImage(named: Constant.BACKGROUND_IMAGE)
        let background = UIImageView(image: backgroundImage)
        
        let gameAreaHeight = gameArea.frame.size.height
        let gameAreaWidth = gameArea.frame.size.width
        
        background.frame = CGRectMake(0, 0, gameAreaWidth, gameAreaHeight)
        
        self.gameArea.addSubview(background)
        self.buttonControl.backgroundColor = UIColor.lightGrayColor()
    }
    

    func preparePalette() {
        
        self.palette.layer.opacity = 1.0
        self.palette.backgroundColor = UIColor.darkGrayColor()
        self.gameArea.addSubview(palette)
    }
    
    
    func addPanGestureToGrid() {
        
        self.bubbleGrid.userInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: Selector("panHandler:"))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        self.bubbleGrid.addGestureRecognizer(panGesture)
    }
    
    
    //create the default model array
    func prepareDefaultModelInGrid() {
      
        var stepYCoord = sqrt(3) * bubbleRadius!
        gameLevel = GameLevel(name: DEFAULT_LEVEL_NAME, rowNum: Constant.NUM_OF_SECTION)
        
        var yCoord: CGFloat = 0.0
        for var row = 0; row < Constant.NUM_OF_SECTION; row++ {
            var xCoord: CGFloat = 0.0
            var numOfBubblePerRow = MAX_BUBBLE_PER_SECTION
            
            if (row % 2)  == 1 {
                xCoord = bubbleRadius!
                numOfBubblePerRow = MAX_BUBBLE_PER_SECTION - 1
            }
            
            for var col = 0; col < numOfBubblePerRow; col++ {
                var x = xCoord + bubbleRadius!
                var y = yCoord + bubbleRadius!
                
                var bubbleModel = Bubble(type: BubbleType.NO_BUBBLE, radius: bubbleRadius!, center: CGPointMake(x,y))
                
                //add properties
                bubbleModel.physicsBody = PhysicsBody(circleOfRadius:  bubbleRadius!)
                bubbleModel.physicsBody.position = bubbleModel.center
                bubbleModel.physicsBody.direction = Vector()
                bubbleModel.physicsBody.velocity = 0
                bubbleModel.physicsBody.category = GameObjectType.BUBBLE
                
                self.gameLevel!.addBubbleToGrid(bubbleModel,row: row )
                xCoord += 2 * bubbleRadius!
            }
            yCoord += stepYCoord
        }
    }
    
    
    //prepare the bubble grid
    func prepareBubbleForGrid() {
        
        for var section = 0; section < Constant.NUM_OF_SECTION; section++ {
            var bubbles = [BubbleInGrid]()
            var numBubblesInSection: Int?
            
            if section % 2 == 0 {
                numBubblesInSection = MAX_BUBBLE_PER_SECTION
            } else {
                numBubblesInSection = MAX_BUBBLE_PER_SECTION - 1
            }
            
            for var item = 0; item < numBubblesInSection; item++ {
                var bubbleModel = gameLevel!.bubbleGrid[section][item]
                
                var imageForView = Constant.getImageFromType(bubbleModel.type)!
                var bubbleView = BubbleView(image: imageForView,center: bubbleModel.center,radius: bubbleModel.radius)
                bubbleView.alpha = FULL_ALPHA
                
                var bubbleInGrid = BubbleInGrid(model: bubbleModel,view: bubbleView)
                bubbleModel.delegate = bubbleInGrid
                bubbles.append(bubbleInGrid)
            }
        
            bubbleControllerArray.append(bubbles)
        }
    }
    
    
    //return number of section in grid
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return Constant.NUM_OF_SECTION
    }
    
    
    //return number of item in a section of the grid
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section % 2 == 1 {
            return MAX_BUBBLE_PER_SECTION - 1
        } else {
            return MAX_BUBBLE_PER_SECTION
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(IDENTIFIER_FOR_CELL_IN_GRID, forIndexPath: indexPath) as UICollectionViewCell
        
        //configure the cell
        var row = indexPath.section
        var col = indexPath.item
        
        var bubbleController = bubbleControllerArray[row][col]
        var radius = bubbleController.bubbleModel!.radius
        
        bubbleController.view.frame = CGRectMake(0, 0, 2 * radius , 2 * radius)
        cell.addSubview(bubbleController.view)
        
        return cell
    }
    
    
    //panHanlder for pan gesture
    // if the palette is chosen and the postitions touched by users are in the bubble grid, change the type of the bubble based on current chosen type in the palette
    func panHandler(recognizer: UIPanGestureRecognizer) {
        
        if bubbleInPaletteSelected == true {
            if recognizer.state != .Ended && recognizer.state != .Failed {
                //get the touch point
                var touchPoint = recognizer.locationInView(bubbleGrid)
                
                if let indexPath = bubbleGrid.indexPathForItemAtPoint(touchPoint) {
                    var row = indexPath.section
                    var col = indexPath.item
                    
                    //update the type at (row,col)
                    var bubbleToChange = bubbleControllerArray[row][col]
                    bubbleToChange.updateBubbleType(paletteState)
                    
                    //update in game level
                    var bubbleModel = gameLevel!.bubbleGrid[row][col]
                    bubbleModel.updateType(paletteState)
                }
            }
        }
    }
    
    
    func updateCurrentGameLevel() {
        
        for var row = 0; row < Constant.NUM_OF_SECTION; row++ {
            var bubbleControllerRow = bubbleControllerArray[row]
            
            for var col = 0; col < bubbleControllerRow.count; col++ {
                
                var bubbleController = bubbleControllerArray[row][col]
                
                var bubbleModel = gameLevel!.bubbleGrid[row][col]
                
                bubbleModel.updateType(bubbleController.bubbleModel!.type)
            }
        }
    }
    
    
    //save current game level to the device
    func saveGameLevel(){
        
        var success: Bool?
        //get the default path to document folder
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if dirs != nil {
            let documentsDirectory = dirs![0];
            let path = documentsDirectory.stringByAppendingPathComponent(gameLevel!.levelName + Constant.EXTENSION_FOR_SAVING)
            
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
            archiver.encodeObject(self.gameLevel, forKey: Constant.KEY_FOR_GAME_LEVEL)
            archiver.finishEncoding()
            
            data.writeToFile(path, atomically: true)
        }
    }
    
    
    //load the gameLevel
    func loadGameLevel()  {
        
        //get the default path to document folder
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if dirs != nil {
            let documentsDirectory = dirs![0];
            let filePath = documentsDirectory.stringByAppendingPathComponent(gameLevel!.levelName + Constant.EXTENSION_FOR_SAVING)
            if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
                var data: NSData = NSData(contentsOfFile: filePath)!
                var unArchiver: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                
                var loadLevel =   unArchiver.decodeObjectForKey(Constant.KEY_FOR_GAME_LEVEL) as GameLevel
                unArchiver.finishDecoding()
                
                self.gameLevel = loadLevel
                //update the gameLevel
                var loadBubbleGrid = loadLevel.bubbleGrid
                
                for var row = 0; row < loadBubbleGrid.count ; row++ {
                    var loadBubbleRow = loadBubbleGrid[row]
                    var currentBubbleRow = gameLevel!.bubbleGrid[row]
                    
                    for var col = 0; col < loadBubbleRow.count ; col++ {
                        var loadBubbleModel = loadBubbleRow[col]
                        var currentBubbleModel = currentBubbleRow[col]
                        
                        currentBubbleModel.type = loadBubbleModel.type
                        currentBubbleModel.center = loadBubbleModel.center
                        currentBubbleModel.radius = loadBubbleModel.radius
                        
                        //update the grid
                        currentBubbleModel.delegate = bubbleControllerArray[row][col]
                        currentBubbleModel.delegate!.changeBubbleType(currentBubbleModel)
                        currentBubbleModel.delegate!.changeBubbleCenterAndRadius(currentBubbleModel)
                    }
                }

            }
        }
        //update the grid
        self.bubbleGrid.reloadData()
    }
    
    
    //reset all the bubble as NO_BUBBLE
    func resetGrid() {
        for section in bubbleControllerArray {
            for item in section {
                //update the type
                item.updateBubbleType(BubbleType.NO_BUBBLE)
            }
        }
    }
    
        
    //save list of the game level names
    func saveGameLevelList() {
        
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if dirs != nil {
            let documentsDirectory = dirs![0];
            let path = documentsDirectory.stringByAppendingPathComponent(Constant.GAME_LEVEL_FILE)
            
            //convert to NSArray before write
            let arrayWriteToFile: NSArray = gameLevelList
            arrayWriteToFile.writeToFile(path, atomically: true)
        }
    }
    
    
    //load the list of game level names
    func loadGameLevelList() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if dirs != nil {
            let documentsDirectory = dirs![0];
            let path = documentsDirectory.stringByAppendingPathComponent(Constant.GAME_LEVEL_FILE)
            
            let fileManager = NSFileManager.defaultManager()
            
            // Check if file exists
            if(fileManager.fileExistsAtPath(path)) {
                var data = NSArray(contentsOfFile: path)
                gameLevelList = data as [String]
            } else {
                //the game level list is empty
                gameLevelList = [String]()
            }
        }
    }
    

    //implement UIAlertViewDelegate
    func alertView( alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if alertView.cancelButtonIndex != buttonIndex {
            let inputName = alertView.textFieldAtIndex(0)!.text as String
            
            //empty name is not allowed
            if inputName.isEmpty {
                var invalidNameAlert = UIAlertView(title: "Invalid Level Name", message: "Level name should not be empty", delegate: self, cancelButtonTitle: "OK")
                invalidNameAlert.show()
                return
            }
            
            //name is used already
            if contains(gameLevelList, inputName) {
                var nameExistedAlert = UIAlertView(title: "Name existed", message: "Please enter another name", delegate: self, cancelButtonTitle: "OK")
                nameExistedAlert.show()
                return
            }
            
            //otherwise, save the level
            self.gameLevel!.levelName = String(inputName)
            self.saveGameLevel()
            
            if !contains(gameLevelList, inputName) {
                gameLevelList.append(inputName)
                self.saveGameLevelList()
            }
        }
    }
    
    
    //prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == SEGUE_TO_LOAD_DESIGNER {
            var tableViewController = segue.destinationViewController as TableViewController
            tableViewController.gameLevelList = self.gameLevelList
            tableViewController.delegate  = self
        } else if segue.identifier == SEGUE_TO_PLAY_LEVEL {
            var playViewController = segue.destinationViewController as PlayViewController
            self.updateCurrentGameLevel()
            playViewController.gameLevel = GameLevel(gameLevel: self.gameLevel!)
    
        }
    }
    
    
    //implement the TableViewControllerDelegate
    func loadView(view: UIView, didSelectCellWithText fileToLoad: NSString) {
       
        self.gameLevel!.levelName = fileToLoad
        //self.resetGrid()
        self.loadGameLevel()
    }
    
    
    @IBAction func bubbleChosen(sender: AnyObject) {
        
        let bubbleChosen = sender as UIButton
        var selectedBubble: UIButton?
        
        //that bubble is chosen
        if bubbleChosen.selected {
            bubbleChosen.selected = !bubbleChosen.selected
            bubbleChosen.alpha = HALF_ALPHA
        } else {
            //unselect all bubbles
            for bubble in buttonPalette {
                if bubble.selected {
                bubble.selected = !bubble.selected
                bubble.alpha = HALF_ALPHA
                }
            }
            
            bubbleChosen.selected = !bubbleChosen.selected
            bubbleChosen.alpha = FULL_ALPHA
            selectedBubble = bubbleChosen
        }
        
        //if there is no selected bubble, then bubbleInPaletteSelected is false, can not change the bubbles by panning
        if selectedBubble != nil {
            
            bubbleInPaletteSelected = true
            switch bubbleChosen {
                case blueBubble:
                    paletteState = BubbleType.BLUE
                    break
                case greenBubble:
                    paletteState = BubbleType.GREEN
                    break
                case orangeBubble:
                    paletteState = BubbleType.ORANGE
                    break
                case redBubble:
                    paletteState = BubbleType.RED
                    break
                case indestructiveBubble:
                    paletteState = BubbleType.INDESTRUCTIVE
                    break
                case lightningBubble:
                    paletteState = BubbleType.LIGHTNING
                    break
                case bombBubble:
                    paletteState = BubbleType.BOMB
                    break
                case starBubble:
                    paletteState = BubbleType.STAR
                    break
                default:
                    paletteState = BubbleType.NO_BUBBLE
            }
        } else {
            //stop user to change the bubble
            bubbleInPaletteSelected = false
        }
    }

    
    //reset the grid
    @IBAction func resetPressed(sender: AnyObject) {
        
        resetGrid()
    }
    
    
    @IBAction func playPressed(sender: AnyObject) {
    
    }
    
    
    //save current game level, the name entered can not be empty or used before
    @IBAction func savePressed(sender: AnyObject) {
        
        var alertSaveFile = UIAlertView(title:" Save the current game level", message: "Please enter the name of the level", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Save")
        alertSaveFile.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertSaveFile.show()
    }

    
    //if LOAD button is pressed, display the list of all game levels saved,
    // if there is no levels saved, the list will be empty
    @IBAction func loadPressed(sender: AnyObject) {
        
        self.loadGameLevelList()
    }
 
}

