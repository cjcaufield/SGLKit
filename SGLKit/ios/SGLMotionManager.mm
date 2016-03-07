//
//  SGLMotionManager.mm
//  SGLKit
//
//  Created by Colin Caufield on 2014-05-21.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLMotionManager.h"
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#define ALLOW_MOTION
#define USE_MOTION_SPRINGS

NSString* const SGLOrientationChangedNotification = @"SGLOrientationChangedNotification";
NSString* const SGLAccelerationChangedNotification = @"SGLAccelerationChangedNotification";

static SGLMotionManager* shared = nil;

@interface SGLMotionManager ()

@property (nonatomic, strong) CMMotionManager* motionManager;
@property (nonatomic) double lastRoll;
@property (nonatomic) double lastPitch;
@property (nonatomic) double lastYaw;
@property (nonatomic) vec3 lastAcceleration;

@end

@implementation SGLMotionManager

+ (SGLMotionManager*) shared
{
    if (shared == nil)
        shared = [[SGLMotionManager alloc] init];
    
    return shared;
}

- (id) init
{
    self = [super init];
    
    SGL_ASSERT(shared == nil);
    shared = self;
    
    _motionManager = [[CMMotionManager alloc] init];
    
    _orientationMatrix.reset();
    _inverseOrientationMatrix.reset();
    
    return self;
}

- (void) startMotionDetection
{
    #ifndef ALLOW_MOTION
        return;
    #endif
    
    if (_active)
        return;
    
    _active = YES;
    
    SGL_METHOD_LOG;
    
    //__block float stepMoveFactor = 15;
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    CMMotionManager* motionManager = self.motionManager;
    
    motionManager.deviceMotionUpdateInterval = 0.05;
    
    __block BOOL firstUpdate = YES;
    
    [motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion* motion, NSError* error)
    {
        dispatch_async(dispatch_get_main_queue(), ^()
        {
            CMAttitude* attitude = motion.attitude;
            
            double rollDiff  = fabs(attitude.roll  - _lastRoll);
            double pitchDiff = fabs(attitude.pitch - _lastPitch);
            double yawDiff   = fabs(attitude.yaw   - _lastYaw);
            
            static const double minChange = 0.005;
            
            float radians = 0;
            
            switch (UIApplication.sharedApplication.statusBarOrientation)
            {
                case UIInterfaceOrientationPortrait:
                    radians = 0;
                    break;
                    
                case UIInterfaceOrientationPortraitUpsideDown:
                    radians = M_PI;
                    break;
                    
                case UIInterfaceOrientationLandscapeLeft:
                    radians = +M_PI_2;
                    break;
                    
                case UIInterfaceOrientationLandscapeRight:
                    radians = -M_PI_2;
                    break;
            }
            
            mat3 viewMatrix = mat3::rotationZ(radians);
            viewMatrix = viewMatrix.transpose();
            
            /*
            id topController = [(id)self.window.rootViewController topViewController];
            
            MonitorRenderer* monitorRenderer = nil;
            if ([topController isKindOfClass:[CRTViewController class]])
                monitorRenderer = [topController monitorRenderer];
            */
            
            NSNotificationCenter* noteCenter = [NSNotificationCenter defaultCenter];
            
            if (firstUpdate || rollDiff > minChange || pitchDiff > minChange || yawDiff > minChange)
            {
                CMRotationMatrix systemDeviceMatrix = attitude.rotationMatrix;
                
                mat3 deviceMatrix;
                deviceMatrix.reset();
                
                deviceMatrix.at(0, 0) = systemDeviceMatrix.m11;
                deviceMatrix.at(0, 1) = systemDeviceMatrix.m12;
                deviceMatrix.at(0, 2) = systemDeviceMatrix.m13;
                deviceMatrix.at(1, 0) = systemDeviceMatrix.m21;
                deviceMatrix.at(1, 1) = systemDeviceMatrix.m22;
                deviceMatrix.at(1, 2) = systemDeviceMatrix.m23;
                deviceMatrix.at(2, 0) = systemDeviceMatrix.m31;
                deviceMatrix.at(2, 1) = systemDeviceMatrix.m32;
                deviceMatrix.at(2, 2) = systemDeviceMatrix.m33;
                
                _orientationMatrix = deviceMatrix * viewMatrix;
                
                _orientationMatrix = mat3::rotationX(HALF_PI) * _orientationMatrix;
                
                // Calculate the inverse of the orientation matrix.
                // Since the matrix is orthonormal, transpose is a cheaper alternative to inverse.
                _inverseOrientationMatrix = _orientationMatrix.transpose();
                
                //mat3& mat = _inverseOrientationMatrix;
                //SGL_LOG(@"global inverse orientation matrix changed:");
                //SGL_LOG(@"%.2f, %.2f, %.2f", mat.at(0, 0), mat.at(0, 1), mat.at(0, 2));
                //SGL_LOG(@"%.2f, %.2f, %.2f", mat.at(1, 0), mat.at(1, 1), mat.at(1, 2));
                //SGL_LOG(@"%.2f, %.2f, %.2f", mat.at(2, 0), mat.at(2, 1), mat.at(2, 2));
                
                //_lightPosition = _inverseOrientationMatrix * ABOVE_LIGHT_POS;
                
                //SGL_LOG(@"*** Motion Event");
                
                //monitorRenderer.inverseOrientationMatrix = _inverseOrientationMatrix;
                //monitorRenderer.lightPosition = _inverseOrientationMatrix * ABOVE_LIGHT_POS;
                
                [noteCenter postNotificationName:SGLOrientationChangedNotification object:nil userInfo:nil];
                
                _lastRoll  = attitude.roll;
                _lastPitch = attitude.pitch;
                _lastYaw   = attitude.yaw;
            }
            
            #ifdef USE_MOTION_SPRINGS
            
                CMAcceleration userAcceleration = motion.userAcceleration;
                
                vec3 acceleration = vec3(userAcceleration.x, userAcceleration.y, 0.0);
                
                //vec3 accelerationDiff = acceleration - _lastAcceleration;
                vec3 accelerationAvg = 0.5 * (acceleration + _lastAcceleration);
                
                static const float deviceConstant =
                    (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 3.5 : 5.0;
                
                vec2 forceVec2D = deviceConstant * vec2(viewMatrix * accelerationAvg);
                
                float delta = motionManager.deviceMotionUpdateInterval;
                
                vec2 distanceChange = forceVec2D * delta * delta;
                
                //monitorRenderer.springOffset += distanceChange;
                
                _lastAcceleration = acceleration;
            
                [noteCenter postNotificationName:SGLAccelerationChangedNotification object:nil userInfo:nil];
                
            #endif
            
            //NSLog(@"Roll: %.6f, Pitch: %.6f, Yaw: %.6f", attitude.roll, attitude.pitch, attitude.yaw);
            //NSLog(@"Gravity: %.3f, %.3f, %.3f", gravity.x, gravity.y, gravity.z);
            //NSLog(@"User Acceleration: %+.1f, %+.1f, %+.1f", userAcceleration.x, userAcceleration.y, userAcceleration.z);
            
            firstUpdate = NO;
        });
    }];
}

- (void) stopMotionDetection
{
    #ifndef ALLOW_MOTION
        return;
    #endif
        
    SGL_METHOD_LOG;
    
    [_motionManager stopDeviceMotionUpdates];
    
    _active = NO;
}

- (void) stopMotionDetectionAndResetOrientation
{
    [self stopMotionDetection];
    
    _orientationMatrix.reset();
    _inverseOrientationMatrix.reset();
    
    //_lightPosition = ABOVE_BACK_LIGHT_POS;
}

@end
