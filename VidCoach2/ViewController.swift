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

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var interviewTitle: UILabel!
    @IBOutlet weak var interviewQuestion: UILabel!
    var url4Player = [NSURL()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Load video
        
        let video1 = Video()
        video1.title = "First Interview"
        video1.url = NSBundle.mainBundle().URLForResource("kerriGreeting", withExtension: "mp4")!
        url4Player.append(video1.url)

        let video2 = Video()
        video2.title = "Second Interview"
        video2.url = NSBundle.mainBundle().URLForResource("steveGreeting", withExtension: "mp4")!
        url4Player.append(video2.url)

        let video3 = Video()
        video3.title = "Third Interview"
        video3.url = NSBundle.mainBundle().URLForResource("gillianGreeting", withExtension: "mp4")!
        url4Player.append(video3.url)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Actions
    
    @IBAction func watchModel(sender: UIButton) {
        print("Tapped Watch Model")
    }
    
    @IBAction func practice(sender: UIButton) {
        print("Tapped Practice")
    }
    
    @IBAction func watchPractice(sender: UIButton) {
        print("Tapped Watch Practice")
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "watchModel" {
            let destination = segue.destinationViewController as! AVPlayerViewController
            destination.player = AVPlayer(URL: url4Player[1])
            destination.player?.play()
        } else if segue.identifier == "practice" {
            let destination = segue.destinationViewController as! AVPlayerViewController
            destination.player = AVPlayer(URL: url4Player[2])
            destination.player?.play()
        } else if segue.identifier == "watchPractice" {
            let destination = segue.destinationViewController as! AVPlayerViewController
            destination.player = AVPlayer(URL: url4Player[3])
            destination.player?.play()
        }
    }
}

