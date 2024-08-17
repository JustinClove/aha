//
//  AppDelegate.swift
//  MarsVPN
//
//  Created by Justin on 2022/11/22.
//

import UIKit
//import FirebaseCore
//import FirebaseFirestore
import Flurry_iOS_SDK
import GoogleMobileAds

#if DEBUG
let FlurrySeesion = "54JYT6SR7H4KCYP7G6B9"
let GMAppId = "ca-app-pub-2381946195085622~6540286485"
//let GMAdsInterstitial0 = "ca-app-pub-2381946195085622/8240380965"
//let GMAdsInterstitial1 = "ca-app-pub-2381946195085622/8114326256"
//let GMAdsInterstitial2 = "ca-app-pub-2381946195085622/2889919737"
let GMAdsInterstitial0 = "ca-app-pub-3940256099942544/4411468910"
let GMAdsInterstitial1 = "ca-app-pub-3940256099942544/4411468910"
let GMAdsInterstitial2 = "ca-app-pub-3940256099942544/4411468910"
//let GMAdsIdLauched = "ca-app-pub-2381946195085622/8240380965"
//let GMAdsRawardId = "ca-app-pub-2381946195085622/3726671255"
//let GMAdsBannerId = "ca-app-pub-2381946195085622/6258246076"


//let GMAdsId = "ca-app-pub-3940256099942544/4411468910"
//let GMAdsIdLauched = "ca-app-pub-3940256099942544/5662855259"
//let GMAdsRawardId = "ca-app-pub-3940256099942544/1712485313"
//let GMAdsBannerId = "ca-app-pub-2381946195085622/2745594286"
#else
let FlurrySeesion = "54JYT6SR7H4KCYP7G6B9"
let GMAppId = "ca-app-pub-2381946195085622~6540286485"
let GMAdsInterstitial0 = "ca-app-pub-2381946195085622/8240380965"
let GMAdsInterstitial1 = "ca-app-pub-2381946195085622/8114326256"
let GMAdsInterstitial2 = "ca-app-pub-2381946195085622/2889919737"
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        MVVPNTool.shared
        MVAppearance.appearanceConfig()
        MVIAPManager.setupIAP()
        
        // vip will cache node
        if MVConfigModel.isVIP() {
            MVDataManager.fetchLocationListWhenAppLauching()
        } else {
            MVDataManager.fetchLocationList { _, _ in }
        }
        
        // App config will set free days vip
        MVDataManager.fetchAppConfig()
        
        MVIAPManager.checkPurchaseIfCanMakePayments()

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        let viewController = MVRootViewController()
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        window.overrideUserInterfaceStyle = .light
        
        let builder = FlurrySessionBuilder.init()
        builder.build(crashReportingEnabled: true)
        builder.build(logLevel: .none)
        builder.build(appVersion: AppInfo.version)
        Flurry.set(userId: AppInfo.shortDeviceId)
        Flurry.set(appVersion: AppInfo.version)
        builder.build(sessionProperties: ["UserID" : AppInfo.shortDeviceId])
        if MVConfigModel.ensuredVIP() {
            builder.build(sessionProperties: ["VIPUID" : AppInfo.shortDeviceId])
            GGAnalyticsManager.logEvent("ensuredVIP", event1: "shortDeviceId", value: AppInfo.shortDeviceId)
        }
        Flurry.startSession(apiKey: FlurrySeesion, sessionBuilder: builder)
                
        return true
    }
    
    var bid:UIBackgroundTaskIdentifier?
    func applicationDidEnterBackground(_ application: UIApplication) {
       
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        let bgTaskID = UIBackgroundTaskIdentifier(rawValue: 0)
        bid = application.beginBackgroundTask {
            if let bgTaskID = self.bid {
                application.endBackgroundTask(bgTaskID)
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let bgTaskID = self.bid {
            application.endBackgroundTask(bgTaskID)
        }

//        HVSingleManager.shared.fetchLocations(){_ in }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let vc = self.window?.rootViewController as? MVRootViewController {
                vc.showAdsWhenDidBecomeActive()
            }
        }
    }

}

extension UIApplication {
    var firstWindowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })
    }
}
