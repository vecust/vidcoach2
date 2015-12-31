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
    var url4Player = [NSURL()]
    var playerItems = [AVPlayerItem]()
    var interview = String()
    var question = String()
    var mode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interviewQuestion.text = question
        image.image = UIImage(named: interview)
        title = question
        
        // Load video
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    
    @IBAction func watchModel(sender: UIButton) {
        print("Tapped Watch Model")
        mode = "Watch Model"
    }
    
    @IBAction func practice(sender: UIButton) {
        print("Tapped Practice")
        mode = "Practice"
    }
    
    @IBAction func watchPractice(sender: UIButton) {
        print("Tapped Watch Practice")
        mode = "Watch Practice"
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! AVQueuePlayerViewController
        destination.action = mode
        
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
    
    

}

