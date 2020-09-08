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
                     // swiftlint:disable:next discouraged_optional_collection
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Replace by your project id and url
        guard let url = URL(string: "base_url") else { return false }
        Bundle.fb_setup(
            projectId: "project_id",
            baseURL: url
        )
        Bundle.fb_addAppGroupIdentifier("group.faberbabel.com")
        return true
    }
}
