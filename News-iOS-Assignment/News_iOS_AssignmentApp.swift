//
//  News_iOS_AssignmentApp.swift
//  News-iOS-Assignment
//
//  Created by Jay Firke on 31/08/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct News_iOS_AssignmentApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            if getUserSignedInStatus() {
                ContentView()
            }else{
                PhoneAuthView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        
        completionHandler(.newData)
    }
}
