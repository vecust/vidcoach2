//
//  AVSegmentPlayerViewController.swift
//  VidCoach2
//
//  This view handles playing the videos and prompts
//
//  Created by Erick Custodio on 12/30/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices
import Firebase

class AVSegmentPlayerViewController: AVPlayerViewController, AVPlayerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    var selectedAction = String()
    var interview = String()
    var question = String()
    var postPromptAnswer = String()
    var prePromptON = Bool()
    var postPromptON = Bool()
    var playAll = Bool()
    var questions = [String]()
    var videoIndex = Int() //This is a counter to help determine if you reached the end of "All Questions"
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var deviceID = UIDevice.currentDevice().identifierForVendor!.UUIDString
    var videoLogReference = Firebase(url: "https://vidcoach2.firebaseio.com/")
    var rewardsDict:NSMutableDictionary!
    var progressDict:NSMutableDictionary!
    var facesDict:NSMutableDictionary!
    var earnedArray:NSMutableArray!
    var rewardsData:NSData!
    var progressData:NSData!
    var earnedData:NSData!
    var facesData:NSData!
    var pathForRewardsPlistFile:String!
    var pathForProgressPlistFile:String!
    var pathForEarnedPlistFile:String!
    var pathForfacesPlistFile:String!

    override func viewWillAppear(animated: Bool) {
        //Handle reward & progress retrieval from plist file. See preparePlistForUse() in AppDelegate.swift
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Get rewards data
        pathForRewardsPlistFile = appDelegate.rewardsPlistPath
        
        rewardsData = NSFileManager.defaultManager().contentsAtPath(pathForRewardsPlistFile)!
        
        do{
            rewardsDict = try NSPropertyListSerialization.propertyListWithData(rewardsData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
        }catch{
            print("An error occured while reading rewards and progress plist")
        }
        
        //Get progress data
        pathForProgressPlistFile = appDelegate.progressPlistPath
        
        progressData = NSFileManager.defaultManager().contentsAtPath(pathForProgressPlistFile)!
        
        do{
            progressDict = try NSPropertyListSerialization.propertyListWithData(progressData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
        }catch{
            print("An error occured while reading rewards and progress plist")
        }

        //Get faces data
        pathForfacesPlistFile = appDelegate.facesPlistPath
        
        facesData = NSFileManager.defaultManager().contentsAtPath(pathForfacesPlistFile)!
        
        do{
            facesDict = try NSPropertyListSerialization.propertyListWithData(facesData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
        }catch{
            print("An error occured while reading rewards and progress plist")
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //Set counter to zero
        videoIndex = 0
        
        //Kick off playing videos and prompts
        playSegment()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName("checkBadge", object: nil)
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
    
    //This function sets up the avplayer and observer to set off a notification to trigger a selector function to handle prompts
    func loadVideos(url: String, selector: String){ //Parameters: url - actual name of video to be loaded, selector - either "question" or "answer"
        
        if selector == "question" || selectedAction == "watchModel" {   //This condition checks first if a question is to be loaded, the "watchModel" condition
                                                                        //will load the answer video so long as "Practice" or "Watch Practice is not selected
            //Get video file location and load it to local AVPlayerItem
            let video2Load = Video()
            video2Load.url = NSBundle.mainBundle().URLForResource(url, withExtension: "mp4")!
            let queueVideo = AVPlayerItem(URL: video2Load.url)
            
            //Set notification to trigger appropriate selector function when question or answer video has ended.
            let selectorFunc = Selector(selector+"VideoHasEnded:")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: selectorFunc, name: AVPlayerItemDidPlayToEndTimeNotification, object: queueVideo)

            //Set view controller's player to new AVPlayer with local AVPlayerItem
            self.player = AVPlayer(playerItem: queueVideo)
            
            //print("Playing: "+url)
            
            //If user is playing all questions, set view controller's question property to the respective title in the questions array.
            //This will help when loadVideos function is called again to load the answer accompanying this current video item.
            if self.playAll {
                question = questions[videoIndex]
            }
            self.player?.play()
            
            
        } else { //selectedAction == "Practice" || "Watch Practice"
            
            //Find the user recorded video in the document directory
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent("/"+interview+question+"Recording.mp4")
            
            let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: dataPath)))
            let queueVideo = AVPlayerItem(asset: videoAsset)
            
            //Set notification to trigger appropriate selector function when question or answer video has ended.
            let selectorFunc = Selector(selector+"VideoHasEnded:")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: selectorFunc, name: AVPlayerItemDidPlayToEndTimeNotification, object: queueVideo)
            
            player = AVPlayer(playerItem: queueVideo)
            if self.playAll {
                question = questions[videoIndex]
            }
            self.player?.play()
        }
    }
    
    func playSegment() {
        //If an individual question was selected, only load that one. If "All Questions" was selected, load the first video of the first question
        //based off of the questions array
        if !playAll {
            loadVideos(interview+question+"Question",selector: "question")
        } else if playAll {
            loadVideos(interview+questions[videoIndex]+"Question", selector: "question")
        }
    }
    
    //MARK: Prompt Methods
    
    //This function gets called when a question video has ended (This is the one with the interviewer)
    func questionVideoHasEnded(notification: NSNotification) {
        
        //Log Activity to Firebase
        if self.playAll {
            self.logActivity(self.questions[self.videoIndex], type: "Question")
        } else {
            self.logActivity(self.question, type: "Question")
        }

        if prePromptON { //If the pre prompt setting is on, load the alert and present it.
        
        // Get PrePrompt from plist file
        let prePromptFilePath = NSBundle.mainBundle().pathForResource("PrePrompts", ofType: "plist")
        let prePromptDict = NSDictionary(contentsOfFile: prePromptFilePath!)
        
        let prePromptMessage = prePromptDict?.objectForKey(interview+" "+question) as? String
        
        let testAlert = SimpleAlert.Controller(title: prePromptMessage, message: "", style: .Alert)
            testAlert.configContainerCornerRadius = {
                return 20
            }
            
            testAlert.addAction(SimpleAlert.Action(title: "OK", style: SimpleAlert.Action.Style.Default, handler: {
            (action) -> Void in
            
            //When the "OK" button is tapped the following code executes
            if self.selectedAction != "practice" { //This condition checks to see if the next thing to be loaded is an answer video or the camera recorder
                if !self.playAll { //Load next associated answer video. The first condition is for individual questions.
                    self.loadVideos(self.interview+self.question+"Answer", selector: "answer")
                } else { //Load answer video referenced from questions array based on index count. Condition: "All Questions" selected
                    self.loadVideos(self.interview+self.questions[self.videoIndex]+"Answer", selector: "answer")
                }
            } else {
                self.recordVideo()
            }
        }))
        presentViewController(testAlert, animated: true, completion: nil)
            
        } else { //prePrompt is off. Basically runs the same code as if "OK" button was tapped, but without the alert.
            if self.selectedAction != "practice" {
                if !self.playAll {
                    self.loadVideos(self.interview+self.question+"Answer", selector: "answer")
                } else {
                    self.loadVideos(self.interview+self.questions[self.videoIndex]+"Answer", selector: "answer")
                }
                
            } else {
                self.recordVideo()
            }
        }
        
    }

    //This function gets called when an answer video has ended.
    func answerVideoHasEnded(notification: NSNotification) {
        //Log Progress - counts how many times the user watched or practiced
        logProgress()
        
        //Log activity
        if self.playAll {
            self.logActivity(self.questions[self.videoIndex], type: "Answer")

            //Log Finish badge - checks how consistently the user watched a whole interview if last video has ended
            if self.videoIndex == questions.count-1 {
                self.logBadge("Finish")
            }
        } else {
            self.logActivity(self.question, type: "Answer")
            
            //Log TV badge - checks how consistently the user watched a single video
            logBadge("TV")
        }

        if postPromptON { //If the post prompt setting is on, load the alert with the question and answer choices and present it.
        let postPromptInfo = PostPrompt()
        var answerArray = [String]()

        // Get PostPrompt from plist file
        let postPromptFilePath = NSBundle.mainBundle().pathForResource("PostPrompts", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: postPromptFilePath!)
        let postPromptDict = dict?.objectForKey(interview+" "+question)

        //Set up PostPrompt components
        postPromptInfo.message = postPromptDict?.objectForKey("Message") as? String
        postPromptInfo.button1 = postPromptDict?.objectForKey("Button1") as? String
        postPromptInfo.button2 = postPromptDict?.objectForKey("Button2") as? String
        self.postPromptAnswer = postPromptInfo.button2  //This helps reference the correct answer. "Button2" in the plist is hard coded as correct answer
                                                        //for all post prompts
        postPromptInfo.button3 = postPromptDict?.objectForKey("Button3") as? String

        answerArray.append(postPromptInfo.button1)
        answerArray.append(postPromptInfo.button2)
        
        //Check for True/False prompts. button3 is an empty string if it is a True/False prompt.
        if postPromptInfo.button3 != "" {
        answerArray.append(postPromptInfo.button3)
        }
        
        //Initial PostPrompt setup
        let postPrompt = SimpleAlert.Controller(title: postPromptInfo.message, message: "", style: .Alert)

        
        //Shuffle the answer array
        let shuffledAnswerArray = shuffleArray(answerArray)
        
        //Set up alert buttons for answer choices of prompt. When any of them are tapped, the checkAnswer function is called to see if they got it right.
        let buttonOne = SimpleAlert.Action(title: shuffledAnswerArray[0], style: .Default, handler: { (action) -> Void in
            self.checkAnswer(shuffledAnswerArray[0])
        })
        postPrompt.addAction(buttonOne)
        
        let buttonTwo = SimpleAlert.Action(title: shuffledAnswerArray[1], style: .Default, handler: { (action) -> Void in
            self.checkAnswer(shuffledAnswerArray[1])
        })
        postPrompt.addAction(buttonTwo)
        
        //Again checks for True/False prompt before trying to setup the alert button and adding it to the alert.
        if postPromptInfo.button3 != "" {
            let buttonThree = SimpleAlert.Action(title: shuffledAnswerArray[2], style: .Default, handler: { (action) -> Void in
                self.checkAnswer(shuffledAnswerArray[2])
            })
            postPrompt.addAction(buttonThree)
            
            //Widen alert to fit longer answers. This is done in this statement so that True/False alerts are not unnecessarily large.
            postPrompt.configContainerWidth = {
                return 300
            }
            
            buttonOne.button.frame.size.height = 100
            buttonTwo.button.frame.size.height = 100
            buttonThree.button.frame.size.height = 100

            buttonOne.button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            buttonOne.button.titleLabel?.textAlignment = NSTextAlignment.Center
            buttonOne.button.titleEdgeInsets.left = 15.0
            buttonOne.button.titleEdgeInsets.right = 15.0
            
            buttonTwo.button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            buttonTwo.button.titleLabel?.textAlignment = NSTextAlignment.Center
            buttonTwo.button.titleEdgeInsets.left = 15.0
            buttonTwo.button.titleEdgeInsets.right = 15.0

            buttonThree.button.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
            buttonThree.button.titleLabel?.textAlignment = NSTextAlignment.Center
            buttonThree.button.titleEdgeInsets.left = 15.0
            buttonThree.button.titleEdgeInsets.right = 15.0

        }
        
        //Configure custom look of alert. Round the corners
        postPrompt.configContainerCornerRadius = {
            return 20
        }
        
        presentViewController(postPrompt, animated: true, completion: nil)
        
        } else { //Post prompt setting is off.
            if !self.playAll { //Condition: playing one interview question. In this case, call the replay function.
                self.replay()
            } else { //Condition: playing all questions
                if self.videoIndex == questions.count-1 { //If the last video of the interview has been played, call the replay function.
                    self.replay()
                } else { //Increment the counter and based off of that index, load the video for the next interview question.
                    videoIndex++
                    loadVideos(interview+questions[videoIndex]+"Question", selector: "question")
                }
            }
        }
    }
    
    //This function gets called when an answer choice in a post prompt alert is tapped.
    func checkAnswer(answer: String) {
        //Initial set up of alert
        var answerAlert = SimpleAlert.Controller(title: "", message: "Want to Replay the Video?", style: .Alert)

        if self.playAll && videoIndex != questions.count-1 {    //If "All Questions" is selected and we have not yet reached the last question,
                                                                //set the "OK" button to increment the counter and based off of that index, load the video for the next interview question.
            answerAlert = SimpleAlert.Controller(title: "", message: "", style: .Alert)
            let okAction = SimpleAlert.Action(title: "OK", style: .Default, handler: { (action) -> Void in
                self.videoIndex++
                self.loadVideos(self.interview+self.questions[self.videoIndex]+"Question", selector: "question")
            })
            answerAlert.addAction(okAction)
        } else { //Condition: "All Questions" and we have reached the last question OR playing one interview question
            
            //Set button to respond yes to replaying the video
            let yesAction = SimpleAlert.Action(title: "Yes", style: .Default, handler: { (action) -> Void in
                if self.playAll { //Log activity at this point
                    self.logActivity(self.questions[self.videoIndex], type: "ReplayAll")
                    
                    //Reset the counter if "All Questions" to start from the beginning of questions array.
                    self.videoIndex = 0
                } else {
                    self.logActivity(self.question, type: "ReplayOne")
                }
                
                self.playSegment() //This call starts everything all over again.

            })
            
            //Set button to respond no to replaying the video. In this case, pop the current view and go back to the VideoViewController
            let noAction = SimpleAlert.Action(title: "No", style: .Default, handler: { (action) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            })
        
            answerAlert.addAction(yesAction)
            answerAlert.addAction(noAction)
        }
        
        //Change alert title and color based on right or wrong answer.
        if answer == postPromptAnswer {
            //button2 is always the right answer
            answerAlert.title = "Correct!"
            answerAlert.configContentView = { view in
                view.backgroundColor = UIColor(red: 161.0/255.0, green: 212.0/255.0, blue: 144.0/255.0, alpha: 1.0)
            }
        } else {
            answerAlert.title = "Nice Try. The correct answer is: "+postPromptAnswer
            answerAlert.configContentView = { view in
                view.backgroundColor = UIColor(red: 212.0/255.0, green: 144.0/255.0, blue: 144.0/255.0, alpha: 1.0)
            }
        }
        
        answerAlert.configContainerCornerRadius = {
            return 20
        }
        
        presentViewController(answerAlert, animated: true, completion: nil)
    }
    
    //This function is called to present a replay request alert only when the post prompt setting is off.
    func replay() {
        let replayAlert = SimpleAlert.Controller(title: "Want to Replay the Video?", message: "", style: .Alert)
        let yesAction = SimpleAlert.Action(title: "Yes", style: .Default, handler: { (action) -> Void in
            //Log Activity
            if self.playAll {
                self.logActivity(self.questions[self.videoIndex], type: "ReplayAll")
            } else {
                self.logActivity(self.question, type: "ReplayOne")
            }
            self.videoIndex = 0
            self.playSegment()
        })
        let noAction = SimpleAlert.Action(title: "No", style: .Default, handler: { (action) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
        
        replayAlert.addAction(yesAction)
        replayAlert.addAction(noAction)
        
        replayAlert.configContainerCornerRadius = {
            return 20
        }
        
        presentViewController(replayAlert, animated: true, completion: nil)
    }
    
    //This function is called to shuffle the answer choices for post prompts.
    func shuffleArray<T>(var array: Array<T>) -> Array<T>
    {
        for i in 0..<array.count-1 {
            let j = Int(arc4random_uniform(UInt32(array.count-i))) + i
            guard i != j else { continue }
            swap(&array[i], &array[j])
        }        
        return array
    }
    
    //MARK: Recorder Methods
    
    //This function sets up the default iOS video recorder
    func recordVideo() {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)){
            imagePicker.sourceType = .Camera
            imagePicker.cameraDevice = .Front
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            let cameraAlert = SimpleAlert.Controller(title: "Camera inaccessable", message: "Application cannot access the camera.", style: .Alert)
            presentViewController(cameraAlert, animated: true, completion: nil)
        }
    }
    
    //This function gets called when a video is done recording
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //print("Got a video")
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType == kUTTypeMovie as String {
            let path = (info[UIImagePickerControllerMediaURL] as! NSURL).path
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path!) {
                UISaveVideoAtPathToSavedPhotosAlbum(path!, self, "videoWasSavedSuccessfully:didFinishSavingWithError:context:", nil)
                
                //Save video to the app directory
                let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL)!
                let videoData = NSData(contentsOfURL: pickedVideo)
                let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                let documentsDirectory: AnyObject = paths[0]
                let dataPath = documentsDirectory.stringByAppendingPathComponent("/"+interview+question+"Recording.mp4")
                videoData?.writeToFile(dataPath, atomically: false)
            }
        }
        
    }
    
    //This function gets called when a video is saved.
    func videoWasSavedSuccessfully(videoPath: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>) {
        //print("Video saved")
        var title = "Practice Complete!"
        var message = "How do you feel?"
        
        if let saveError = error {
            title = "Error"
            message = "Video failed to save: \(saveError)"
            print(saveError)
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            })
        }
        
        //Present alert validating that video was saved.
        let alert = SimpleAlert.Controller(title: title, message: message, style: .Alert)
        
        alert.configContainerCornerRadius = {
            return 20
        }
        
        alert.addAction(SimpleAlert.Action(title: "😀", style: .Default, handler: { (action) -> Void in
            self.alertActionFaceButton("smile")
        }))
        alert.addAction(SimpleAlert.Action(title: "😐", style: .Default, handler: { (action) -> Void in
            self.alertActionFaceButton("meh")
        }))
        alert.addAction(SimpleAlert.Action(title: "🙁", style: .Default, handler: { (action) -> Void in
            self.alertActionFaceButton("sad")
        }))
                
        //Log Progress - counts how many times the user watched or practiced
        logProgress()
        
        //Log Fire badge - checks how consistently the user practiced any single video
        logBadge("Fire")
        
        //Only present alert if in practice mode and practicing one interview question or practicing all questions and the last video has been played.
        if self.selectedAction == "practice" && (!self.playAll || self.videoIndex == questions.count) {
            self.logActivity(self.question, type: "MadeRecording")
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.logActivity(self.questions[self.videoIndex], type: "MadeRecording")
            self.videoIndex++
            if self.videoIndex != self.questions.count {
                self.loadVideos(self.interview+self.questions[self.videoIndex]+"Question", selector: "question")
            } else {
                //Log Camera badge - checks how consistently the user practiced a whole interview
                logBadge("Camera")
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func alertActionFaceButton(face:String) {
        let interviewFaces = self.facesDict.objectForKey(self.interview) as! NSMutableDictionary!
        if self.playAll {
            interviewFaces[self.questions[self.videoIndex]] = face
        } else {
            interviewFaces[self.question] = face
        }
        do {
            let faceToBeSaved = try NSPropertyListSerialization.propertyListWithData(self.facesData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
            faceToBeSaved.setValue(interviewFaces, forKey: self.interview)
            faceToBeSaved.writeToFile(self.pathForfacesPlistFile, atomically: true)
        } catch {
            print("An error occurred while writing badge to faces plist")
        }
        
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    //MARK: Logging Methods
    
    //This function formats current date to a string and sends timestamp, deviceID, and video to Firebase database
    func logActivity(question: String, type: String){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy ' ' HH:mm:ss zzz"
        let timeStamp = dateFormatter.stringFromDate(NSDate())
        let post = ["device": deviceID, "timestamp": timeStamp, "mode": selectedAction, "interview": interview, "question": question, "type": type]
        let postRef = self.videoLogReference.childByAutoId()
        postRef.setValue(post)
    }

    func logProgress() {
        //Log Activity for progress tracker to plist file
        let interviewProgress = progressDict.objectForKey(interview) as? NSMutableDictionary
        var progressCount = interviewProgress?.objectForKey(question+" "+self.selectedAction) as! Int
        progressCount++
        if self.playAll {
            interviewProgress![self.selectedAction] = progressCount
        } else {
            interviewProgress![question+" "+self.selectedAction] = progressCount
        }
        do {
            let progressToBeSaved = try NSPropertyListSerialization.propertyListWithData(progressData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
            progressToBeSaved.setValue(interviewProgress, forKey: interview)
            progressToBeSaved.writeToFile(pathForProgressPlistFile, atomically: true)
        } catch {
            print("An error occurred while writing to progress plist")
        }

    }
    //This method takes the badge type as a parameter. It checks to see if today's date is after the last day a video was viewed or practiced and updates the count accordingly in Rewards.plist
    func logBadge(badge: String) {
        //Log to rewards when an interview has been completely viewed
        let interviewComplete = rewardsDict.objectForKey(interview+badge+" Badge") as! NSMutableDictionary!
        var previousDate = interviewComplete.objectForKey("Date") as! NSDate
        //print(previousDate)
        var count = interviewComplete.objectForKey("Count") as! Int
        
        if count == 0 {
            previousDate = NSDate()
        }
        
        //print(badge+" previous count: "+String(count))
        if daysInbetween(previousDate) <= 1 {
            count++
        } else if daysInbetween(previousDate) > 1 {
            count = 0
        }
        interviewComplete["Count"] = count
        interviewComplete["Date"] = NSDate()
        
        do {
            let finishBadgeToBeSaved = try NSPropertyListSerialization.propertyListWithData(rewardsData, options: NSPropertyListMutabilityOptions.MutableContainersAndLeaves, format: nil) as! NSMutableDictionary
            finishBadgeToBeSaved.setValue(interviewComplete, forKey: interview+badge+" Badge")
            finishBadgeToBeSaved.writeToFile(pathForRewardsPlistFile, atomically: true)
        } catch {
            print("An error occurred while writing badge to reward plist")
        }
    }
    
    //Helper method to count number of days between today and the last date a video was viewed or practiced
    func daysInbetween(lastDate:NSDate) ->Int {
        var count = 0
        
        let cal = NSCalendar.currentCalendar()
        
        let unit:NSCalendarUnit = .Day
        
        let components = cal.components(unit, fromDate: lastDate, toDate: NSDate(), options: .MatchLast)
        
        count = components.day
        
        return count
    }
}

