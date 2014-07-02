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
#import "SGLHeader.h"


@implementation SGLMacSceneView

- (id) initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    #ifdef DEBUG
        _userControlsCamera = YES;
    #else
        _userControlsCamera = [[NSUserDefaults standardUserDefaults] boolForKey:@"UserControlsCamera"];
    #endif
    
    return self;
}

- (void) openGLWasPrepared
{
    self.scene = [[SGLScene alloc] initWithContext:self.context]; // KVC safe!
    self.scene.renderingQuality = self.renderingQuality;
    
    [self transformWasChanged];
    
    self.scene.viewUsedRect = self.bounds;
    
    [super openGLWasPrepared];
}

- (void) transformWasChanged
{
    NSWindow* window = self.window;
    NSScreen* screen = window.screen;
    
    NSRect windowFrame = [window respondsToSelector:@selector(actualFrame)] ? [(id)window actualFrame] : [window frame];
    NSRect actualFrame = [window contentRectForFrameRect:windowFrame];
    
    vec2 screenOrigin = PointToVec2(screen.frame.origin);
    vec2 screenSize = SizeToVec2(screen.frame.size);
    
    _actualFrameOrigin = PointToVec2(actualFrame.origin);
    _actualFrameSize = SizeToVec2(actualFrame.size);
    
    _actualFrameOrigin.x -= screen.frame.origin.x;
    _actualFrameOrigin.y -= screen.frame.origin.y;
    
    vec2 originOffset = _actualFrameOrigin - 0.5 * screenSize - screenOrigin;
    vec2 centerOffset = originOffset + 0.5 * _actualFrameSize;
    vec2 viewSize = SizeToVec2(self.frame.size);
    
    [_scene setOriginOffset:originOffset
               centerOffset:centerOffset
                   viewSize:viewSize
               pixelDensity:self.pixelDensity];
    
    _scene.viewUsedRect = self.frame;
}

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

- (IBAction) resetCamera:(id)sender
{
    [_scene resetCamera];
}

- (void) setRenderingQuality:(int)quality
{
    super.renderingQuality = quality;
    
    _scene.renderingQuality = quality;
}

@end
