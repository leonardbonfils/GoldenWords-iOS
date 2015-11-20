//
//  AppDelegate.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-10.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var shortcutItem = UIApplicationShortcutItem?.self
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var performShortcutDelegate = true
        
        application.statusBarStyle = .LightContent
        
        UINavigationBar.appearance().barTintColor = UIColor.goldenWordsYellow()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Regular", size: 22 )!, NSForegroundColorAttributeName: UIColor.whiteColor()]
//      UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

        
            if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
                
                performShortcutDelegate = false
            }
        
        return performShortcutDelegate
        
        // Override point for customization after application launch.
    }
    
    func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        
        var succeeded = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var photoViewController = storyboard.instantiateViewControllerWithIdentifier("Pictures") as! PhotoBrowserCollectionViewController
    
        var rootViewController = self.window?.rootViewController
        var revealViewController = self.window?.rootViewController?.revealViewController()
        
        if (shortcutItem.type == "com.LeonardBonfils.GoldenWords.Pictures") {
            
//            self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("Pictures")
//            revealViewController?.pushFrontViewController(, animated: true)
            
//            rootViewController?.presentViewController(photoViewController, animated: true, completion: nil)
            revealViewController?.pushFrontViewController(photoViewController, animated: true)
            
            print("Pictures shortcut loaded")
            MyGlobalVariables.viewControllerToDisplay = "Pictures"
            succeeded = true
        }
        
        else if (shortcutItem.type == "com.LeonardBonfils.GoldenWords.Videos") {
            
            print("Videos shortcut loaded")
            succeeded = true
        }
        
        else if (shortcutItem.type == "com.LeonardBonfils.GoldenWords.SavedArticles") {
            
            print("Saved Articles shortcut loaded")
            succeeded = true
        }
        
        else {
            print("No shortcut item type detected")
            
            succeeded = true
        }
        
        return succeeded
        
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var photoViewController = storyboard.instantiateViewControllerWithIdentifier("Pictures") as! PhotoBrowserCollectionViewController
        
        var rootViewController = self.window?.rootViewController
        var revealViewController = self.window?.rootViewController?.revealViewController()
        
        if MyGlobalVariables.viewControllerToDisplay == "Pictures" {
            rootViewController?.presentViewController(photoViewController, animated: true, completion: nil)
        }
    }

//    func applicationDidBecomeActive(application: UIApplication) {
//        
//        guard let shortcut = shortcutItem else { return }
//        
//        handleShortcut(shortcut)
//        
//        self.shortcutItem = nil
//        
//        
//        
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}