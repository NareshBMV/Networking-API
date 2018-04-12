//
//  AppDelegate.swift
//  ExtendingBackgroundTime
//
//  Created by Naresh on 10/04/18.
//  Copyright © 2018 Naresh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundUpdateTask:UIBackgroundTaskIdentifier!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application Did Enter Background : \(UIApplication.shared.backgroundTimeRemaining)")
        print("Entered Background Task")
        doBackgroundTask()
    }

    func doBackgroundTask() {
        self.beginBackgroundDownload()
        let queue = DispatchQueue.global(qos: .background)
        print("Begin Background Download : \(UIApplication.shared.backgroundTimeRemaining)")

        queue.async {
            print("Calling background Async")
            print("Sleeping.........!")
            sleep(2)
            print("End Sleeping.....!")
            self.endBackgroundDownload()
        }
    }
    
    func beginBackgroundDownload() {
        print("Inside Begin background Task")

        backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(withName: "DownloadImages", expirationHandler: {
            print("Once background update is done")
            self.endBackgroundDownload()
        })
    }
    
    func endBackgroundDownload() {
        print("Ending Background Task")
        DispatchQueue.main.async {
            print("Begin Background Download : \(UIApplication.shared.backgroundTimeRemaining)")
        }

        UIApplication.shared.endBackgroundTask(backgroundUpdateTask)
        backgroundUpdateTask = UIBackgroundTaskInvalid
    }
}
