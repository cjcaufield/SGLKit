//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#import "SGLMacSceneView.h"
#import "SGLContext.h"
#import "SGLScene.h"
#import "SGLMesh.h"
#import "SGLShader.h"
#import "SGLTexture.h"
#import "SGLUtilities.h"
#import "SGLMacWindow.h"
#import "SGLDefaults.h"
#import "SGLHeader.h"


@implementation SGLMacSceneView

#pragma mark - Creation

- (id) initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    [self initCommonMacSceneView];
    return self;
}

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    [self initCommonMacSceneView];
    return self;
}

- (void) initCommonMacSceneView
{
    #ifdef DEBUG
        _userControlsCamera = YES;
    #else
        _userControlsCamera = [DEFAULTS boolForKey:UserControlsCamera];
    #endif
}

- (void) dealloc
{
    [self removeObservers];
}

#pragma mark - Observers

- (void) addObservers
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(sceneChanged:) name:SGLSceneNeedsDisplayNotification object:nil];
}

- (void) removeObservers
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:SGLSceneNeedsDisplayNotification object:nil];
}

#pragma mark - Rendering

- (void) openGLWasPrepared
{
    [self addObservers];
    
    self.scene = [[SGLScene alloc] initWithContext:self.context]; // KVC safe!
    self.scene.renderingQuality = self.renderingQuality;
    
    [self transformWasChanged];
    
    self.scene.viewUsedRect = self.bounds;
    
    [super openGLWasPrepared];
}

- (void) update:(double)seconds
{
    [super update:seconds];
    
    [_scene update:seconds];
}

- (void) render
{
    [super render];
    
    [_scene render];
}

- (void) renderOverlay
{
    [super renderOverlay];
    
    [self drawTextLines:_scene.overlayText];
}

- (void) requestRedisplay
{
    if (self.shouldRenderContinuously == NO)
        self.forceNextFrameToRender = YES;
}

- (void) setRenderingQuality:(int)quality
{
    super.renderingQuality = quality;
    
    _scene.renderingQuality = quality;
}

#pragma mark - Changes

- (void) sceneChanged:(NSNotification*)note
{
    if (note.object == _scene)
        [self requestRedisplay];
}

- (void) transformWasChanged
{
    NSWindow* window = self.window;
    NSScreen* screen = window.screen;
    
    NSRect windowFrame = [window respondsToSelector:@selector(actualFrame)] ? [(id)window actualFrame] : [window frame];
    NSRect actualFrame = [window contentRectForFrameRect:windowFrame];
    
    //vec2 screenOrigin = PointToVec2(screen.frame.origin);
    vec2 screenSize = vec2(screen.frame.size);
    
    _actualFrameOrigin = vec2(actualFrame.origin);
    _actualFrameSize = vec2(actualFrame.size);
    
    _actualFrameOrigin.x -= screen.frame.origin.x;
    _actualFrameOrigin.y -= screen.frame.origin.y;
    
    vec2 originOffset = _actualFrameOrigin - 0.5 * screenSize; // - screenOrigin;
    vec2 centerOffset = originOffset + 0.5 * _actualFrameSize;
    vec2 viewSize = vec2(self.frame.size);
    
    [_scene setOriginOffset:originOffset
               centerOffset:centerOffset
                   viewSize:viewSize
               pixelDensity:self.pixelDensity];
    
    _scene.viewUsedRect = self.frame;
}

#pragma mark - Sizing

- (void) reposition
{
    [super reposition];
    [self transformWasChanged];
}

- (void) reshape
{
    [super reshape];
    [self transformWasChanged];
}

- (IBAction) resetCamera:(id)sender
{
    [_scene resetCamera];
}

#pragma mark - Gestures

- (void) scrollWheel:(NSEvent*)event
{
    if (_userControlsCamera == NO)
        return;
    
    if (event.modifierFlags & NSShiftKeyMask)
    {
        // Translate XY:
        vec2 offset = -1.f * vec2(event.deltaX, -event.deltaY);
        [_scene offsetCamera:offset];
    }
    else if (event.modifierFlags & NSAlternateKeyMask)
    {
        // Translate Z:
        float offset = -10.f * event.deltaY;
        [_scene moveCamera:offset];
    }
    else if (event.modifierFlags & NSCommandKeyMask)
    {
        // Rotate:
        vec2 offset = 0.01f * vec2(event.deltaX, -event.deltaY);
        [_scene rotateCamera:offset];
    }
}

@end
