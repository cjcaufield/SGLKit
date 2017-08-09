//
//  AppDelegate.swift
//  SGLKitTouchTestSwift
//
//  Created by Colin Caufield on 2016-02-03.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import UIKit
import SGLKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if SGL_IOS_DEVICE {
            SGLProgram.registerSourcePath("http://localhost/SGLKit/Shaders")
        }
        
        return true
    }
}

