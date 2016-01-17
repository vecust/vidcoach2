//
//  AppDelegate.swift
//  VidCoach2
//
//  Created by Erick Custodio on 12/24/15.
//  Copyright © 2015 Erick Custodio. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var settingPlistPath:String = String()
    var rewardsPlistPath:String = String()
    var progressPlistPath:String = String()
    var facesPlistPath:String = String()
    var earnedPlistPath:String = String()

    //get and set plist files
    func preparePlistForUse(){
        let rootPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, .UserDomainMask, true)[0]
        
        //
        settingPlistPath = rootPath.stringByAppendingString("/PromptSettings.plist")
        if !NSFileManager.defaultManager().fileExistsAtPath(settingPlistPath){
            let settingPlistInBundle = NSBundle.mainBundle().pathForResource("PromptSettings", ofType: "plist") as String!
            do {
                try NSFileManager.defaultManager().copyItemAtPath(settingPlistInBundle, toPath: settingPlistPath)
            }catch{
                print("Error occured while copying file to document \(error)")
            }
        }
        
        rewardsPlistPath = rootPath.stringByAppendingString("/Rewards.plist")
        if !NSFileManager.defaultManager().fileExistsAtPath(rewardsPlistPath){
            let rewardPlistInBundle = NSBundle.mainBundle().pathForResource("Rewards", ofType: "plist") as String!
            do {
                try NSFileManager.defaultManager().copyItemAtPath(rewardPlistInBundle, toPath: rewardsPlistPath)
            }catch{
                print("Error occured while copying file to document \(error)")
            }
        }

        progressPlistPath = rootPath.stringByAppendingString("/Progress.plist")
        if !NSFileManager.defaultManager().fileExistsAtPath(progressPlistPath){
            let progressPlistInBundle = NSBundle.mainBundle().pathForResource("Progress", ofType: "plist") as String!
            do {
                try NSFileManager.defaultManager().copyItemAtPath(progressPlistInBundle, toPath: progressPlistPath)
            }catch{
                print("Error occured while copying file to document \(error)")
            }
        }
        
        facesPlistPath = rootPath.stringByAppendingString("/faces.plist")
        if !NSFileManager.defaultManager().fileExistsAtPath(facesPlistPath){
            let facesPlistInBundle = NSBundle.mainBundle().pathForResource("faces", ofType: "plist") as String!
            do {
                try NSFileManager.defaultManager().copyItemAtPath(facesPlistInBundle, toPath: facesPlistPath)
            }catch{
                print("Error occured while copying file to document \(error)")
            }
        }

        earnedPlistPath = rootPath.stringByAppendingString("/Earned.plist")
        if !NSFileManager.defaultManager().fileExistsAtPath(earnedPlistPath){
            let earnedPlistInBundle = NSBundle.mainBundle().pathForResource("Earned", ofType: "plist") as String!
            do {
                try NSFileManager.defaultManager().copyItemAtPath(earnedPlistInBundle, toPath: earnedPlistPath)
            }catch{
                print("Error occured while copying file to document \(error)")
            }
        }


    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.preparePlistForUse()
        Firebase.defaultConfig().persistenceEnabled = true
        let videoLogReference = Firebase(url: "https://vidcoach2.firebaseio.com/")
        videoLogReference.keepSynced(true)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

        let videoLogReference = Firebase(url: "https://vidcoach2.firebaseio.com/")
        videoLogReference.keepSynced(true)

    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        let videoLogReference = Firebase(url: "https://vidcoach2.firebaseio.com/")
        videoLogReference.keepSynced(true)
        self.preparePlistForUse()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

