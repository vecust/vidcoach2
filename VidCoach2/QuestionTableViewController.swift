//
//  QuestionTableViewController.swift
//  VidCoach2
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view setup
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! QuestionTableViewCell
        
        // Configure the cell...
        cell.questionNameLabel.text = questions[indexPath.row]
        
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
            
            // Pass the selected object to the new view controller.
            if let selectedQuestionCell = sender as? QuestionTableViewCell {
                if let indexPath = tableView.indexPathForCell(selectedQuestionCell) {
                    let question = questions[indexPath.row]
                    //                    print(interview)
                    destinationViewController.question = question
                    destinationViewController.interview = interview
                }
            }
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