//
//  AppDelegate.swift
//  Dr.Tokushitsu
//
//  Created by Yuta Ooka on 2016/11/01.
//  Copyright © 2016年 Yuta Ooka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var didAgree: Bool = false
    var key: String = "null"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        registerUserDefaults()
        getUserDefaults()
        if didAgree {
            if key == "null" {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "RegisterStoryboard")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            } else if key == "d260b83796537bb9b410b4146ca28a37cfa9b279bafc63d16f2ddbdf8715b9c4" {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "MainStoryboard")
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
            }
        }
        return true
    }

    func registerUserDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["didAgree": false])
        userDefaults.register(defaults: ["TokushitsuKey": "null"])
    }
    
    func getUserDefaults() {
        let userDefaults = UserDefaults.standard
        didAgree = userDefaults.object(forKey: "didAgree") as! Bool
        key = userDefaults.object(forKey: "TokushitsuKey") as! String
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

