//
//  AppDelegate.swift
//  DocPort
//
//  Created by RAVIKUMAR on 29/09/15.
//  Copyright (c) 2015 RAVIKUMAR. All rights reserved.
//
import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var centerContainer :MMDrawerController?
    func SetupInitializerCompleted() -> Bool
    {
        
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject(false, forKey: "isInitialSetupCompleted")
//        defaults.synchronize()
        
        var isInitialSetupCompleted : Bool = false
        if let completed: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("isInitialSetupCompleted")
        {
             isInitialSetupCompleted = (completed as? Bool)!
        }
        
               return isInitialSetupCompleted
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if !SetupInitializerCompleted()
        {
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
            var appRootPath:String = paths.firstObject as! String
            var appDataPath : String = "\(appRootPath)/\(BaseData.rootPath)"
            var fHandler = FileHandler()
            fHandler.createFolder("", parentPath: appDataPath)
            println(appDataPath)
        }
        
        return true
    }
    
    func languageWillChange(notification:NSNotification){
        let targetLang = notification.object as! String
        NSUserDefaults.standardUserDefaults().setObject(targetLang, forKey: "selectedLanguage")
        NSBundle.setLanguage(targetLang)
        NSNotificationCenter.defaultCenter().postNotificationName("LANGUAGE_DID_CHANGE", object: targetLang)
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
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        InitializeApp()
        
    }
    
    func InitializeApp()
    {
        var isInitialSetupCompleted : Bool?
        isInitialSetupCompleted = SetupInitializerCompleted()
        if isInitialSetupCompleted == false
        {
            var rootViewController = self.window?.rootViewController
            var mainStoryBoard : UIStoryboard = UIStoryboard(name: "Setup", bundle: nil)
            var centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupViewController") as! SetupViewController
            var setupLeftViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupLeftViewController") as! SetupLeftViewController
             var setupRightViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("SetupLeftViewController") as! SetupLeftViewController
            
            var setupLeftSideNav = UINavigationController(rootViewController: setupLeftViewController)
            var centerNav = UINavigationController(rootViewController: centerViewController)
            var setupRightSideNav = UINavigationController(rootViewController: setupRightViewController)
            
            
            centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: setupLeftSideNav, rightDrawerViewController: nil)
            
            centerContainer?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
            centerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
            
            window?.rootViewController = centerContainer
            window?.makeKeyAndVisible()
            
        }
        else
        {
            var rootViewController = self.window?.rootViewController
            var mainStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var centerViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            var leftSideViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("LeftSideAccordianViewController") as! LeftSideAccordianViewController
            var rightSideViewViewController = mainStoryBoard.instantiateViewControllerWithIdentifier("RightSideViewController") as! RightSideViewController
            
            
            var leftSideNav = UINavigationController(rootViewController: leftSideViewController)
            var centerNav = UINavigationController(rootViewController: centerViewController)
            var rightSideNav = UINavigationController(rootViewController: rightSideViewViewController)
            
            centerContainer = MMDrawerController(centerViewController: centerNav, leftDrawerViewController: leftSideNav, rightDrawerViewController: rightSideNav)
            
            
            
            centerContainer?.openDrawerGestureModeMask = MMOpenDrawerGestureMode.PanningCenterView
            centerContainer?.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.PanningCenterView
            
            window?.rootViewController = centerContainer
            window?.makeKeyAndVisible()
            
            //Application Initializations
            
            
            var initializer = AppInitializer()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "languageWillChange:", name: "LANGUAGE_WILL_CHANGE", object: nil)
            let targetLang = NSUserDefaults.standardUserDefaults().objectForKey("selectedLanguage") as? String
            NSBundle.setLanguage((targetLang != nil) ? targetLang : "en")
            
        }

    }
        
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "ravi.DocPort" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
        }()
}