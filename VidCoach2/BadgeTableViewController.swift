//
//  BadgeTableViewController.swift
//  VidCoach2
//
//  Created by Erick Custodio on 1/18/16.
//  Copyright © 2016 Erick Custodio. All rights reserved.
//

import UIKit

class BadgeTableViewController: UITableViewController {

    //MARK: Properties
    let cellIdentifier = "BadgeTableViewCell"
    var pathForBadgesPlistFile:String!
    var badgesData:NSData!
    var badgesArray:NSMutableArray!
    var pathForEarnedPlistFile:String!
    var earnedData:NSData!
    var earnedArray:NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        //Handle data retrieval from plist files. See preparePlistForUse() in AppDelegate.swift
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Get badges data
        pathForBadgesPlistFile = appDelegate.badgesPlistPath
        
        badgesData = NSFileManager.defaultManager().contentsAtPath(pathForBadgesPlistFile)!
        
        do{
            badgesArray = try NSPropertyListSerialization.propertyListWithData(badgesData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
        }catch{
            print("An error occured while reading rewards plist")
        }

        //Get earned data
        pathForEarnedPlistFile = appDelegate.earnedPlistPath
        
        earnedData = NSFileManager.defaultManager().contentsAtPath(pathForEarnedPlistFile)!
        
        do{
            earnedArray = try NSPropertyListSerialization.propertyListWithData(earnedData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
        }catch{
            print("An error occured while reading rewards and progress plist")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return badgesArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BadgeTableViewCell

        // Configure the cell...
        let title = badgesArray[indexPath.row].objectForKey("Title")
        let description = badgesArray[indexPath.row].objectForKey("Description")
        cell.badgeLabel.text = title as? String
        cell.badgeInfo.text = description as? String
        
        if earnedArray.containsObject(badgesArray[indexPath.row].objectForKey("Title")!) {
            var badgeName = badgesArray[indexPath.row].objectForKey("Title") as! String
            let rangeOfSpace = badgeName.rangeOfString(" ")
            let prefix = String(badgeName.characters.prefixUpTo(rangeOfSpace!.startIndex))
            badgeName = badgeName.stringByReplacingOccurrencesOfString(prefix, withString: "")
            badgeName = badgeName.stringByReplacingOccurrencesOfString(" ", withString: "")
            cell.badgeImage.image = UIImage(named: badgeName)
        } else {
            cell.badgeLabel.textColor = UIColor.lightGrayColor()
            cell.badgeInfo.textColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
