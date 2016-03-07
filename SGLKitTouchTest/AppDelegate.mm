//
//  AppDelegate.m
//  SGLKitTouchTest
//
//  Created by Colin Caufield on 2014-05-02.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <SGLKit/SGLProgram.h>

@implementation AppDelegate

- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    // If using a device (as opposed to the simulator), register a shader reloading URL.
    // This is only required if you'd like to live-reload shaders during development.
    // For this to work, you have to enable a webserver and make SGLKit (and other projects) visible.
    // See 
    
    //#ifdef SGL_IOS_SIMULATOR
        NSString* sglHttpSourcePath = @"http://localhost/SGLKit/Shaders";
        [SGLProgram registerSourcePath:sglHttpSourcePath];
    //#endif
    
    return YES;
}

- (void) applicationWillResignActive:(UIApplication*)application
{
    
}

- (void) applicationDidEnterBackground:(UIApplication*)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    
}

@end
