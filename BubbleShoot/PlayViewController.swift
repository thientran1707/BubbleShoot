//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController, UIAlertViewDelegate{
    

    @IBOutlet var gameArea: UIView!
    @IBOutlet var cannonArea: UIView!
    @IBOutlet weak var scoreDisplay: UILabel!
    @IBOutlet weak var timeLeftDisplay: UILabel!
    @IBOutlet weak var controllerArea: UIView!
    
    let MAX_BUBBLE_PER_SECTION = 12
    let FULL_ALPHA: CGFloat = 1.0
    let HALF_ALPHA: CGFloat = 0.5
    let FREQUENCY: NSTimeInterval = 1 / 60.0
    let SPEED: CGFloat = 1000
    let ROTATION_SPEED: CGFloat = CGFloat(M_PI / 2)
    let SCORE_FOR_EACH_BUBBLE: Int = 5
    let MIN_SIZE_TO_REMOVE: Int = 3
    let GAME_TIME: Int = 60
    let BONUS_TO_FINISH_GAME = 50
    let STRING_FORMAT1 = "0"
    let STRING_FORMAT2 = "00"
    let END_GAME_MESSAGE1 = "You achieved a new high score: "
    let END_GAME_MESSAGE2 = "You score "
    let SPACE_STRING = " "
    let DOT_STRING = ". "
    let NEW_LINE = "\n"
    let CONGRATULATION_MESSAGE = "Congratulation"
    let NORMAL_END_GAME_MESSAGE = "Game ends"
    let BACK_BUTTON_NAME = "Back"
    let GAME_LOOP_ID = "runGameLoop:"
    let TEN = 10
    let HUNDRED = 100
    let MAX_NUM_OF_ELEMENT_IN_TOP_SCORE = 5
    let CANNON_WIDTH: CGFloat = 100
    let CANNON_HEIGHT: CGFloat = 200
    let CANNON_BASE_WIDTH: CGFloat = 180
    let CANNON_BASE_HEIGHT: CGFloat = 90
    
    var repeatingTimer: NSTimer?
    
    //The size of top score is  5
    var topScore: [Int]
    var gameScore: Int
    var gameLevel: GameLevel?
    
    var savedGameLevel: String?
    var prePackageLevel: String?
    
    var bubbleControllerArray: [[GameBubble]]
    
    var bubbleGamePlay: BubbleGamePlay?
    var bubbleRadius: CGFloat
    
    //position for launch point
    var launchBlock: Bool
    var launchedController: GameBubble?
    
    //calculate the angle form 2 points: launch point and touch point
    var launchPoint: CGPoint
    var touchPoint: CGPoint
    
    //variables for the cannon
    var cannonBase: UIImageView?
    var cannonView: UIImageView?
    var imagesForCannon: [UIImage]
    
    var imagesForBursting: [UIImage]
    //variables for prelaunch and launch bubbles
    var bubbleAtPrelaunchPoint: BubbleView?
    var bubbleTypeToPrelaunch: BubbleType
    
    var bubbleAtLaunchPoint: BubbleView?
    var bubbleTypeToLaunch: BubbleType
    
    //position to display bubble for prelaunch
    var prelaunchPoint1: CGPoint?
    var prelaunchPoint2: CGPoint?
    
    //for the count down timer
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var gameTime: Double
    var currentTimeLeft: Int
    required init(coder aDecoder: NSCoder){
        
        //init variables
        bubbleControllerArray = [[GameBubble]]()
        gameLevel = GameLevel()
        
        bubbleRadius = 0.0
        launchBlock = true
        launchPoint = CGPointMake(0,0)
        touchPoint = CGPointMake(0,0)
        imagesForCannon = [UIImage]()
        imagesForBursting = [UIImage]()

        bubbleTypeToLaunch = BubbleType.BLUE
        bubbleTypeToPrelaunch = BubbleType.BLUE
        
        savedGameLevel = nil
        prePackageLevel = nil
        gameScore = 0
        topScore = [Int]()
        gameTime = Double(GAME_TIME)
        currentTimeLeft = GAME_TIME
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bubbleRadius = self.view.frame.size.width / CGFloat(MAX_BUBBLE_PER_SECTION * 2)
        
        launchPoint.x = self.gameArea.frame.size.width / 2
        launchPoint.y = self.gameArea.frame.size.height - bubbleRadius
        
        prelaunchPoint1 = CGPointMake(self.bubbleRadius, launchPoint.y)
        prelaunchPoint2 = CGPointMake((self.launchPoint.x + self.prelaunchPoint1!.x) / 2, self.launchPoint.y)
        
    
        //init the bubble in the grid, create controller for each bubble
        if let prePackage = prePackageLevel {
            self.loadSystemLevelWithName(prePackage)
        } else if savedGameLevel != nil {
            self.prepareDefaultLevel()
            self.prepareGameBubbleController()
            self.prepareBubbleGamePlay()
            self.loadGameLevelWithName(savedGameLevel!)
        } else {
            self.prepareGameBubbleController()
            self.prepareBubbleGamePlay()

        }
        
        self.doSetupView()
        //add gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapHandler:"))
        self.gameArea.addGestureRecognizer(tapGesture)
        
        //remove the bubbles not connected at the beginning of the game
        var removedBubbles = self.bubbleGamePlay!.removeDisconnectedBubbles()
        self.doAnimationFallingBubbles(removedBubbles)
        self.updateView()
        
        if self.noMoreBubbles() {
            self.showEndGameScreen(0)
            launchBlock = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func doSetupView() {
        self.loadBackGroundForGameArea()
        
        //prepare the cannon
        let cannonImage = UIImage(named: Constant.CANNON_IMAGE)!
        let imageWidth: CGFloat = cannonImage.size.width / 6
        let imageHeight: CGFloat = cannonImage.size.height / 2
        
        //get the images
        for var i = 0; i < 6; i++ {
                var rectFrame = CGRectMake(CGFloat(i) * imageWidth, 0, imageWidth, imageHeight)
                var imageRef: CGImageRef = CGImageCreateWithImageInRect(cannonImage.CGImage!, rectFrame)
                
                imagesForCannon.append(UIImage(CGImage: imageRef)!)
        }
        
        cannonView = UIImageView(image: imagesForCannon[0])
        cannonView!.frame = CGRectMake(0, 0, CANNON_WIDTH, CANNON_HEIGHT)
        cannonView!.center = CGPointMake(self.gameArea.frame.size.width / 2, self.gameArea.frame.size.height - cannonView!.frame.size.height / 2)
        
        //set new anchor for cannon rotation
        self.setAnchorPoint(CGPointMake(0.5, CGFloat(cannonView!.frame.size.height - self.bubbleRadius) / cannonView!.frame.size.height), view: cannonView!)
        self.gameArea.addSubview(cannonView!)
        cannonView!.layer.zPosition = 1
        
        //prepare cannon base
        let cannonBaseImage = UIImage(named: Constant.CANNON_BASE_IMAGE)
        cannonBase = UIImageView(image: cannonBaseImage)
        cannonBase!.frame = CGRectMake(0, 0, CANNON_BASE_WIDTH, CANNON_BASE_HEIGHT)
        
        cannonBase!.center = CGPointMake(self.gameArea.frame.size.width / 2 , self.gameArea.frame.size.height - self.bubbleRadius )
        cannonBase!.layer.zPosition = 1
        self.gameArea.addSubview(cannonBase!)
        self.controllerArea.layer.zPosition = 1
        self.prepareGameBubbleController()
        self.prepareBubbleGamePlay()
        
        //prepare the bubble to launch
        bubbleTypeToLaunch = self.getRandomBubble()
        bubbleAtLaunchPoint = BubbleView(image: Constant.getImageFromType(bubbleTypeToLaunch)!, center: prelaunchPoint2!, radius: bubbleRadius)
        
        bubbleTypeToPrelaunch = self.getRandomBubble()
        bubbleAtPrelaunchPoint = BubbleView(image: Constant.getImageFromType(bubbleTypeToPrelaunch)!, center: prelaunchPoint1!, radius: bubbleRadius)
        
        self.gameArea.addSubview(bubbleAtLaunchPoint!)
        self.gameArea.addSubview(bubbleAtPrelaunchPoint!)
        self.cannonArea.layer.zPosition = 2
    }
    
    
    func runGameLoop(gameTime: NSTimer) {
        
        self.bubbleGamePlay!.updatePhysicsAndContact(FREQUENCY)
        
        if let launchedBubble = launchedController {
            launchedBubble.bubbleModel!.updateCenter(launchedController!.bubbleModel!.physicsBody.position)
        
            if launchedBubble.bubbleModel!.physicsBody.direction.isZero() {
        
                if let index = self.bubbleGamePlay!.addBubbleToGrid(launchedBubble.bubbleModel!) {
                
                    bubbleControllerArray[index.0][index.1].bubbleModel!.updateType(launchedController!.bubbleModel!.type)
                    
                    var removedBubbles = self.bubbleGamePlay!.removeRegionWithSameColorAt(index.0, col: index.1, minSizeToRemove: MIN_SIZE_TO_REMOVE)
                    gameScore += removedBubbles.count * SCORE_FOR_EACH_BUBBLE
                    
                    self.doAnimationRemovingBubbles(removedBubbles)
                    self.updateView()
                    if removedBubbles.count > 0 {
                        var disconnectedBubbles = self.bubbleGamePlay!.removeDisconnectedBubbles()
                        gameScore += disconnectedBubbles.count * SCORE_FOR_EACH_BUBBLE
                        
                        self.doAnimationFallingBubbles(disconnectedBubbles)
                        self.updateView()
            
                    }
                
                } else {
                    //no more positions to add new bubble, end game
                    self.stopGame()
                    self.showEndGameScreen(gameScore)
                    launchBlock = true
                    return
                }
                
                launchedController!.view.removeFromSuperview()
                launchedController = nil
                launchBlock = false
            }
            }
        
        var strScore: String
        if gameScore < TEN {
            strScore = STRING_FORMAT2 + String(gameScore)
        } else if gameScore < HUNDRED {
            strScore = STRING_FORMAT1 + String(gameScore)
        } else {
            strScore = String(gameScore)
        }
        
        //update the score on the screen
        scoreDisplay.text  = strScore
        
        //check condtion to end game
        if noMoreBubbles() || currentTimeLeft == 0 {
            self.stopGame()
            self.showEndGameScreen(gameScore + calculateBonusScore())
            launchBlock = true
            return
        }
        self.bubbleAtLaunchPoint!.layer.opacity = 1.0
    }
    
    func doAnimationRemovingBubbles(bubbleModels: [Bubble]) {
        
        var viewArr = [BubbleView]()
        
        for bubble in bubbleModels {
            var newView = BubbleView(image: Constant.getImageFromType(bubble.type)!, center: bubble.center, radius: bubble.radius)
            viewArr.append(newView)
            self.gameArea.addSubview(newView)
        }
        
        UIView.animateWithDuration( 0.5 , animations: {
            
            for view in viewArr {
                view.alpha = 0.0
                view.transform = CGAffineTransformMakeScale(3, 3)
                //for animation
                view.animationImages = self.imagesForBursting
                view.animationDuration = 0.5
                view.animationRepeatCount = 1
                view.startAnimating()
                }
            }, completion: { finished in
                for view in viewArr {
                    view.removeFromSuperview()
                }
        })
    }
    
    
    func doAnimationFallingBubbles(bubbleModels: [Bubble]) {
        
        var viewArr = [BubbleView]()
        var positionToDisappear = self.gameArea.frame.size.height - self.cannonView!.frame.size.height
        
        for bubble in bubbleModels {
            var newView = BubbleView(image: Constant.getImageFromType(bubble.type)!, center: bubble.center, radius: bubble.radius)
            viewArr.append(newView)
            self.gameArea.addSubview(newView)
        }
    
        var fallingTime: NSTimeInterval = NSTimeInterval(positionToDisappear) / NSTimeInterval(SPEED)
        
        for view in viewArr {
          
            UIView.animateWithDuration(fallingTime, animations: {
                view.center = CGPointMake(view.center.x, positionToDisappear)
                view.alpha = 0.0
                view.transform = CGAffineTransformMakeScale(2, 2)
                
            }, completion: { finished in
                view.removeFromSuperview()
            })
        }
    }
    
    
    func getBubbleModelArrayFromIndex(indexArr: [(Int, Int)]) -> [Bubble] {
        
        var bubbleArr = [Bubble]()
        for (row, col) in indexArr {
            var model = bubbleControllerArray[row][col].bubbleModel!
            var modelClone = Bubble(type: model.type, radius: model.radius, center: model.center)
            bubbleArr.append(modelClone)
        }
        return bubbleArr
    }
    
    
    func loadBackGroundForGameArea() {
        
        let backgroundImage = UIImage(named: Constant.BACKGROUND_IMAGE)
        let background = UIImageView(image: backgroundImage)
        
        let gameAreaHeight = gameArea.frame.size.height
        let gameAreaWidth = gameArea.frame.size.width
        background.frame = CGRectMake(0, 0, gameAreaWidth, gameAreaHeight)
        self.gameArea.addSubview(background)
    }
    
    
    //prepare the bubble grid
    func prepareGameBubbleController() {
        
        var bubbleGrid = self.gameLevel!.bubbleGrid
        for var row = 0; row < bubbleGrid.count; row++ {
            var bubbleControllerRow = [GameBubble]()
            var bubbleRow = bubbleGrid[row]
            
            
            for var col = 0; col < bubbleRow.count; col++ {
                var bubbleModel = gameLevel!.bubbleGrid[row][col]
                
                var imageForView = Constant.getImageFromType(bubbleModel.type)!
                
                var bubbleView = BubbleView(image: imageForView,center: bubbleModel.center,radius: bubbleModel.radius)
                if bubbleModel.type == BubbleType.NO_BUBBLE {
                    
                    bubbleView.alpha = 0.0
                }
                
                var gameBubble = GameBubble(model: bubbleModel,view: bubbleView)
                
                bubbleControllerRow.append(gameBubble)
                self.gameArea.addSubview(bubbleView)
            }
            bubbleControllerArray.append(bubbleControllerRow)
        }
    }
    
    
    func updateView() {
        
        for var row = 0; row < bubbleControllerArray.count; row++ {
            var controllerRow = bubbleControllerArray[row]
            
            for var col = 0; col < controllerRow.count; col++ {
                var controller = bubbleControllerArray[row][col]
                if controller.bubbleModel!.type == BubbleType.NO_BUBBLE {
                    controller.view.alpha = 0.0
                } else {
                    controller.view.alpha = 1.0
                }
            }
        }
    }
    
    
    func prepareBubbleGamePlay() {
        
        var gameAreaHeight = self.gameArea.frame.size.height
        var gameAreaWidth = self.gameArea.frame.size.width
        var topLeft = CGPointMake(0, 0)
        var topRight = CGPointMake(gameAreaWidth, 0)
        var bottonLeft = CGPointMake(0, gameAreaHeight)
        var bottonRight = CGPointMake(gameAreaWidth, gameAreaHeight )
        
        //top wall
        var topWall = GameObject(lineFromPoint: topLeft, lineToPoint: topRight)
        topWall.physicsBody.velocity = 0
        topWall.physicsBody.direction = Vector()
        topWall.physicsBody.category = GameObjectType.TOP_WALL
        
  
        var rightWall = GameObject(lineFromPoint: topRight, lineToPoint: bottonRight)
        rightWall.physicsBody.velocity = 0
        rightWall.physicsBody.direction = Vector()
        rightWall.physicsBody.category = GameObjectType.RIGHT_WALL
        
        //left wall
        var leftWall = GameObject(lineFromPoint: topLeft, lineToPoint: bottonLeft)
        leftWall.physicsBody.velocity = 0
        leftWall.physicsBody.direction = Vector()
        leftWall.physicsBody.category = GameObjectType.LEFT_WALL
        
        var wallArray = [topWall, leftWall, rightWall]
        
        self.bubbleGamePlay = BubbleGamePlay(inputGrid: gameLevel!.bubbleGrid, wall: wallArray)
    }
    
    
    func tapHandler(sender: UITapGestureRecognizer)  {

        self.gameArea.userInteractionEnabled = true
        var positionIgnoreTouch = self.gameArea.frame.size.height - self.bubbleRadius
        if launchBlock == false {
            if sender.state != UIGestureRecognizerState.Failed {
                var contactPoint = sender.locationInView(self.gameArea)
                
                if contactPoint.y > positionIgnoreTouch {
                    return
                }
                touchPoint = contactPoint
                launchBlock = true
                var newAngle = self.getAngleLaunch()
                self.doRotateCannon(CGFloat(M_PI) / 2 - newAngle, willFire: true)
            }
        }
    }
    
    
    func refillLaunchBubble() {
        bubbleTypeToLaunch = bubbleTypeToPrelaunch
        bubbleTypeToPrelaunch = self.bubbleGamePlay!.generateNextBubble()
        
        bubbleAtLaunchPoint!.image = Constant.getImageFromType(bubbleTypeToLaunch)!
        bubbleAtPrelaunchPoint!.image = Constant.getImageFromType(bubbleTypeToPrelaunch)!
        
        //center of bubble to launch and bubble to prelaunch
        bubbleAtLaunchPoint!.center = prelaunchPoint1!
        bubbleAtPrelaunchPoint!.center = CGPointMake(-bubbleRadius, prelaunchPoint1!.y)
        
        //animation, the prelaunch bubble will move in
        UIView.animateWithDuration(1.0, animations: {
            self.bubbleAtPrelaunchPoint!.center = self.prelaunchPoint1!
            self.bubbleAtLaunchPoint!.center = self.prelaunchPoint2!
        })
    
    }
    
    
    func getRandomBubble() -> BubbleType {
        var number = Int(arc4random())
        switch number % Constant.NUM_OF_NORMAL_BUBBLE_TYPE + 1 {
        case 1:
            return BubbleType.BLUE
        case 2:
            return BubbleType.GREEN
        case 3:
            return BubbleType.ORANGE
        case 4:
            return BubbleType.RED
        default:
            return BubbleType.BLUE
        }
    }
    
    
    func doRotateCannon(angle: CGFloat, willFire: Bool) {
       
        var delay = NSTimeInterval (angle / ROTATION_SPEED)
        UIView.animateWithDuration( delay, animations: {
            self.cannonView!.transform = CGAffineTransformMakeRotation(angle)
        }, completion: { willFire in
            self.doAnimationFire()
        })
    }
    
    
    func doAnimationFire() {
        
        UIView.animateWithDuration( 0.5, animations: {
            self.bubbleAtLaunchPoint!.center = self.launchPoint
            }, completion: { finished in
            self.bubbleAtLaunchPoint!.layer.opacity = 0.0
            self.createControllerForLaunchBubble()
                
            //for animation
            self.cannonView!.animationImages = self.imagesForCannon
            self.cannonView!.animationDuration = 0.5
            self.cannonView!.animationRepeatCount = 1
            self.cannonView!.startAnimating()
        })
    }
    
    
    func getAngleLaunch() -> CGFloat {
        var launchVector = Vector(from:
            launchPoint, to: touchPoint)
        return launchVector.angleWith(Vector(x: 1, y: 0))
    }
    
    
    func loadGameLevelWithName(fileToLoad: String) {
        
            //get the default path to document folder
            let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
            if dirs != nil {
                let documentsDirectory = dirs![0];
                let filePath = documentsDirectory.stringByAppendingPathComponent(fileToLoad + Constant.EXTENSION_FOR_SAVING)
                if NSFileManager.defaultManager().fileExistsAtPath(filePath) {
                    var data: NSData = NSData(contentsOfFile: filePath)!
                    var unArchiver: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                    
                    var loadLevel =   unArchiver.decodeObjectForKey(Constant.KEY_FOR_GAME_LEVEL) as GameLevel
                    unArchiver.finishDecoding()
                    self.gameLevel = loadLevel
                    
                    //update the grid
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
    }
    
    
    func setAnchorPoint(anchorPoint: CGPoint, view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position : CGPoint = view.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        view.layer.position = position;
        view.layer.anchorPoint = anchorPoint;
    }
    
    
    func createControllerForLaunchBubble() {
        var bubbleModel = Bubble(type: bubbleTypeToLaunch, radius: bubbleRadius, center: launchPoint)
        
        var bubbleView = BubbleView(image: Constant.getImageFromType(bubbleModel.type)!, center: launchPoint, radius: bubbleRadius)
        
        self.gameArea.addSubview(bubbleView)
        launchedController = GameBubble(model: bubbleModel, view: bubbleView)
        
        //update physical properties
        bubbleModel.physicsBody = PhysicsBody(circleOfRadius: bubbleRadius)
        bubbleModel.physicsBody.position = launchPoint
        bubbleModel.physicsBody.direction = Vector(from: launchPoint, to: touchPoint).normalize()
    
        bubbleModel.physicsBody.velocity = SPEED
        bubbleModel.physicsBody.category = GameObjectType.BUBBLE
        
        //add to bubble game play
        self.bubbleGamePlay!.addGameObject(bubbleModel)
        self.bubbleAtLaunchPoint!.layer.opacity = 0.0
        
        refillLaunchBubble()
    }

    
    //get the empty grids
    func prepareDefaultLevel() {
        var stepYCoord = sqrt(3) * bubbleRadius
        
        gameLevel = GameLevel(name: Constant.DEFAULT_LEVEL_NAME, rowNum: Constant.NUM_OF_SECTION)
        
        var yCoord: CGFloat = 0.0
        for var row = 0; row < Constant.NUM_OF_SECTION; row++ {
            var xCoord: CGFloat = 0.0
            var numOfBubblePerRow = MAX_BUBBLE_PER_SECTION
            
            if (row % 2)  == 1 {
                xCoord = bubbleRadius
                numOfBubblePerRow = MAX_BUBBLE_PER_SECTION - 1
            }
            
            for var col = 0; col < numOfBubblePerRow; col++ {
                var x = xCoord + bubbleRadius
                var y = yCoord + bubbleRadius
                
                var bubbleModel = Bubble(type: BubbleType.NO_BUBBLE, radius: bubbleRadius, center: CGPointMake(x,y))
                
                //add properties
                bubbleModel.physicsBody = PhysicsBody(circleOfRadius:  bubbleRadius)
                bubbleModel.physicsBody.position = bubbleModel.center
                bubbleModel.physicsBody.direction = Vector()
                bubbleModel.physicsBody.velocity = 0
                bubbleModel.physicsBody.category = GameObjectType.BUBBLE
                
                self.gameLevel!.addBubbleToGrid(bubbleModel,row: row )
                xCoord += 2 * bubbleRadius
            }
            yCoord += stepYCoord
        }
    }
    
    
    func startGame() {
        
        self.currentTimeLeft = GAME_TIME
        self.gameScore = 0
        
        launchBlock = false
        self.repeatingTimer = NSTimer.scheduledTimerWithTimeInterval(FREQUENCY, target: self, selector: Selector(GAME_LOOP_ID), userInfo: nil, repeats: true)
        
        let aSelector: Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval( 1.0 , target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
    }
    
    
    func stopGame() {
        timer.invalidate()
        if let gameTimer = repeatingTimer {
            gameTimer.invalidate()
        }
    }
    
    
    func updateTime() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        var elapsedTime = currentTime - startTime
        var seconds = Int(gameTime - elapsedTime)
        
        if seconds >= 0 {
            
            currentTimeLeft = seconds
            var strTime: String
            if seconds < TEN {
                strTime = STRING_FORMAT1 + String(seconds)
            } else {
                
                strTime = String(seconds)
            }
            
            //update the time on the screen
            timeLeftDisplay.text = strTime
        } else {
            timer.invalidate()
        }
    }
    

    //implement UIAlertViewDelegate
    func alertView( alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if alertView.cancelButtonIndex == buttonIndex {
            self.stopGame()
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    
    func showEndGameScreen(score: Int) {
        
        self.loadTopScoreList()
        if insertToTopScore(score) {
            self.showCongratulationScreen()
            self.saveTopScoreList()
            var endMessage = END_GAME_MESSAGE1 + String(score) + NEW_LINE
            for var index = 0; index < topScore.count; index++ {
                endMessage = endMessage + SPACE_STRING + String(index + 1) + DOT_STRING + String(topScore[index]) + NEW_LINE
            }
            
            var endGameAlert = UIAlertView(title: CONGRATULATION_MESSAGE, message: endMessage, delegate: self, cancelButtonTitle: BACK_BUTTON_NAME)
            endGameAlert.show()
            
        } else {
            //display the final score = gameScore + bonus points
            let endMessage: String = END_GAME_MESSAGE2 + String(score)
            var endGameAlert = UIAlertView(title: NORMAL_END_GAME_MESSAGE, message: endMessage, delegate: self, cancelButtonTitle: BACK_BUTTON_NAME)
            endGameAlert.show()
        }
    }
    
    
    func noMoreBubbles() -> Bool {
        for var section = 0; section < self.gameLevel!.bubbleGrid.count; section++ {
            var bubbleRow = gameLevel!.bubbleGrid[section]
            for var col = 0; col < bubbleRow.count; col++ {
                if bubbleRow[col].type != BubbleType.NO_BUBBLE {
                    return false
                }
            }
        }
        return true
    }
    
    
    func calculateBonusScore() -> Int {
        
        var returnScore = 0
        if noMoreBubbles() {
            returnScore = BONUS_TO_FINISH_GAME
        }
       
        //add more score if user finishes the game less than 60 seconds, each second is awarded 5 points
        returnScore += currentTimeLeft * SCORE_FOR_EACH_BUBBLE
        
        return returnScore
    }
    
    
    //return true if score is a new high score (top 5)
    func insertToTopScore(score: Int) -> Bool{
        //ignore if score <= 0
        if score <= 0 {
            return false
        }
        //append new score then sort top score first in decreasing order
        topScore.append(score)
        topScore.sort { $1 < $0 }
        
        while topScore.count > MAX_NUM_OF_ELEMENT_IN_TOP_SCORE {
            topScore.removeLast()
        }
        
        //check if the score is in the list
        return contains(topScore, score)
    }
    
    
    func saveTopScoreList() {
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if dirs != nil {
            let documentsDirectory = dirs![0];
            let path = documentsDirectory.stringByAppendingPathComponent(Constant.TOP_SCORE_FILE)
            
            //convert to NSArray before write
            let arrayWriteToFile: NSArray = topScore
            arrayWriteToFile.writeToFile(path, atomically: true)
        }
        
    }
    
    
    //load the top score list
    func loadTopScoreList() {
        
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? [String]
        if dirs != nil {
            let documentsDirectory = dirs![0];
            let path = documentsDirectory.stringByAppendingPathComponent(Constant.TOP_SCORE_FILE)
            
            let fileManager = NSFileManager.defaultManager()
            
            // Check if file exists
            if(fileManager.fileExistsAtPath(path)) {
                var data = NSArray(contentsOfFile: path)
                topScore = data as [Int]
            } else {
                //the top score list is empty
                topScore = [Int]()
            }
        }
    }
    

    @IBAction func startGamePressed(sender: AnyObject) {
        
        self.startGame()
    }
}