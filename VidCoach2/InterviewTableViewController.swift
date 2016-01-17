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
    var earnedArray:NSMutableArray!
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
        
        //Get earned data
        let pathForEarnedPlistFile = appDelegate.earnedPlistPath
        
        let earnedData:NSData = NSFileManager.defaultManager().contentsAtPath(pathForEarnedPlistFile)!
        
        do{
            earnedArray = try NSPropertyListSerialization.propertyListWithData(earnedData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
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
            var views = 0
            var practices = 0
            for (question,count) in progressData {
                let questionString = question as! String
                if (questionString.rangeOfString("watchModel") != nil) {
                    views += count as! Int
                }
                if (questionString.rangeOfString("practice") != nil) {
                    practices += count as! Int
                }
            }
            cell.viewProgress.text = String(views)
            cell.practiceProgress.text = String(practices)
        }
        return cell
    }
    
    //This method helps set the badge type
    func setBadge(badge: String, indexPath: NSIndexPath) -> String {
        let metals = ["Bronze","Silver","Gold","Platinum","Diamond"]
        let interview = interviews[indexPath.row]
        var setToBadge = String()

        for metal in metals {
            if earnedArray.containsObject(interview+metal+badge) {
                setToBadge = badge+metal
                break
            } else {
                setToBadge = "circle"
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