//
//  AppDelegate.swift
//  TTTLive
//
//  Created by yanzhen on 2018/8/16.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
//3T_Native_SDK-Demo_V2.0.0_VLive
//3T_Native_SDK-Demo_V2.0.0_ACall
//3T_Native_SDK-Demo_V2.0.0_VCall
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.isIdleTimerDisabled = true
        WXApi.registerApp("wxa1fc044ad9fd22a3")
        return true
    }

}

