//
//  TableViewController.swift
//  LevelDesigner
//
//  Created by Tran Cong Thien on 7/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//

import UIKit

let IDENTIFIER = "tableCell"
let HEADER_TITLE = "Game Levels Saved"



class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var savedLevelTable: UITableView!
   
    var gameLevelList: [String]
    var delegate: TableViewControllerDelegate?
    
    required init(coder aDecoder: NSCoder){
        
        //init variables
        gameLevelList = [String]()
        
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.savedLevelTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: IDENTIFIER)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      
        return 1
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return gameLevelList.count
    }
    
    
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)-> String {
        
            return HEADER_TITLE
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let row = indexPath.row //get the array index from the index path
        let cell: UITableViewCell = self.savedLevelTable.dequeueReusableCellWithIdentifier(IDENTIFIER, forIndexPath: indexPath) as UITableViewCell //make the cell
            //set the label
        cell.textLabel!.text = gameLevelList[row]
        cell.selectionStyle = UITableViewCellSelectionStyle.Default

        
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        
            return true
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
     
        let fileToLoad: NSString = cell.textLabel!.text!
        
        self.delegate!.loadView(self.view, didSelectCellWithText: fileToLoad)
        
        dismissViewControllerAnimated(true, completion: nil)
      }
}



protocol TableViewControllerDelegate {
    
    func loadView(view: UIView, didSelectCellWithText text: NSString)
}
