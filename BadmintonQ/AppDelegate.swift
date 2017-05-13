//
//  AppDelegate.swift
//  BadmintonQ
//
//  Created by Deenadayal Loganathan on 4/16/15.
//  Copyright (c) 2015 Deena. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
//import FBSDKLoginKit
import FBSDKLoginKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        // Override point for customization after application launch.
       IQKeyboardManager.sharedManager().enable = true
       
        
        switch(getMajorSystemVersion()) {
       /* case 7.0:
            UIApplication.sharedApplication().registerForRemoteNotifications()
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(
                [.Alert, .Badge , .Sound])*/
        case "8.0":
            let pushSettings: UIUserNotificationSettings = UIUserNotificationSettings(
                types:
               [.alert, .badge, .sound],
                categories: nil)
            UIApplication.shared.registerUserNotificationSettings(pushSettings)
            UIApplication.shared.registerForRemoteNotifications()
            
        case "9.2":
            
            let settings = UIUserNotificationSettings(types: [.alert, .badge ,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
            
        default:
            let settings = UIUserNotificationSettings(types: [.alert, .badge ,.sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
 
            return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            
        }
        
     /*   var nav = UINavigationController()
        var mainWiew = ViewController(nibName: nil, bundle: nil)
        nav.viewControllers = [mainWiew]
        nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        UINavigationBar.appearance().barTintColor = UIColor.blueColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        //White status font
        UINavigationBar.appearance().barStyle = UIBarStyle.BlackTranslucent
        
        self.window!.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        //Black status background
        var statusBar = UIView()
        statusBar.frame = CGRectMake(0, 0, 320, 20)
        statusBar.backgroundColor = UIColor.blackColor()
        self.window?.rootViewController?.view.addSubview(statusBar)*/
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
       // return true
       return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
    }
    
    func application(_ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
            /*return FBSDKApplicationDelegate.sharedInstance().application(
                application,
                open: url,
                sourceApplication: sourceApplication,
                annotation: annotation)*/
    }
    
  /* public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation]
        )
    }*/

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let trimEnds = deviceToken.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        let cleanToken = trimEnds.replacingOccurrences(of: " ", with: "")
        
        
        //trimEnds.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil)
      //  trimEnds.stringByReplacingOccurrencesOfString(" ", withString: "", options: <#T##NSStringCompareOptions#>, range: <#T##Range<Index>?#>)
        
        //registerTokenOnServer(cleanToken) //theoretical method! Needs your own implementation
    }
    // Failed to register for Push
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        //NSLog("Failed to get token; error: %@", error) //Log an error for debugging purposes, user doesn't need to know
    }
    
    func getMajorSystemVersion() -> String {
        print(UIDevice.current.systemVersion)
        return String(validatingUTF8: UIDevice.current.systemVersion)!
    }
    
    // foreground (or if the app was in the background and the user clicks on the notification).
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // display the userInfo
        if let notification = userInfo["aps"] as? NSDictionary,
            let alert = notification["alert"] as? String {
                let alertCtrl = UIAlertController(title: "Time Entry", message: alert as String, preferredStyle: UIAlertControllerStyle.alert)
                alertCtrl.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                // Find the presented VC...
                var presentedVC = self.window?.rootViewController
                while (presentedVC!.presentedViewController != nil)  {
                    presentedVC = presentedVC!.presentedViewController
                }
                presentedVC!.present(alertCtrl, animated: true, completion: nil)
                
                // call the completion handler
                // -- pass in NoData, since no new data was fetched from the server.
                completionHandler(UIBackgroundFetchResult.noData)
        }
    }
    


   /* func initializeNotificationServices() -> Void {
        let settings = UIUserNotificationSettings(forTypes: .Sound | .Alert | .Badge, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        // This is an asynchronous method to retrieve a Device Token
        // Callbacks are in AppDelegate.swift
        // Success = didRegisterForRemoteNotificationsWithDeviceToken
        // Fail = didFailToRegisterForRemoteNotificationsWithError
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let deviceTokenStr = convertDeviceTokenToString(deviceToken)
        // ...register device token with our Time Entry API server via REST
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Device token for push notifications: FAIL -- ")
        print(error.description)
    }
    private func convertDeviceTokenToString(deviceToken:NSData) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "", options: nil, range: nil)
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "", options: nil, range: nil)
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "", options: nil, range: nil)
        
        // Our API returns token in all uppercase, regardless how it was originally sent.
        // To make the two consistent, I am uppercasing the token string here.
        deviceTokenStr = deviceTokenStr.uppercaseString
        return deviceTokenStr
    }*/
    
    
 
    
    



}

