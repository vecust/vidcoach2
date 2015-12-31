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
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var interviewQuestion: UILabel!
    @IBOutlet weak var prePromptSwitch: UISwitch!
    @IBOutlet weak var postPromptSwitch: UISwitch!
    var url4Player = [NSURL()]
    var playerItems = [AVPlayerItem]()
    var interview = String()
    var question = String()
    var mode = String()
    var prePromptON = Bool()
    var postPromptON = Bool()
    var settingDict = NSMutableDictionary()
    var settingPath = String()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interviewQuestion.text = question
        image.image = UIImage(named: interview)
        title = question
        
        //check prompt settings
        settingPath = NSBundle.mainBundle().pathForResource("PromptSettings", ofType: "plist")!
        settingDict = NSMutableDictionary(contentsOfFile: settingPath)!
        
        prePromptON = (settingDict.objectForKey("PrePrompt") as? Bool)!
        postPromptON = (settingDict.objectForKey("PostPrompt") as? Bool)!
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    
    @IBAction func watchModel(sender: UIButton) {
//        print("Tapped Watch Model")
        mode = "Watch Model"
    }
    
    @IBAction func practice(sender: UIButton) {
//        print("Tapped Practice")
        mode = "Practice"
    }
    
    @IBAction func watchPractice(sender: UIButton) {
//        print("Tapped Watch Practice")
        mode = "Watch Practice"
    }
    
    @IBAction func prePromptSetting(sender: UISwitch) {
//        print("Switched PrePrompt Setting")
        if sender.on {
            prePromptON = true
            settingDict.setValue(true, forKey: "PrePrompt")
        } else {
            prePromptON = false
            settingDict.setValue(false, forKey: "PrePrompt")
        }
    }
    
    @IBAction func postPromptSetting(sender: UISwitch) {
        if sender.on {
            postPromptON = true
            settingDict.setValue(true, forKey: "PostPrompt")
        } else {
            postPromptON = false
            settingDict.setValue(false, forKey: "PostPrompt")
        }
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! AVQueuePlayerViewController
        destination.action = mode
        
        //write prompt settings
        settingDict.writeToFile(settingPath, atomically: false)
        
        if segue.identifier == "watchModel" {
            destination.interview = interview
            destination.question = question
        } else if segue.identifier == "practice" {
//            let destination = segue.destinationViewController as! AVQueuePlayerViewController
//            destination.player = AVPlayer(URL: url4Player[2])
//            destination.player?.play()
        } else if segue.identifier == "watchPractice" {
//            let destination = segue.destinationViewController as! AVQueuePlayerViewController
//            destination.player = AVPlayer(URL: url4Player[3])
//            destination.player?.play()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        //write prompt settings
        settingDict.writeToFile(settingPath, atomically: false)
    }
    
    

}

