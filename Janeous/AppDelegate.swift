
//
//  AppDelegate.swift
//  Janeous
//
//  Created by SL-167 on 2/5/18.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainContainer =  MFSideMenuContainerViewController()
    var generalFunction = GeneralFunction()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       self.copyDatabase()
       self.generalFunction.openDB()
       self.setLandingScreen()
       self.getGeneralData()
        
        if(UserDefaults.standard.value(forKey: "device_token") == nil)
        {
           UserDefaults.standard.set("123456", forKey: "device_token")
        }
        
        return true
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
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
    
        if LISDKCallbackHandler.shouldHandle(url) {
            return LISDKCallbackHandler.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return true
    }
    
    //MARK:- Logout
    func logout()
    {
        UserDefaults.standard.removeObject(forKey: "userData")
        self.setLandingScreen()
    }
    
    func setLandingScreen()
    {
        initialiseUserData()
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nav1: UINavigationController = storyBoard.instantiateViewController(withIdentifier: "initialNavView") as! UINavigationController
        let nav :UINavigationController =  storyBoard.instantiateViewController(withIdentifier: "secondNavView") as! UINavigationController
        
        
        if userData.userID != "" && userData.type == "candidate"
        {
            
            let controller = CandidateProfileController()
            nav.viewControllers = [controller]
            let leftVC = storyBoard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            mainContainer = MFSideMenuContainerViewController.container(withCenter: nav, leftMenuViewController: leftVC, rightMenuViewController: nil)
            
            nav1.viewControllers = [mainContainer]
            
        }
        else
        {
            
            let controller = storyBoard.instantiateViewController(withIdentifier: "LandingViewController") as! LandingViewController
            nav.viewControllers = [controller]
            let leftVC = storyBoard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
            mainContainer = MFSideMenuContainerViewController.container(withCenter: nav, leftMenuViewController: leftVC, rightMenuViewController: nil)
            
            nav1.viewControllers = [mainContainer]
            
        }
        self.window?.rootViewController = nav1
        self.window?.makeKeyAndVisible()
    }

    //MARK:- For Linkedin Sign in
    func linkedInSignin()
    {
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION,LISDK_EMAILADDRESS_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
            print("success called!")
            let session = LISDKSessionManager.sharedInstance().session
            
            let url = NSString(string:"https://api.linkedin.com/v1/people/~:(id,industry,firstName,lastName,emailAddress,headline,summary,publicProfileUrl,specialties,positions:(id,title,summary,start-date,end-date,is-current,company:(id,name,type,size,industry,ticker)),pictureUrls::(original),location:(name))?format=json")
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().getRequest(url as String!, success: { (response) -> Void in
                    
                    let datastring = response?.data!
                    
                    let result = self.convertToDictionary(text: datastring! as String)
                    
                    let dataDict = NSMutableDictionary()
                    
                    dataDict.setObject((result! as NSDictionary)["firstName"] != nil ? (result! as NSDictionary)["firstName"] as! String : "", forKey: "first_name" as NSCopying)
                    dataDict.setObject((result! as NSDictionary)["lastName"] != nil ? (result! as NSDictionary)["lastName"] as! String : "", forKey: "last_name" as NSCopying)
                    dataDict.setObject((result! as NSDictionary)["emailAddress"] != nil ? (result as! NSDictionary)["emailAddress"] as! String : "", forKey: "email" as NSCopying)
                    dataDict.setObject((result! as NSDictionary)["id"] != nil ? "\((result as! NSDictionary)["id"]!)" : "", forKey: "linkedin" as NSCopying)
                  
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "linkedInInfo"), object: dataDict)
//                    self.talentSocialSignup(dataDict: dataDict)
                    
                }, error: { (error) -> Void in
                    print(error)
                })
            }
            
        }) { (error) -> Void in
            print("Error: \(error)")
        }
    }

    //MARK:- Convert json to dictionary
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    
}

