//
//  AppDelegate.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/19.
//

import UIKit
import UserNotifications
import RealmSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    var window: UIWindow?
//    let test = BViewController()
//    test.Send_uuid = self
    
//    var registerB: String = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            
            if granted {
                print("Allowed")
            } else {
                print("Not Allowed")
            }
        }
        
        return true
    }

    
    // 接收前景模式下的通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 顯示通知，這樣應用程式在前景模式下也可以收到通知
        completionHandler([.alert, .sound, .badge])
    }

    // 接收使用者對通知的回應，例如點擊通知的動作
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 在這裡可以處理使用者對通知的回應

//        let identifier = response.notification.request.identifier
//        if identifier == registerB {
//            let realm = try! Realm()
//            let clock = realm.objects(Clock.self).filter("uuid == %@", identifier).first
//            try! realm.write{
//                clock!["uuid"] = false
//            }
//        }
            
        completionHandler()
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//extension AppDelegate: Send_uuid {
//    func senduuid(uuid: String) {
//        registerB = uuid
//    }
//}
