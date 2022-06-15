//
//  AppDelegate.swift
//  Todo
//
//  Created by josh.fn7 on 2022/06/14.
//

import UIKit
import Common

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let appModule = AppModule.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = variable(appModule.window) {
            $0?.makeKeyAndVisible()
        }
        appModule.loadInitial()
        return true
    }
    
}
