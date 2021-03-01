//
//  AppDelegate.swift
//  Doko
//
//  Created by 相沢伸一 on 2021/02/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        dataManager = DataManager()
        soundManager = SoundManager();
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = DokoViewController(nibName: "DokoViewController", bundle: nil)
        window.makeKeyAndVisible()

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        dataManager.saveData()
    }
}

