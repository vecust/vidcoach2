//
//  InterviewTableViewController.swift
//  VidCoach2
//
//  This view handles listing all the interviews in a table of cells. The interview list is retrieved from the interviews.plist file.
//  The name of the selected interview is passed on to the next view to determine what questions to show.
//
//  Created by Erick Custodio on 12/24/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit

class InterviewTableViewController: UITableViewController {
    
    // MARK: Properties
    let cellIdentifier = "InterviewTableViewCell"
    var interviews = [String]()
    var rewardsDict:NSMutableDictionary!
    var progressDict:NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Get interview titles
        let filePath = NSBundle.mainBundle().pathForResource("interviews", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: filePath!)
        
        //Assign retrieved interview titles to class property
        interviews = dict?.objectForKey("Interviews") as! [String]
        
    }
    override func viewWillAppear(animated: Bool) {
        //This call checks if there are any changes to the cells such as badges and progress
        self.tableView.reloadData()
        
        //Handle reward & progress retrieval from plist file. See preparePlistForUse() in AppDelegate.swift
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Get rewards data
        let pathForRewardsPlistFile = appDelegate.rewardsPlistPath
        
        let rewardsData:NSData = NSFileManager.defaultManager().contentsAtPath(pathForRewardsPlistFile)!
        
        do{
            rewardsDict = try NSPropertyListSerialization.propertyListWithData(rewardsData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
        }catch{
            print("An error occured while reading rewards and progress plist")
        }

        //Get progress data
        let pathForProgressPlistFile = appDelegate.progressPlistPath
        
        let progressData:NSData = NSFileManager.defaultManager().contentsAtPath(pathForProgressPlistFile)!
        
        do{
            progressDict = try NSPropertyListSerialization.propertyListWithData(progressData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
        }catch{
            print("An error occured while reading rewards and progress plist")
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table view setup
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of interviews from plist
        return interviews.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! InterviewTableViewCell
        
        //Set up cell
        cell.interviewNameLabel.text = interviews[indexPath.row]
        //TODO: Setup Info Pop Ups for tapping badges
        
        //Set up fire badge - practiced for 10 days straight
        let fireBadge = setBadge("Fire", indexPath: indexPath)
        cell.fireBadge.image = UIImage(named: fireBadge)
        
        //Set up TV badge - watched for 10 days straight
        let tvBadge = setBadge("TV", indexPath: indexPath)
        cell.tvBadge.image = UIImage(named: tvBadge)
        
        //Set up finish badge - completed watching a whole interview
        let finishBadge = setBadge("Finish", indexPath: indexPath)
        cell.finishBadge.image = UIImage(named: finishBadge)
    
        //Set up camera badge - completed practicing a whole interview
        let cameraBadge = setBadge("Camera", indexPath: indexPath)
        cell.cameraBadge.image = UIImage(named: cameraBadge)
        
        //Set up progress labels - shows number of times viewed and practiced
        let progressKey = interviews[indexPath.row]
        if let progressData = progressDict.objectForKey(progressKey) as? NSDictionary {
            let views = progressData.objectForKey("watchModel") as! Int!
            let practices = progressData.objectForKey("practice") as! Int!
            cell.viewProgress.text = String(views)
            cell.practiceProgress.text = String(practices)
        }
        return cell
    }
    
    //This method helps set the badge type
    func setBadge(badge: String, indexPath: NSIndexPath) -> String {
        let key = interviews[indexPath.row]+badge+" Badge"
        var setToBadge = String()
        if let dict = rewardsDict.objectForKey(key) as! NSDictionary? {
            let count = dict.objectForKey("Count") as! Int
            switch count {
            case 1..<5:
                setToBadge = String(badge+"Bronze")
            case 5..<10:
                setToBadge = String(badge+"Silver")
            case 10..<15:
                setToBadge = String(badge+"Gold")
            case 15..<20:
                setToBadge = String(badge+"Platinum")
            case 20..<1000:
                setToBadge = String(badge+"Diamond")
            default:
                //nothing for 0
                setToBadge = String("circle")
            }
        }
        return setToBadge
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowQuestions" {
            let destinationViewController = segue.destinationViewController as! QuestionTableViewController
            
            //Pass interview title to QuestionTableViewController
            if let selectedInterviewCell = sender as? InterviewTableViewCell {
                if let indexPath = tableView.indexPathForCell(selectedInterviewCell) {
                    let interview = interviews[indexPath.row]
                    //                    print(interview)
                    destinationViewController.interview = interview
                    
                }
            }
        }
    }
}