//
//  ViewController.swift
//  VidCoach2
//
//  Created by Erick Custodio on 12/24/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class VideoViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var watchPracticeButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var interviewQuestion: UILabel!
    @IBOutlet weak var prePromptSwitch: UISwitch!
    @IBOutlet weak var postPromptSwitch: UISwitch!
    var url4Player = [NSURL()]
    var playerItems = [AVPlayerItem]()
    var interview = String()
    var question = String()
    var prePromptON = Bool()
    var postPromptON = Bool()
    var settingDict:NSMutableDictionary!
    var settingPath:String!

    
    override func viewWillAppear(animated: Bool) {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interviewQuestion.text = question
        image.image = UIImage(named: interview)
        title = question
        
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

        //See if recorded video exists in the document directory
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent(interview+question+"Recording")
        if(NSFileManager.defaultManager().fileExistsAtPath(dataPath)) {
            watchPracticeButton.enabled = true
        } else {
            watchPracticeButton.enabled = false
        }
        

        
    }

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
//        print("Tapped Watch Model")
    }
    
    @IBAction func practice(sender: UIButton) {
//        print("Tapped Practice")
    }
    
    @IBAction func watchPractice(sender: UIButton) {
//        print("Tapped Watch Practice")
    }
    
    @IBAction func prePromptSetting(sender: UISwitch) {
//        print("Switched PrePrompt Setting")
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
        
        //write prompt settings
            self.saveSetting(prePromptON, key: "PrePrompt")
            self.saveSetting(postPromptON, key: "PostPrompt")
        }
//        if segue.identifier == "watchModel" {
//            destination.interview = interview
//            destination.question = question
//        } else if segue.identifier == "practice" {
////            let destination = segue.destinationViewController as! AVQueuePlayerViewController
////            destination.player = AVPlayer(URL: url4Player[2])
////            destination.player?.play()
//        } else if segue.identifier == "watchPractice" {
////            let destination = segue.destinationViewController as! AVQueuePlayerViewController
////            destination.player = AVPlayer(URL: url4Player[3])
////            destination.player?.play()
//        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        //write prompt settings
        self.saveSetting(prePromptON, key: "PrePrompt")
        self.saveSetting(postPromptON, key: "PostPrompt")
    }
    

}

