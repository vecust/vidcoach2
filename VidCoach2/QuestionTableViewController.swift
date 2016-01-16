//
//  QuestionTableViewController.swift
//  VidCoach2
//
//  This view handles listing the quesitons based on the interview selected in the previous view.
//  Depending on whether "All Questions" or one question was selected, either an array of all the questions
//  or the title of the individually selected question will be passed on to the next view.
//
//  Created by Erick Custodio on 12/28/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit

class QuestionTableViewController: UITableViewController {
    
    // MARK: Properties
    let cellIdentifier = "QuestionTableViewCell"
    var interview = String()
    var questions = [String]()
    var progressDict:NSMutableDictionary!
    var facesDict:NSMutableDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = interview
        
        // Get question titles
        let filePath = NSBundle.mainBundle().pathForResource("interviews", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: filePath!)
        
        questions = dict?.objectForKey(interview) as! [String]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        //This call checks if there are any changes to the cells such as badges and progress
        self.tableView.reloadData()
        
        //Handle progress retrieval from plist file. See preparePlistForUse() in AppDelegate.swift
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Get progress data
        let pathForProgressPlistFile = appDelegate.progressPlistPath
        
        let progressData:NSData = NSFileManager.defaultManager().contentsAtPath(pathForProgressPlistFile)!
        
        do{
            progressDict = try NSPropertyListSerialization.propertyListWithData(progressData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
        }catch{
            print("An error occured while reading progress plist")
        }
        
        //Get faces data
        let pathForFacesPlistFile = appDelegate.facesPlistPath
        
        let facesData:NSData = NSFileManager.defaultManager().contentsAtPath(pathForFacesPlistFile)!
        
        do{
            facesDict = try NSPropertyListSerialization.propertyListWithData(facesData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
        }catch{
            print("An error occured while reading progress plist")
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view setup
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (section == 0) {
            return 1
        } else if (section == 1) {
            return questions.count
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! QuestionTableViewCell
        
        // Configure the cell: the first section has one cell for "All Questions" the second section lists all the questions individually
        if (indexPath.section == 0) {
            cell.questionNameLabel.text = "All Questions"
            
            //Set up progress labels - shows number of times viewed and practiced
            let progressKey = interview
            if let progressData = progressDict.objectForKey(progressKey) as? NSDictionary {
                let views = progressData.objectForKey("watchModel") as! Int!
                let practices = progressData.objectForKey("practice") as! Int!
                cell.viewProgress.text = String(views)
                cell.practiceProgress.text = String(practices)
            }
            
            //Set up faces labels
            let facesKey = interview
            if let facesData = facesDict.objectForKey(facesKey) as? NSDictionary {
                let feeling = facesData.objectForKey("All Questions") as! String!
                switch feeling {
                    case "smile":
                        cell.face.image = UIImage(named: "smile")
                    case "sad":
                        cell.face.image = UIImage(named: "sad")
                    case "meh":
                        cell.face.image = UIImage(named: "meh")
                default:
                    cell.face.image = UIImage(named: "circle")
                }
            }

            
        } else if (indexPath.section == 1) {
            cell.questionNameLabel.text = questions[indexPath.row]
            
            //Set up progress labels - shows number of times viewed and practiced
            let progressKey = questions[indexPath.row]
            if let progressData = progressDict.objectForKey(interview) as? NSDictionary {
                let views = progressData.objectForKey(progressKey+" watchModel") as! Int!
                let practices = progressData.objectForKey(progressKey+" practice") as! Int!
                cell.viewProgress.text = String(views)
                cell.practiceProgress.text = String(practices)
            }
            
            //Set up faces labels
            let facesKey = questions[indexPath.row]
            if let facesData = facesDict.objectForKey(interview) as? NSDictionary {
                let feeling = facesData.objectForKey(facesKey) as! String!
                switch feeling {
                case "smile":
                    cell.face.image = UIImage(named: "smile")
                case "sad":
                    cell.face.image = UIImage(named: "sad")
                case "meh":
                    cell.face.image = UIImage(named: "meh")
                default:
                    cell.face.image = UIImage(named: "circle")
                }


        }
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "ShowDetail" {
            let destinationViewController = segue.destinationViewController as! VideoViewController
            
            //Customize the title of the navigation back button to say "Segment List"
            let backItem = UIBarButtonItem()
            backItem.title = "Segment List"
            navigationItem.backBarButtonItem = backItem
            
            // Pass the selected question to the video view controller.
            if let selectedQuestionCell = sender as? QuestionTableViewCell {
                if let indexPath = tableView.indexPathForCell(selectedQuestionCell) {
                    destinationViewController.interview = interview

                    //Set property values of VideoViewController based on selected cell
                    if indexPath.section == 1 { //Individual quesiton selected
                        let question = questions[indexPath.row]
                        destinationViewController.question = question
                        destinationViewController.playAll = false
                    } else if indexPath.section == 0 { //All Questions selected
                        destinationViewController.question = "All Questions"
                        destinationViewController.playAll = true
                        destinationViewController.questions = questions
                    }
                }
            }
            
            //Handle prompt setting retrieval from plist file. See preparePlistForUse() in AppDelegate.swift
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let pathForThePlistFile = appDelegate.settingPlistPath
            
            let data:NSData = NSFileManager.defaultManager().contentsAtPath(pathForThePlistFile)!
            
            do{
                let settingsToBeSaved = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
                    destinationViewController.prePromptON = (settingsToBeSaved.objectForKey("PrePrompt") as? Bool)!
                    destinationViewController.postPromptON = (settingsToBeSaved.objectForKey("PostPrompt") as? Bool)!
            }catch{
                print("An error occured while writing to prompt setting plist")
            }
   
            
        }
    }
}