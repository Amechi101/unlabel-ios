//
//  AppDelegate.swift
//  Unlabel
//
//  Created by Amechi Egbe on 12/11/15.
//  Copyright © 2015 Unlabel. All rights reserved.
//

import UIKit
import Bolts
import Fabric
import CoreData
import Crashlytics
import FBSDKCoreKit
import FBSDKLoginKit

protocol AppDelegateDelegates {
    func reachabilityChanged(reachable:Bool)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var reachability:Reachability!;
    var delegate:AppDelegateDelegates?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        setupOnLaunch()
        
        return FBSDKApplicationDelegate.sharedInstance()
            .application(application, didFinishLaunchingWithOptions: launchOptions)
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
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.unlabel-app.Unlabel" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Unlabel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}

//
//MARK:- Custom Methods
//
extension AppDelegate{
    /**
     Init everything needed on app launch.
     */
    private func setupOnLaunch(){
        configure()
        configureGoogleAnalytics()
        setupRootVC()
    }
    
    func configureGoogleAnalytics(){
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
//        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
    }
  
    
    /**
     Configure required things.
     */
    private func configure(){
        Fabric.with([Crashlytics.self])
        addInternetStateChangeObserver()
    }
    
    /**
     Observe internet state change.
     */
    func addInternetStateChangeObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(AppDelegate.checkForReachability(_:)), name: kReachabilityChangedNotification, object: nil);
        
        self.reachability = Reachability.reachabilityForInternetConnection()
        self.reachability.startNotifier();
    }
    
    /**
     Check for reachability whenever internet state changes.
     */
    func checkForReachability(notification:NSNotification)
    {
        if let networkReachability = notification.object as? Reachability{
            let remoteHostStatus = networkReachability.currentReachabilityStatus()
            
            if (remoteHostStatus == NotReachable)
            {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.reachabilityChanged(false)
                })
                print("Unreachable")
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.reachabilityChanged(true)
                })
                print("Reachable")
            }
        }
    }
    
    /**
     Init UI on app launch.
     */
    private func setupRootVC(){
        if let storyboard:UIStoryboard = UIStoryboard(name: S_NAME_UNLABEL, bundle: nil){
            if let _ = UnlabelHelper.getDefaultValue(PRM_USER_ID){
                goToFeedVC(storyboard)
            }else{
                goToEntryVC(storyboard)
            }
        }
        setupUnlabelApp()
    }
    
    private func goToFeedVC(storyboard:UIStoryboard){
        let rootNavVC:UINavigationController? = storyboard.instantiateViewControllerWithIdentifier(S_ID_NAV_CONTROLLER) as? UINavigationController
        if let window = self.window {
            window.rootViewController = rootNavVC
        }
    }
    
    private func goToEntryVC(storyboard:UIStoryboard){
        let rootVC:EntryVC? = storyboard.instantiateViewControllerWithIdentifier(S_ID_ENTRY_VC) as? EntryVC
        if let window = self.window {
            window.rootViewController = rootVC
        }
    }
    
    /**
     Setup Unlable App.
     */
    private func setupUnlabelApp(){
        UINavigationBar.appearance().setBackgroundImage(
            UIImage(),
            forBarPosition: .Any,
            barMetrics: .Default)
        
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
    /**
     Setup Unlable Admin App.
     */
    private func setupUnlabelAdmin(){
        
    }
}

