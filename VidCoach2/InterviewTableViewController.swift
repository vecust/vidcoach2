//
//  InterviewTableViewController.swift
//  VidCoach2
//
//  Created by Erick Custodio on 12/24/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit

class InterviewTableViewController: UITableViewController {

    // MARK: Properties
    let cellIdentifier = "InterviewTableViewCell"
    var interviews = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get interview titles
        let filePath = NSBundle.mainBundle().pathForResource("interviews", ofType: "plist")
        if let path = filePath {
            interviews = NSArray(contentsOfFile: path) as! [AnyObject]
        }
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: cellIdentifier)
    }
    
    // MARK: Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return number of interviews from plist
        return interviews.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Dequeue Reusable Cell
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        if let interview = interviews[indexPath.row] as? [String: AnyObject], let name = interview["Interview"] as? String {
            cell.textLabel?.text = name
        }
        return cell
    }

}
