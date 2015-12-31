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




    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
    
    func loadVideos(url: String){
        let video1 = Video()
        video1.title = "First Interview"
        video1.url = NSBundle.mainBundle().URLForResource(url, withExtension: "mp4")!
        url4Player.append(video1.url)
        var questionVideo = AVPlayerItem(URL: video1.url)
        playerItems.append(questionVideo)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "videoHasEnded:", name: AVPlayerItemDidPlayToEndTimeNotification, object: questionVideo)
        
//        let video2 = Video()
//        video2.title = "Second Interview"
//        video2.url = NSBundle.mainBundle().URLForResource(interview+question+"Answer", withExtension: "mp4")!
//        url4Player.append(video2.url)
//        var answerVideo = AVPlayerItem(URL: video2.url)
//        playerItems.append(answerVideo)
        
        player = AVPlayer(playerItem: questionVideo)

        player?.play()
    }
    
    func playSegment() {
        loadVideos(interview+question+"Question")
    }
    
    func videoHasEnded(notification: NSNotification) {
        let testAlert = SimpleAlert.Controller(title: "Test Alert!", message: "This is a test", style: .Alert)
        testAlert.addAction(SimpleAlert.Action(title: "OK", style: SimpleAlert.Action.Style.Default, handler: {
            (action) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
        }))
        presentViewController(testAlert, animated: true, completion: nil)
    }
    
    //MARK: Prompt Methods
    
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

