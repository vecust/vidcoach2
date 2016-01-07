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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Get interview titles
        let filePath = NSBundle.mainBundle().pathForResource("interviews", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: filePath!)
        
        //Assign retrieved interview titles to class property
        interviews = dict?.objectForKey("Interviews") as! [String]
        
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
        //TODO: Add awards and progress setup here
        
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