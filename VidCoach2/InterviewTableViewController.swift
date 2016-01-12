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
        //TODO: Replace badges with real badges
        //TODO: Setup Info Pop Ups for tapping badges
        
        //Set up fire badge - practiced for 10 days straight
        let fireKey = interviews[indexPath.row]+"Fire Badge"
        if let fireArray = rewardsDict.objectForKey(fireKey) {
            if fireArray.count == 10 {
                //Show test badge. Replace with real badge
                cell.yellowBadge.hidden = false
            }
        }
        
        //Set up TV badge - watched for 10 days straight
        let tvKey = interviews[indexPath.row]+"TV Badge"
        if let tvArray = rewardsDict.objectForKey(tvKey) {
            if tvArray.count == 10 {
                //Show test badge. Replace with real badge
                cell.redBadge.hidden = false
            }
        }
        
        //Set up finish badge - completed watching a whole interview
        let finishKey = interviews[indexPath.row]+"Finish Badge"
        if let didFinish = rewardsDict.objectForKey(finishKey) as? Bool {
            if didFinish {
                //Show test badge. Replace with real badge
                cell.purpleBadge.hidden = false
            }
        }
        
        //Set up camera badge - completed practicing a whole interview
        let cameraKey = interviews[indexPath.row]+"Camera Badge"
        if let didRecord = rewardsDict.objectForKey(cameraKey) as? Bool {
            if didRecord {
                //Show test badge. Replace with real badge
                cell.greenBadge.hidden = false
            }
        }
        
        //Set up progress label - shows percentage of watching and practicing interview
        let progressKey = interviews[indexPath.row]
        if let progressData = progressDict.objectForKey(progressKey) as? NSDictionary {
            let countArray = progressData.allValues
            var count = 0
            for i in 0..<countArray.count {
                if Int(countArray[i] as! NSNumber) != 0 {
                    count++
                }
            }
            let formatter = NSNumberFormatter()
            formatter.maximumFractionDigits = 0
            let percentage = (Double(count)/Double(countArray.count))*100.00
            let formattedNumber = formatter.stringFromNumber(percentage)
            cell.interviewProgress.text = formattedNumber!+"%"
        }
        return cell
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