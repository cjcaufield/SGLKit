//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SGLContext;

//
// GLView
// 

@interface SGLMacView : NSOpenGLView

@property (nonatomic, strong) SGLContext* context;
@property (readonly) CGFloat width;
@property (readonly) CGFloat height;
@property (readonly) CGFloat aspectRatio;
@property (nonatomic) float pixelDensity;
@property (nonatomic) NSTimeInterval framerate;
@property (nonatomic) NSTimeInterval timeOfLastFrame;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) float timeEffectsLevel;
@property (nonatomic) BOOL paused;
@property (nonatomic) BOOL showInfo;
//@property (nonatomic) BOOL useCustomCursor;
@property (nonatomic) BOOL usesFakeTime;
@property (nonatomic) BOOL highQualityBackgroundWindows;
@property (nonatomic) BOOL forceNextFrameToRender;
@property (nonatomic) BOOL isPrepared;
@property (readonly) BOOL shouldRenderContinuously;
@property (nonatomic) int renderingQuality;

+ (NSCursor*) invisibleCursor;

- (void) openGLWasPrepared;
- (void) update:(double)seconds;
- (void) render;
- (void) renderOverlay;
- (void) drawText:(NSString*)text;
- (void) drawTextLines:(NSArray*)lines;
- (void) reshape;
- (void) reposition;
- (void) shadersDidReload;
- (void) windowWillClose;
- (void) lockContext;
- (void) unlockContext;
- (void) killDisplayLink;

- (IBAction) reloadShaders:(id)sender;

@end
