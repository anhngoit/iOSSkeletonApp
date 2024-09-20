//
//  AppDelegate.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 5/9/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()

        return true
    }
}

