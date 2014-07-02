//
//  SGLMotionManager.h
//  SGLKitTouch
//
//  Created by Colin Caufield on 2014-05-21.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLMath.h"

@class CMMotionManager;

extern NSString* const SGLOrientationChangedNotification;
extern NSString* const SGLAccelerationChangedNotification;

@interface SGLMotionManager : NSObject

+ (SGLMotionManager*) shared;

@property (readonly) BOOL active;
@property (nonatomic) mat3 orientationMatrix;
@property (nonatomic) mat3 inverseOrientationMatrix;

- (void) startMotionDetection;
- (void) stopMotionDetection;
- (void) stopMotionDetectionAndResetOrientation;

@end
