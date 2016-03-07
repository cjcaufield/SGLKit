//
// Copyright (c) 2014 Secret Geometry, Inc.  All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SGLMacWindow : NSWindow

@property (nonatomic) NSRect userFrame;
@property (readonly) BOOL isZoomed;
@property (readonly) NSRect actualFrame;
@property (nonatomic) BOOL mouseIsDown;
@property (nonatomic) BOOL rightMouseIsDown;
@property (nonatomic) BOOL otherMouseIsDown;
@property (readonly) NSTimeInterval timeSinceLastMouseInteraction;
//@property BOOL transparent;

- (void) resizeForContentSize:(NSSize)newSize display:(BOOL)display animate:(BOOL)animate;
- (void) adjustToFitOnScreenWithAnimation:(BOOL)animate;

@end
