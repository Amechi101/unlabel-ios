//
//  AppDelegate.swift
//  Unlabel
//
//  Created by Amechi Egbe on 12/11/15.
//  Copyright © 2015 Unlabel. All rights reserved.
//

import UIKit
import Fabric
import CoreData
import Crashlytics
import UserNotifications
import SwiftyJSON

@objc protocol AppDelegateDelegates {
  func reachabilityChanged(_ reachable:Bool)
  @objc optional func didLaunchWithBrandId(_ brandId:String)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
  
  var window: UIWindow?
  var delegate:AppDelegateDelegates?
  fileprivate var reachability:Reachability!;
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let cstorage = HTTPCookieStorage.shared
    print("cs cookie  \(cstorage)")
    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    // UIApplication.shared.statusBarFrame
    self.window?.backgroundColor = .white
    setupOnLaunch(launchOptions)
    UnlabelHelper.setDefaultValue("", key: "device_token")
    registerForRemoteNotification()
    var udid = UIDevice.current.identifierForVendor!.uuidString
    udid = udid.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
    print("UDID == \(udid)")
    let storyboard:UIStoryboard = UIStoryboard(name: S_NAME_UNLABEL, bundle: nil)
    let rootTabVC = storyboard.instantiateViewController(withIdentifier: S_ID_TAB_CONTROLLER) as? UITabBarController
    rootTabVC?.selectedIndex = 2
//    let storyboard = UIStoryboard(name: "Unlabel", bundle: nil)
//    

    
    return true
  }
  
  func registerForRemoteNotification() {
    if #available(iOS 10.0, *) {
      let center  = UNUserNotificationCenter.current()
      center.delegate = self
      center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
        if error == nil{
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    else {
      UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    
    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    debugPrint("********\(deviceTokenString)")
    
    UnlabelHelper.setDefaultValue(deviceTokenString, key: "device_token")
    
  }
  func clearCookie(){
    let cstorage = HTTPCookieStorage.shared
    
    UserDefaults.standard.removeObject(forKey: "ULCookie")
    UserDefaults.standard.synchronize()
    print("cs cookie  \(cstorage)")
    if let cookies = cstorage.cookies {
      for cookie in cookies {
        cstorage.deleteCookie(cookie)
      }
    }
    
  }
  func applicationWillResignActive(_ application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    self.saveContext()
  }
  
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
     debugPrint("---555--- \(userInfo)")
    
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    debugPrint("------ \(userInfo)")
     debugPrint("****** \(userInfo["aps"])")
  }
  
  
  // MARK: - Core Data stack
  
  lazy var applicationDocumentsDirectory: URL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
  }()
  
  lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(forResource: "Unlabel", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
    var failureReason = "There was an error creating or loading the application's saved data."
    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
    } catch {
      // Report any error we got.
      var dict = [String: AnyObject]()
      dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
      dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
      
      dict[NSUnderlyingErrorKey] = error as NSError
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    let coordinator = self.persistentStoreCoordinator
    var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    managedObjectContext.persistentStoreCoordinator = coordinator
    return managedObjectContext
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
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
  fileprivate func setupOnLaunch(_ launchOptions: [AnyHashable: Any]?){
    configure(launchOptions)
    setupRootVC()
  }
  
  /**
   Configure required things.
   */
  fileprivate func configure(_ launchOptions: [AnyHashable: Any]?){
    Fabric.with([Crashlytics.self])
    configureGoogleAnalytics()
    addInternetStateChangeObserver()
  }
  
  
  /**
   Configuring GA.
   */
  fileprivate func configureGoogleAnalytics(){
    // Configure tracker from GoogleService-Info.plist.
    var configureError:NSError?
    GGLContext.sharedInstance().configureWithError(&configureError)
    assert(configureError == nil, "Error configuring Google services: \(configureError)")
    
    // Optional: configure GAI options.
    let gai = GAI.sharedInstance()
    gai?.trackUncaughtExceptions = true  // report uncaught exceptions
    //        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
  }
  
  /**
   Observe internet state change.
   */
  fileprivate func addInternetStateChangeObserver(){
    NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.checkForReachability(_:)), name: NSNotification.Name.reachabilityChanged, object: nil);
    
    self.reachability = Reachability.forInternetConnection()
    self.reachability.startNotifier();
  }
  
  /**
   Init UI on app launch.
   */
  func getInfluencerDetails(){
    
    UnlabelAPIHelper.sharedInstance.getProfileDetails( { (
      meta: JSON) in
      print(meta)
      UnlabelHelper.setDefaultValue(meta["email"].stringValue, key: "influencer_email")
      UnlabelHelper.setDefaultValue(meta["last_name"].stringValue, key: "influencer_last_name")
      UnlabelHelper.setDefaultValue(meta["auto_id"].stringValue, key: "influencer_auto_id")
      UnlabelHelper.setDefaultValue(meta["image"].stringValue, key: "influencer_image")
      UnlabelHelper.setDefaultValue(meta["first_name"].stringValue, key: "influencer_first_name")
    }, failed: { (error) in
    })
  }
  
  func getStaticURLs(){
    
    UnlabelAPIHelper.sharedInstance.getStaticURLs( { (
      meta: JSON) in
      print(meta)
      UnlabelHelper.setDefaultValue(meta["operations_agreement_url"].stringValue, key: "operations_agreement_url")
      UnlabelHelper.setDefaultValue(meta["privacy_policy_url"].stringValue, key: "privacy_policy_url")
      UnlabelHelper.setDefaultValue(meta["terms_conditions_url"].stringValue, key: "terms_conditions_url")
    }, failed: { (error) in
    })
  }
  
  fileprivate func setupRootVC(){
    
    if UnlabelHelper.isUserLoggedIn(){
      
      HTTPCookieStorage.shared.setCookie(getCookie())
      
      getInfluencerDetails()
      
      let storyboard:UIStoryboard = UIStoryboard(name: S_NAME_UNLABEL, bundle: nil)
      let rootTabVC = storyboard.instantiateViewController(withIdentifier: S_ID_TAB_CONTROLLER) as? UITabBarController
      if let window = self.window {
        window.rootViewController = rootTabVC
        self.window?.makeKeyAndVisible()
      }
      
    }else{
      getStaticURLs()
    }
    
    setupUnlabelApp()
  }
  
  func getCookie () -> HTTPCookie
  {
    let cookie = HTTPCookie(properties: UserDefaults.standard.object(forKey: "ULCookie") as!  [HTTPCookiePropertyKey : Any])
    return cookie!
  }
  
  fileprivate func goToFeedVC(_ storyboard:UIStoryboard){
    
    let rootTabVC = storyboard.instantiateViewController(withIdentifier: S_ID_TAB_CONTROLLER) as? UITabBarController
    if let window = self.window {
      window.rootViewController = rootTabVC
    }
    
    
    
  }
  
  
  /**
   Setup Unlable App.
   */
  fileprivate func setupUnlabelApp(){
    UINavigationBar.appearance().setBackgroundImage(
      UIImage(),
      for: .any,
      barMetrics: .default)
    
    UINavigationBar.appearance().shadowImage = UIImage()
  }
  
  
  /**
   Check for reachability whenever internet state changes.
   */
  func checkForReachability(_ notification:Notification)
  {
    if let networkReachability = notification.object as? Reachability{
      let remoteHostStatus = networkReachability.currentReachabilityStatus()
      
      if (remoteHostStatus == NotReachable)
      {
        DispatchQueue.main.async(execute: {
          self.delegate?.reachabilityChanged(false)
        })
        debugPrint("Unreachable")
      }
      else
      {
        DispatchQueue.main.async(execute: {
          self.delegate?.reachabilityChanged(true)
        })
        debugPrint("Reachable")
      }
    }
  }
}

