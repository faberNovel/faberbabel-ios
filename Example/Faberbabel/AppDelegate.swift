//
//  AppDelegate.swift
//  Faberbabel
//
//  Created by Jean Haberer on 06/24/2020.
//  Copyright (c) 2020 Jean Haberer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Replace by your project id and url
        guard let url = URL(string: "base_url") else { return false }
        Bundle.fb_setup(
            projectId: "project_id",
            baseURL: url
        )
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

}
