//
//  AppDelegate.swift
//  everydayPay_Admin
//
//  Created by 이남기 on 2023/01/15.
//

import UIKit
import SocketIO
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarTintColor = #colorLiteral(red: 0.9978129268, green: 0.5933750272, blue: 0.0001036255053, alpha: 1)
        return true
    }
  func applicationDidBecomeActive(_ application: UIApplication) {
      if !SocketIOManager.sharedInstance.isConnected{
          SocketIOManager.sharedInstance.connection()
      }
  }
  func applicationDidEnterBackground(_ application: UIApplication) {
      if SocketIOManager.sharedInstance.isConnected{
          SocketIOManager.sharedInstance.disConnection()
      }
  }

}

