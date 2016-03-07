//
//  SGLIosSceneView.mm
//  SGLKitTouch
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "SGLIosSceneView.h"
#import "SGLIosViewController.h"
#import "SGLScene.h"
#import "SGLMath.h"
#import "SGLUtilities.h"
#import "SGLDefaults.h"

@implementation SGLIosSceneView

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    #ifdef DEBUG
        _userControlsCamera = YES;
    #else
        _userControlsCamera = [DEFAULTS boolForKey:UserControlsCamera];
    #endif
    
    _singlePanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(singlePanGesture:)];
    _singlePanRecognizer.minimumNumberOfTouches = 1;
    _singlePanRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:_singlePanRecognizer];
    
    _doublePanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doublePanGesture:)];
    _doublePanRecognizer.minimumNumberOfTouches = 2;
    _doublePanRecognizer.maximumNumberOfTouches = 2;
    [self addGestureRecognizer:_doublePanRecognizer];
    
    _triplePanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(triplePanGesture:)];
    _triplePanRecognizer.minimumNumberOfTouches = 3;
    _triplePanRecognizer.maximumNumberOfTouches = 3;
    [self addGestureRecognizer:_triplePanRecognizer];
    
    _doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    _doubleTapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:_doubleTapRecognizer];
    [_doubleTapRecognizer requireGestureRecognizerToFail:self.tripleTapRecognizer];
}

- (void) openGLWasPrepared
{
    [super openGLWasPrepared];
    
    SGLIosViewController* controller = (id)self.delegate;
    
    self.scene = [[SGLScene alloc] initWithContext:controller.context];
    self.scene.renderingQuality = controller.renderingQuality;
    
    vec2 viewSize = SizeToVec2(self.bounds.size);
    vec2 originOffset = -0.5 * viewSize;
    
    [self.scene setOriginOffset:originOffset
                   centerOffset:ORIGIN_2D
                       viewSize:viewSize
                   pixelDensity:self.pixelDensity];
    
    self.scene.viewUsedRect = self.bounds;
}

- (void) openGLWasDestroyed
{
    [super openGLWasDestroyed];
    
    self.scene = nil;
}

- (void) update:(double)seconds
{
    [super update:seconds];
    
    [_scene update:seconds];
}

- (void) renderOverlay
{
    [super renderOverlay];
    
    [self drawTextLines:_scene.overlayText];
}

- (void) render
{
    [super render];
    
    [_scene render];
}

- (IBAction) singlePanGesture:(UIPanGestureRecognizer*)sender
{
    if (_userControlsCamera == NO)
        return;
    
    CGPoint translation = [sender translationInView:self];
    [_singlePanRecognizer setTranslation:CGPointZero inView:self.superview];
    
    // Rotate:
    vec2 offset = 0.01 * vec2(translation.x, -translation.y);
    [_scene rotateCamera:offset];
}

- (IBAction) doublePanGesture:(UIPanGestureRecognizer*)sender
{
    if (_userControlsCamera == NO)
        return;
    
    CGPoint translation = [sender translationInView:self];
    [_doublePanRecognizer setTranslation:CGPointZero inView:self.superview];
    
    // Translate XY:
    vec2 offset = -1.0f * vec2(translation.x, -translation.y);
    [_scene offsetCamera:offset];
}

- (IBAction) triplePanGesture:(UIPanGestureRecognizer*)sender
{
    if (_userControlsCamera == NO)
        return;
    
    CGPoint translation = [sender translationInView:self];
    [_triplePanRecognizer setTranslation:CGPointZero inView:self.superview];
    
    // Translate Z:
    float offset = -10.0f * translation.y;
    [_scene moveCamera:offset];
}

- (IBAction) doubleTapGesture:(UITapGestureRecognizer*)sender
{
    if (_userControlsCamera == NO)
        return;
    
    [self resetCamera:nil];
}

- (void) transformWasChanged
{
    vec2 viewSize = SizeToVec2(self.bounds.size);
    vec2 originOffset = -0.5 * viewSize;
    
    [self.scene setOriginOffset:originOffset
                   centerOffset:ORIGIN_2D
                       viewSize:viewSize
                   pixelDensity:self.pixelDensity];
}

- (IBAction) resetCamera:(id)sender
{
    [_scene resetCamera];
}

@end
