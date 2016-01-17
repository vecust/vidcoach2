//
//  ViewController.swift
//  VidCoach2
//
//  This view shows the details of the question(s) selected. Here the user has the option to choose one of three actions:
//  Watch a model answer the question, record themselves practicing their answers to questions, or watch their recordings.
//  The user also can set the post prompts and pre prompts on or off at this point.
//
//  Created by Erick Custodio on 12/24/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class VideoViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var watchPracticeButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var interviewQuestion: UILabel!
    @IBOutlet weak var prePromptSwitch: UISwitch!
    @IBOutlet weak var postPromptSwitch: UISwitch!
    var interview = String()
    var question = String()
    var prePromptON = Bool()
    var postPromptON = Bool()
    var settingDict:NSMutableDictionary!
    var badgeDict:NSMutableDictionary!
    var settingPath:String!
    var badgesPath:String!
    var playAll = Bool()
    var questions = [String]()
    var earnedArray:NSMutableArray!
    var earnedData:NSData!
    var pathForEarnedPlistFile:String!
    
    override func viewWillAppear(animated: Bool) {
        //Get prompt settings from plist file PromptSettings.plist
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        settingPath = appDelegate.settingPlistPath
        let data:NSData = NSFileManager.defaultManager().contentsAtPath(settingPath)!
        do{
            self.saveSetting(prePromptON, key: "PrePrompt")
            self.saveSetting(postPromptON, key: "PostPrompt")

            settingDict = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
            prePromptON = (settingDict.objectForKey("PrePrompt") as? Bool)!
            postPromptON = (settingDict.objectForKey("PostPrompt") as? Bool)!

        }catch{
            print("Error occured while reading from the prompt setting plist file")
        }
        
        //Get badge data from plist file Rewards.plist
        badgesPath = appDelegate.rewardsPlistPath
        let badgeData:NSData = NSFileManager.defaultManager().contentsAtPath(badgesPath)!
        do{
            badgeDict = try NSPropertyListSerialization.propertyListWithData(badgeData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
        }catch{
            print("Error occured while reading from the rewards plist file")
        }

        //See if recorded video exists in the document directory. If the user selected "All Questions" in the previous view,
        //iterate over all questions to see if they all have a record. This check determines if the "Watch Practice" button
        //should be enabled or not.
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        if self.question != "All Questions" {
            let dataPath = documentsDirectory.stringByAppendingPathComponent("/"+interview+question+"Recording.mp4")
            if(NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
                watchPracticeButton.enabled = true
            } else {
                watchPracticeButton.enabled = false
            }
        } else {
            var questionPracticed = false
            
            for question in questions {
                let dataPath = documentsDirectory.stringByAppendingPathComponent("/"+interview+question+"Recording.mp4")
                if(NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
                    questionPracticed = true
                } else {
                    watchPracticeButton.enabled = false
                    questionPracticed = false
                    break
                }
            }
            if questionPracticed {
                watchPracticeButton.enabled = true
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "badgeAlert:", name: "checkBadge", object: nil)
        
        //Set question label
        interviewQuestion.text = question
        
        //Set image based on interview selected
        image.image = UIImage(named: interview)
        
        //Set the prompt setting switches based on settings retrieved from plist file
        if prePromptON {
            self.prePromptSwitch.setOn(true, animated: false)
        } else {
            self.prePromptSwitch.setOn(false, animated: false)
        }
        
        if postPromptON {
            self.postPromptSwitch.setOn(true, animated: false)
        } else {
            self.postPromptSwitch.setOn(false, animated: false)
        }

    }
    
    //This function saves the setting set by the user on the interface. It is called from the prePromptSetting and postPromptSetting IBAction functions
    //It is also called from the prepareForSegue and viewWillDisappear functions
    func saveSetting(setting:Bool,key:String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let pathForThePlistFile = appDelegate.settingPlistPath
        
        let data:NSData = NSFileManager.defaultManager().contentsAtPath(pathForThePlistFile)!
        
        do{
            let settingsToBeSaved = try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
            settingsToBeSaved.setValue(setting, forKey: key)
            settingsToBeSaved.writeToFile(pathForThePlistFile, atomically: true)
        }catch{
            print("An error occured while writing to prompt setting plist")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    
    @IBAction func watchModel(sender: UIButton) {
    }
    
    @IBAction func practice(sender: UIButton) {
    }
    
    @IBAction func watchPractice(sender: UIButton) {
    }
    
    @IBAction func prePromptSetting(sender: UISwitch) {
        if sender.on {
            self.prePromptON = true
            self.saveSetting(true, key: "PrePrompt")
        } else {
            self.prePromptON = false
            self.saveSetting(false, key: "Preprompt")
        }
    }
    
    @IBAction func postPromptSetting(sender: UISwitch) {
        if sender.on {
            self.postPromptON = true
            self.saveSetting(true, key: "PostPrompt")
        } else {
            self.postPromptON = false
            self.saveSetting(false, key: "PostPrompt")
        }
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "watchModel" || segue.identifier == "practice" || segue.identifier == "watchPractice" {
            let destination = segue.destinationViewController as! AVSegmentPlayerViewController
            destination.selectedAction = (segue.identifier)!
            destination.interview = interview
            destination.question = question
            destination.prePromptON = prePromptON
            destination.postPromptON = postPromptON
            destination.playAll = playAll
            destination.questions = questions
        
        //write prompt settings
            self.saveSetting(prePromptON, key: "PrePrompt")
            self.saveSetting(postPromptON, key: "PostPrompt")
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        //write prompt settings
        self.saveSetting(prePromptON, key: "PrePrompt")
        self.saveSetting(postPromptON, key: "PostPrompt")
    }
        
    func badgeAlert(notification: NSNotification) {
        getEarnedData()
        
        let types = ["Fire","TV","Finish","Camera"]
        var number = 0
        var count = 0
        var earned = ""
        
        for type in types {
            count = getBadgeCount(type)
            switch count {
            case 1..<5:
                if checkEarned(type, metal: "Bronze") == 1 {
                    number++
                    earned += "Bronze "+type+" "
                } else {
                    print("Already earned "+self.interview+" Bronze "+type+" badge")
                }
            case 5..<10:
                if checkEarned(type, metal: "Silver") == 1 {
                    number++
                    earned += "Silver "+type+" "
                } else {
                    print("Already earned "+self.interview+" Silver "+type+" badge")
                }
            case 10..<15:
                if checkEarned(type, metal: "Gold") == 1 {
                    number++
                    earned += "Gold "+type+" "
                } else {
                    print("Already earned "+self.interview+" Gold "+type+" badge")
                }
           case 15..<20:
            if checkEarned(type, metal: "Platinum") == 1 {
                number++
                earned += "Platinum "+type+" "
            } else {
                print("Already earned "+self.interview+" Platinum "+type+" badge")
                }
            case 20..<2000:
                if checkEarned(type, metal: "Diamond") == 1 {
                    number++
                    earned += "Diamond "+type+" "
                } else {
                    print("Already earned "+self.interview+" Diamond "+type+" badge")
                }
            default:
                print("No badge for "+type)
            }
        }
        
        var title = ""
        if number == 1 {
            title = "You earned a badge!"
        } else if number > 1 {
            title = "You earned badges!"
        }
        
        if number > 0 {
        let alert = SimpleAlert.Controller(title: title, message: earned, style: SimpleAlert.Controller.Style.Alert)
        let okAction = SimpleAlert.Action(title: "OK", style: SimpleAlert.Action.Style.Default)
        alert.addAction(okAction)
        
            alert.configContainerCornerRadius = {
                return 20
            }
            
        presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func getBadgeCount(badge: String) -> Int {
        var count = 0

        //Get badge data from plist file Rewards.plist
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        badgesPath = appDelegate.rewardsPlistPath
        let badgeData:NSData = NSFileManager.defaultManager().contentsAtPath(badgesPath)!
        do{
            badgeDict = try NSPropertyListSerialization.propertyListWithData(badgeData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
        }catch{
            print("Error occured while reading from the rewards plist file")
        }
        
        let badge = badgeDict.objectForKey(interview+badge+" Badge") as! NSMutableDictionary!
        count = badge.objectForKey("Count") as! Int
        
        return count
    }

    func getEarnedData() {
        //Get earned data
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        pathForEarnedPlistFile = appDelegate.earnedPlistPath
        
        earnedData = NSFileManager.defaultManager().contentsAtPath(pathForEarnedPlistFile)!
        
        do{
            earnedArray = try NSPropertyListSerialization.propertyListWithData(earnedData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
        }catch{
            print("An error occured while reading rewards and progress plist")
        }

    }
    
    func checkEarned(type: String, metal: String) -> Int {
        let check = interview+metal+type
        if earnedArray.containsObject(check) {
            return 0
        } else {
            do {
                let earnedToBeSaved = try NSPropertyListSerialization.propertyListWithData(earnedData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableArray
                earnedToBeSaved.addObject(check)
                earnedToBeSaved.writeToFile(pathForEarnedPlistFile, atomically: true)
            } catch {
                print("An error occurred while writing to earned plist")
            }

            return 1
        }

    }
    
}

