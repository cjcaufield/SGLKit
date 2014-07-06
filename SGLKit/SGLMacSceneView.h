//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SGLMacView.h"
#import "SGLMath.h"

@class SGLScene;

@interface SGLMacSceneView : SGLMacView

@property (nonatomic, strong) SGLScene* scene;
@property (nonatomic) BOOL userControlsCamera;
@property (nonatomic) vec2 actualFrameOrigin;
@property (nonatomic) vec2 actualFrameSize;

- (void) addObservers;
- (void) removeObservers;
- (void) transformWasChanged;
- (void) requestRedisplay;

- (IBAction) resetCamera:(id)sender;

@end
