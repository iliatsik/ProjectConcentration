//
//  AppDelegate.swift
//  ProjectConcentration
//
//  Created by Ilia Tsikelashvili on 05.01.22.
//

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {
    var window : UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
                     launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        if #available(iOS 13, *) {
        } else {
            self.window = UIWindow()
            let vc = ViewController()
            self.window!.rootViewController = vc
            self.window!.makeKeyAndVisible()
            self.window!.backgroundColor = .red
        }
        return true
    }
}


