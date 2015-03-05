//
//  LoadViewController.swift
//  BubbleShoot
//
//  Created by Tran Cong Thien on 28/2/15.
//  Copyright (c) 2015 NUS CS3217. All rights reserved.
//
import UIKit

class LoadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var loadTable: UITableView!
    
    let LOAD_VIEW_CELL_ID = "loadViewCell"
    let SYSTEM_PACKAGE_HEADER = "System Levels"
    let SAVED_PACKAGE_HEADER = "Saved design levels"
    let NUM_OF_SECTION = 2
    let SYSTEM_LEVEL_ID = 0
    let SAVED_LEVEL_ID = 1
    
    var gameLevelList = [String]()
    var prepackagedLevelList = Constant.getSystemLevelList()
    var delegate: LoadViewControllerDelegate?

    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.loadTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: LOAD_VIEW_CELL_ID)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    
        return NUM_OF_SECTION
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SYSTEM_LEVEL_ID {
            return prepackagedLevelList.count
        } else {
            return gameLevelList.count
        }
    }
    
    
    func tableView( tableView : UITableView,  titleForHeaderInSection section: Int)-> String {
    
        if section == SYSTEM_LEVEL_ID {
            return SYSTEM_PACKAGE_HEADER
        } else {
            return SAVED_PACKAGE_HEADER
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let row = indexPath.row //get the array index from the index path
        let cell: UITableViewCell = self.loadTable.dequeueReusableCellWithIdentifier(LOAD_VIEW_CELL_ID, forIndexPath: indexPath) as UITableViewCell //make the cell
        
        if indexPath.section == SYSTEM_LEVEL_ID {
            cell.textLabel!.text = prepackagedLevelList[row]
        } else {
            //set the label
            cell.textLabel!.text = gameLevelList[row]
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
    
        return cell
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool{
    
        return true
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        //to know if it's a system level or a saved level
        var prepackaged = false
        if indexPath.section == SYSTEM_LEVEL_ID {
            prepackaged = true
        }
    
        let fileToLoad: NSString = cell.textLabel!.text!
        self.delegate!.loadView(self.view, didSelectCellWithText: fileToLoad, isPrepackaged: prepackaged)
        dismissViewControllerAnimated(true, completion: nil)
    }

}


protocol LoadViewControllerDelegate {
    
    func loadView(view: UIView, didSelectCellWithText text: NSString, isPrepackaged: Bool)
}





