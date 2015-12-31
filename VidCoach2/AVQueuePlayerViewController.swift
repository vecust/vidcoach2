//
//  AVQueuePlayerViewController.swift
//  VidCoach2
//
//  Created by Erick Custodio on 12/30/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
//import SimpleAlert

class AVQueuePlayerViewController: AVPlayerViewController {

    //MARK: Properties
    var interview = String()
    var question = String()
    var mode = String()
    var postPromptInfo = PostPrompt()
    var answerArray = [String]()
//    var player = AVQueuePlayer()
    var action = String()
    var url4Player = [NSURL()]
    var playerItems = [AVPlayerItem]()
    var prePromptON = Bool()
    var postPromptON = Bool()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //check prompt settings
        let settingPath = NSBundle.mainBundle().pathForResource("PromptSettings", ofType: "plist")
        let settingDict = NSDictionary(contentsOfFile: settingPath!)
        
        prePromptON = (settingDict?.objectForKey("PrePrompt") as? Bool)!
        postPromptON = (settingDict?.objectForKey("PostPrompt") as? Bool)!
        
        playSegment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Video Methods
    
    func loadVideos(url: String, selector: String){
        let video1 = Video()
        video1.title = "First Interview"
        video1.url = NSBundle.mainBundle().URLForResource(url, withExtension: "mp4")!
        url4Player.append(video1.url)
        let queueVideo = AVPlayerItem(URL: video1.url)

        //Use array for playing all?
        //        playerItems.append(questionVideo)
        
        //Set notification to trigger appropriate selector function when question or answer video has ended.
        let selectorFunc = Selector(selector+"VideoHasEnded:")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selectorFunc, name: AVPlayerItemDidPlayToEndTimeNotification, object: queueVideo)
        
        player = AVPlayer(playerItem: queueVideo)

        player?.play()
    }
    
    func playSegment() {
//        loadVideos(interview+question+"Question","question")
        loadVideos("GeneralGreetingQuestion",selector: "question") //Just for testing. Use previous line for real.

    }
    
    //MARK: Prompt Methods
    
    func questionVideoHasEnded(notification: NSNotification) {
        if prePromptON {
        
        // Get PrePrompt from plist file
        let prePromptFilePath = NSBundle.mainBundle().pathForResource("PrePrompts", ofType: "plist")
        let prePromptDict = NSDictionary(contentsOfFile: prePromptFilePath!)
        
        let prePromptMessage = prePromptDict?.objectForKey(interview+" "+question) as? String
        
        let testAlert = SimpleAlert.Controller(title: prePromptMessage, message: "", style: .Alert)
        testAlert.addAction(SimpleAlert.Action(title: "OK", style: SimpleAlert.Action.Style.Default, handler: {
            (action) -> Void in
            self.loadVideos("GeneralGreetingAnswer", selector: "answer")
        }))
        presentViewController(testAlert, animated: true, completion: nil)
            
        } else {
            self.loadVideos("GeneralGreetingAnswer", selector: "answer")
        }
        
    }

    func answerVideoHasEnded(notification: NSNotification) {
        if postPromptON {
        
        // Get PostPrompt from plist file
        let postPromptFilePath = NSBundle.mainBundle().pathForResource("PostPrompts", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: postPromptFilePath!)
        let postPromptDict = dict?.objectForKey(interview+" "+question)

        //Set up PostPrompt components
        postPromptInfo.message = postPromptDict?.objectForKey("Message") as? String
        postPromptInfo.button1 = postPromptDict?.objectForKey("Button1") as? String
        postPromptInfo.button2 = postPromptDict?.objectForKey("Button2") as? String
        postPromptInfo.button3 = postPromptDict?.objectForKey("Button3") as? String

        answerArray.append(postPromptInfo.button1)
        answerArray.append(postPromptInfo.button2)
        //For True/False questions
        if postPromptInfo.button3 != "" {
        answerArray.append(postPromptInfo.button3)
        }
        
        //Initial PostPrompt setup
        let postPrompt = SimpleAlert.Controller(title: postPromptInfo.message, message: "", style: .Alert)

        
        //Shuffle the answer array
        //TODO: Fix shuffle so that it changes every time
        let shuffledAnswerArray = shuffleArray(answerArray)
        
        //Set up alert buttons
        let buttonOne = SimpleAlert.Action(title: shuffledAnswerArray[0], style: .Default, handler: { (action) -> Void in
            //TODO: Add conditional if PostPrompt setting is on
            self.checkAnswer(shuffledAnswerArray[0])
        })
        postPrompt.addAction(buttonOne)
        
        let buttonTwo = SimpleAlert.Action(title: shuffledAnswerArray[1], style: .Default, handler: { (action) -> Void in
            self.checkAnswer(shuffledAnswerArray[1])
        })
        postPrompt.addAction(buttonTwo)
        
        if postPromptInfo.button3 != "" {
            let buttonThree = SimpleAlert.Action(title: shuffledAnswerArray[2], style: .Default, handler: { (action) -> Void in
                self.checkAnswer(shuffledAnswerArray[2])
            })
            postPrompt.addAction(buttonThree)
            
            //Widen alert to fit longer answers
            postPrompt.configContainerWidth = {
                return 600
            }
        }
        
        //Configure custom look of alert
        postPrompt.configContainerCornerRadius = {
            return 20
        }
        
        presentViewController(postPrompt, animated: true, completion: nil)
        
        } else {
            self.replay()
        }
    }
    
    func checkAnswer(answer: String) {
        //Initial set up of alert
        let answerAlert = SimpleAlert.Controller(title: "", message: "Want to Replay the Video?", style: .Alert)

        let yesAction = SimpleAlert.Action(title: "Yes", style: .Default, handler: { (action) -> Void in
            self.playSegment()
        })
        
        let noAction = SimpleAlert.Action(title: "No", style: .Default, handler: { (action) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
        
        answerAlert.addAction(yesAction)
        answerAlert.addAction(noAction)
        
        //button2 is always the right answer
        if answer == postPromptInfo.button2 {
            //Change alert
            answerAlert.title = "Correct!"
            answerAlert.configContentView = { view in
                view.backgroundColor = UIColor.greenColor()
            }
        } else {
            answerAlert.title = "Nice Try. The correct answer is "+postPromptInfo.button2
            answerAlert.configContentView = { view in
                view.backgroundColor = UIColor.redColor()
            }
        }
        
        presentViewController(answerAlert, animated: true, completion: nil)
    }
    
    func replay() {
        let replayAlert = SimpleAlert.Controller(title: "Want to Replay the Video?", message: "", style: .Alert)
        let yesAction = SimpleAlert.Action(title: "Yes", style: .Default, handler: { (action) -> Void in
                self.playSegment()
        })
        let noAction = SimpleAlert.Action(title: "No", style: .Default, handler: { (action) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
        })
        
        replayAlert.addAction(yesAction)
        replayAlert.addAction(noAction)
        
        presentViewController(replayAlert, animated: true, completion: nil)
    }
    
    func shuffleArray<T>(var array: Array<T>) -> Array<T>
    {
        for var index = array.count - 1; index > 0; index--
        {
            // Random int from 0 to index-1
            let j = Int(arc4random_uniform(UInt32(index-1)))
            
            // Swap two array elements
            // Notice '&' required as swap uses 'inout' parameters
            swap(&array[index], &array[j])
        }
        return array
    }
    
    

}

