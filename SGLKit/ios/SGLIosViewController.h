//
//  SGLIosViewController.h
//  SGLKitTouch
//
//  Created by Colin Caufield on 2014-05-02.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <GLKit/GLKit.h>

@class SGLContext, SGLMotionManager;

@interface SGLIosViewController : GLKViewController

@property (nonatomic, strong) EAGLContext* cocoaContext;
@property (nonatomic, strong) SGLContext* context;
@property (nonatomic, strong) SGLMotionManager* motionManager;
@property (nonatomic) int renderingQuality;
@property (nonatomic) BOOL dynamicOrientation;
@property (readonly) BOOL isRotating;

- (void) addObservers;
- (void) removeObservers;
- (void) setupGL;
- (void) tearDownGL;
- (void) requestRedisplay;
- (void) render;
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration;
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
