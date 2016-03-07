//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#import "SGLMacView.h"
#import "SGLMath.h"
#import "SGLContext.h"
#import "SGLShader.h"
#import "SGLTexture.h"
#import "SGLUtilities.h"
#import "SGLDefaults.h"
#import "SGLMacWindow.h"
#import "SGLMacWindowController.h"
#import <GLUT/GLUT.h>
#import <QuartzCore/QuartzCore.h>

#define USE_TRACKING_AREA
//#define PRINT_EXTENSIONS
#define SYNC_WITH_SCREEN_REFRESH
//#define USE_TRANSPARENCY
//#define ALLOW_INTEL_GMA_X3100

#define FOCUS_IN_SPEED  10.0f
#define FOCUS_OUT_SPEED 1.0f

static NSOpenGLContext* gSharedContext = nil;
static NSOpenGLPixelFormat* gSharedPixelFormat = nil;
static NSCursor* gInvisibleCursor = nil;
static NSCursor* gWhiteIBeamCursor = nil;

static const NSTimeInterval BACKGROUND_REFRESH_INTERVAL = 1.0 / 2.0;
static const NSTimeInterval FAKE_TIME_INTERVAL = 0.25 * (1.0 / 60.0);


@interface SGLMacView ()

@property (nonatomic) NSTimeInterval measuredFramerate;
@property (nonatomic) NSTimeInterval measuredUpdateTime;
@property (nonatomic) NSTimeInterval measuredRenderTime;
@property (nonatomic) NSTimeInterval measuredSubmitTime;
@property (nonatomic) CVDisplayLinkRef displayLink;
@property (nonatomic, strong) NSThread* renderThread;
@property (nonatomic, strong) NSTrackingArea* trackingArea;
@property (nonatomic) int currentTextRow;

- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime;

@end


static CVReturn DisplayLinkCallback
(
    CVDisplayLinkRef displayLink,
    const CVTimeStamp* now,
    const CVTimeStamp* outputTime,
    CVOptionFlags flagsIn,
    CVOptionFlags* flagsOut,
    void* displayLinkContext
)
{
    return [(__bridge SGLMacView*)displayLinkContext getFrameForTime:outputTime];
}

NSTimeInterval smoothAdd(NSTimeInterval oldAverage, NSTimeInterval newValue)
{
    return 0.38 * oldAverage + 0.62 * newValue;
}


@implementation SGLMacView

+ (NSCursor*) invisibleCursor
{
    return gInvisibleCursor;
}

+ (NSCursor*) whiteIBeamCursor
{
    return gWhiteIBeamCursor;
}

- (NSOpenGLPixelFormat*) sharedPixelFormat
{
    if (gSharedPixelFormat == nil)
    {
        NSOpenGLPixelFormatAttribute attrs[64];
        
        int i = 0;
        attrs[i++] = NSOpenGLPFADoubleBuffer;
        attrs[i++] = NSOpenGLPFANoRecovery;
        attrs[i++] = NSOpenGLPFAAccelerated;
        //attrs[i++] = NSOpenGLPFAWindow;
        attrs[i++] = NSOpenGLPFAColorSize;      attrs[i++] = 24;
        attrs[i++] = NSOpenGLPFAAlphaSize;      attrs[i++] = 8;
        //attrs[i++] = NSOpenGLPFAOpenGLProfile;  attrs[i++] = NSOpenGLProfileVersion3_2Core;
        
        // DEPTH NOT USED YET
        //attrs[i++] = NSOpenGLPFADepthSize; attrs[i++] = 32;
        
        attrs[i++] = 0;
        
        gSharedPixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
        SGL_ASSERT(gSharedPixelFormat != nil);
    }
    
    return gSharedPixelFormat;
}

- (void) createContext
{
    self.openGLContext = [[NSOpenGLContext alloc] initWithFormat:gSharedPixelFormat shareContext:gSharedContext];
    self.openGLContext.view = self;
}

- (id) initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame pixelFormat:self.sharedPixelFormat];
    
    [self initCommonMacView];
    
    return self;
}

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    
    self.pixelFormat = self.sharedPixelFormat;
    
    [self createContext];
    
    [self initCommonMacView];
    
    return self;
}

- (void) initCommonMacView
{
    if (gSharedContext == nil)
        gSharedContext = self.openGLContext;
    else
        [self createContext];
    
    SGL_ASSERT(self.openGLContext != nil);
    
    BOOL shouldUseRetina = [DEFAULTS boolForKey:UseRetinaResolution];
    
    BOOL hardwareCanDoRetina = NO;
    for (NSScreen* screen in NSScreen.screens)
        if (screen.backingScaleFactor >= 2.0)
            hardwareCanDoRetina = YES;
    
    if (hardwareCanDoRetina && shouldUseRetina)
        self.wantsBestResolutionOpenGLSurface = YES;
    
    if ([DEFAULTS objectForKey:Framerate] != nil)
        _framerate = (NSTimeInterval)[DEFAULTS doubleForKey:Framerate];
    else
        _framerate = 60.0;
    
    if (_framerate <= 2.0)
        _framerate = 2.0;
    
    _measuredFramerate = 60.0;
    
    _highQualityBackgroundWindows = [DEFAULTS boolForKey:FullFramerateBackgroundWindows];
    
    if (gInvisibleCursor == nil)
    {
        NSString* filename = @"InvisibleCursor";
        NSString* extension = @"png";
        
        NSBundle* glKitBundle = [NSBundle bundleForClass:[SGLMacView class]];
        NSString* filepath = [glKitBundle pathForResource:filename ofType:extension];
        NSImage* invisibleImage = [[NSImage alloc] initWithContentsOfFile:filepath];
        
        gInvisibleCursor = [[NSCursor alloc] initWithImage:invisibleImage hotSpot:NSZeroPoint];
    }
    
    if (gWhiteIBeamCursor == nil)
    {
        NSString* filename1x = @"WhiteIBeam";
        NSString* filename2x = [filename1x stringByAppendingString:@"@2x"];
        NSString* extension = @"png";
        
        NSBundle* glKitBundle = [NSBundle bundleForClass:[SGLMacView class]];
        NSString* filepath1x = [glKitBundle pathForResource:filename1x ofType:extension];
        NSString* filepath2x = [glKitBundle pathForResource:filename2x ofType:extension];
        
        NSImage* whiteIBeamImage = [[NSImage alloc] initWithContentsOfFile:filepath1x];
        NSImage* whiteIBeamImage2x = [[NSImage alloc] initWithContentsOfFile:filepath2x];
        
        [whiteIBeamImage addRepresentation:whiteIBeamImage2x.representations[0]];
        
        gWhiteIBeamCursor = [[NSCursor alloc] initWithImage:whiteIBeamImage hotSpot:NSMakePoint(4.0, 9.0)];
    }
    
    #ifdef USE_TRACKING_AREA
        self.window.acceptsMouseMovedEvents = YES;
        [self updateTrackingAreas];
    #endif
    
    // Register to recieve the names of files dropped on this view.
    [self registerForDraggedTypes:@[NSFilenamesPboardType]];
}

- (void) dealloc
{
    [self killDisplayLink];
}

- (void) awakeFromNib
{
    SGL_METHOD_LOG;
}

- (float) pixelDensity
{
    return [self convertSizeToBacking:CGSizeMake(1.0, 1.0)].width;
}

- (void) prepareOpenGL
{
    NSLog(@"prepareOpenGL");
    
    [self lockContext];
    
    [self checkGLCapabilities];
    
    _context = [[SGLContext alloc] initWithCocoaContext:self.openGLContext];
    _timeOfLastFrame = NSDate.timeIntervalSinceReferenceDate;
    
    // Synchronize buffer swaps with vertical refresh rate.  This prevents tearing, even with double buffers.
    #ifdef SYNC_WITH_SCREEN_REFRESH
        GLint swap = 1;
        [self.openGLContext setValues:&swap forParameter:NSOpenGLCPSwapInterval];
    #endif
    
    // 
    #ifdef USE_TRANSPARENCY
        GLint opacity = 0;
        [self.openGLContext setValues:&opacity forParameter:NSOpenGLCPSurfaceOpacity];
    #endif
    
    // Create a display link capable of being used with all active displays.
    CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
    
    // Set the Terminal output callback function.
    CVDisplayLinkSetOutputCallback(_displayLink, &DisplayLinkCallback, (__bridge void*)self);
    
    // Set the display link for the current Terminal.
    CGLContextObj cglContext = (CGLContextObj)self.openGLContext.CGLContextObj;
    CGLPixelFormatObj cglPixelFormat = (CGLPixelFormatObj)self.pixelFormat.CGLPixelFormatObj;
    
    CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(_displayLink, cglContext, cglPixelFormat);
    
    [self openGLWasPrepared];
    
    [self startDisplayLink];
    
    self.needsDisplay = YES;
    self.isPrepared = YES;
    
    [self unlockContext];
}

- (void) openGLWasPrepared
{
    // nothing.
}

// CJC temp
/*
- (BOOL) isOpaque
{
    // CJC temp:
    //return NO;
    return YES;
}
*/

- (CGFloat) width
{
    return self.bounds.size.width;
}

- (CGFloat) height
{
    return self.bounds.size.height;
}

- (CGFloat) aspectRatio
{
    return self.width / self.height;
}

- (BOOL) shouldRenderContinuously
{
    return YES;
}

- (void) setRenderingQuality:(int)quality
{
    _renderingQuality = quality;
    
    if (self.shouldRenderContinuously == NO)
        self.needsDisplay = YES;
}

- (void) drawRect:(NSRect)rect
{
    if (_isPrepared == NO)
        return;
    
    NSTimeInterval now = NSDate.timeIntervalSinceReferenceDate;
    
    NSTimeInterval frameDelta = now - _timeOfLastFrame;
    
    double seconds;
    
    if (_usesFakeTime)
        seconds = FAKE_TIME_INTERVAL;
    else if (_timeOfLastFrame == 0.0)
        seconds = 0.0;
    else
        seconds = frameDelta;
    
    //
    // 
    //
    
    [self lockContext];
    
    double rate = float(1.0 / (now - _timeOfLastFrame));
    _measuredFramerate = smoothAdd(_measuredFramerate, rate);
    _timeOfLastFrame = now;
    
    [self.openGLContext makeCurrentContext];
    
    NSTimeInterval start, end;
    
    start = NSDate.timeIntervalSinceReferenceDate;
    [self update:seconds];
    end = NSDate.timeIntervalSinceReferenceDate;
    _measuredUpdateTime = smoothAdd(_measuredUpdateTime, end - start);
    
    start = NSDate.timeIntervalSinceReferenceDate;
    [self render];
    end = NSDate.timeIntervalSinceReferenceDate;
    _measuredRenderTime = smoothAdd(_measuredRenderTime, end - start);
    
    if (_showInfo)
        [self renderOverlay];
    
    _currentTextRow = 0;
    
    start = NSDate.timeIntervalSinceReferenceDate;
    [self.openGLContext flushBuffer];
    end = NSDate.timeIntervalSinceReferenceDate;
    _measuredSubmitTime = smoothAdd(_measuredSubmitTime, end - start);
    
    [self unlockContext];
}

- (void) update:(double)seconds
{
    _elapsedTime += seconds;
    
    if (_highQualityBackgroundWindows)
    {
        _timeEffectsLevel = 1.0;
    }
    else
    {
        if (self.window.isMainWindow)
        {
            float newTimeEffectsLevel = _timeEffectsLevel + FOCUS_IN_SPEED * seconds;
            
            if (newTimeEffectsLevel > 1.0)
                newTimeEffectsLevel = 1.0;
            if (newTimeEffectsLevel < 0.0)
                newTimeEffectsLevel = 0.0;
            
            _timeEffectsLevel = newTimeEffectsLevel;
        }
        else
        {
            float newTimeEffectsLevel = _timeEffectsLevel - FOCUS_OUT_SPEED * seconds;
            
            if (newTimeEffectsLevel > 1.0)
                newTimeEffectsLevel = 1.0;
            if (newTimeEffectsLevel < 0.0)
                newTimeEffectsLevel = 0.0;
            
            _timeEffectsLevel = newTimeEffectsLevel;
        }
    }
}

- (void) update
{
    [self lockContext];
    [super update];
    [self unlockContext];
}

// This is the entry point for the display link rendering thread.  It's called after each vsync.
- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime
{
    if (_isPrepared == NO)
        return kCVReturnSuccess;
        
    if (_paused)
        return kCVReturnSuccess;
    
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval frameDelta = now - _timeOfLastFrame;
    
    if (_forceNextFrameToRender == NO)
    {
        if (self.shouldRenderContinuously == NO)
            return kCVReturnSuccess;
        
        if (frameDelta < 0.9 * (1.0 / _framerate))
            return kCVReturnSuccess;
        
        // CJC: this should be replaced by a framerate based solution in the window controller.
        if (_highQualityBackgroundWindows == NO)
        {
            NSTimeInterval timeSinceLastMain = now - [self.window.windowController timeWhenLastMain];
            
            if (self.window.isMainWindow == NO && timeSinceLastMain > 1.0 && frameDelta < BACKGROUND_REFRESH_INTERVAL)
                return kCVReturnSuccess;
        }
    }
    
    _forceNextFrameToRender = NO;
    
    [self lockContext];
    
    @autoreleasepool
    {
        [self drawRect:self.bounds];
    }
    
    [self unlockContext];
    
    return kCVReturnSuccess;
}

- (void) drawText:(NSString*)text
{
    [self drawTextLines:@[text]];
}

- (void) drawTextLines:(NSArray*)lines
{
    NSRect backingRect = [self convertRectToBacking:self.bounds];
    
    [SGLTexture deactivateAll];
    [SGLShader deactivateAll];
    
    //[_context removeMatrices];
    
    glColor3f(1.0f, 1.0f, 1.0f);
    
    for (NSString* line in lines)
    {
        float pixelPosX = 6.0f;
        float pixelPosY = float(_currentTextRow + 1) * 26.0f;
        glRasterPos3f(-1.0f + pixelPosX / backingRect.size.width, 1.0f - pixelPosY / backingRect.size.height, -1.0f);
        for (int i = 0; i < line.length; i++)
            glutBitmapCharacter(GLUT_BITMAP_8_BY_13, [line characterAtIndex:i]);
        
        _currentTextRow++;
    }
    
    //[_context restoreMatrices];
}

- (void) shadersDidReload
{
    // nothing.
}

- (void) windowWillClose
{
    [self killDisplayLink];
}

- (void) lockContext
{
    [self.openGLContext makeCurrentContext];
    
    // Instead of locking the context, we lock the entire GL so that rendering isn't happening in parallel.
    [SGLContext lockGL];
}

- (void) unlockContext
{
    [SGLContext unlockGL];
}

- (void) startDisplayLink
{
    CVDisplayLinkStart(_displayLink);
}

/*
- (void) stopDisplayLink
{
    CVDisplayLinkStop(_displayLink);
}
*/

- (void) killDisplayLink
{
    [self lockContext];
    _isPrepared = NO;
    [self unlockContext];
    
    if (_displayLink != nil)
    {
        CVDisplayLinkRelease(_displayLink);
        _displayLink = nil;
    }
}

- (void) render
{
    // nothing
}

- (void) renderOverlay
{
    NSArray* lines =
    @[
        [NSString stringWithFormat:@"Frame Rate: %4.2f", _measuredFramerate],
        [NSString stringWithFormat:@"Update Time: %4.2f ms", _measuredUpdateTime * 1000.0],
        [NSString stringWithFormat:@"Render Time: %4.2f ms", _measuredRenderTime * 1000.0],
        [NSString stringWithFormat:@"Submit Time: %4.2f ms", _measuredSubmitTime * 1000.0],
        [NSString stringWithFormat:@"View Size: %4.2f, %4.2f", self.width, self.height],
        [NSString stringWithFormat:@"Aspect Ratio: %4.2f", self.width / self.height]
    ];
    
    [self drawTextLines:lines];
}

- (void) reshape
{
    [self lockContext];

    [self.openGLContext makeCurrentContext];
    [self.openGLContext update];
    
    NSRect backingRect = [self convertRectToBacking:self.bounds];
    
    glViewport(0, 0, int(backingRect.size.width), int(backingRect.size.height));
    
    [self unlockContext];
}

- (void) reposition
{
    // nothing.
}

- (BOOL) acceptsFirstResponder
{
    return YES;
}

- (void) updateTrackingAreas
{
    #ifdef USE_TRACKING_AREA
    
        //NSLog(@"%@ updateTrackingAreas", self);
        
        if (_trackingArea != nil)
            [self removeTrackingArea:_trackingArea];
        
        int trackingOptions = NSTrackingMouseEnteredAndExited | NSTrackingCursorUpdate | // Type of events to receive.
                              NSTrackingActiveWhenFirstResponder |                       // When to receive them.
                              NSTrackingEnabledDuringMouseDrag | NSTrackingAssumeInside; // Other options.
        
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:trackingOptions owner:self userInfo:nil];
        [self addTrackingArea:_trackingArea];
        
    #endif
}

#ifdef USE_TRACKING_AREA

    - (void) mouseDown:(NSEvent*)event
    {
        //NSLog(@"mouseDown");
        
        //if (_useCustomCursor)
        //    [gInvisibleCursor set];
        //else
        [gWhiteIBeamCursor set];
    }

    - (void) mouseEntered:(NSEvent*)event
    {
        //NSLog(@"mouseEntered");
        
        //if (_useCustomCursor)
        //    [gInvisibleCursor set];
        //else
        [gWhiteIBeamCursor set];
    }

    - (void) mouseExited:(NSEvent*)event
    {
        //NSLog(@"mouseExited");
        
        [NSCursor.arrowCursor set];
    }

    - (void) cursorUpdate:(NSEvent*)event
    {
        //NSLog(@"cursorUpdate");
        
        //if (_useCustomCursor)
        //    [gInvisibleCursor set];
        //else
        [gWhiteIBeamCursor set];
    }

#endif // USE_TRACKING_AREA

- (IBAction) reloadShaders:(id)sender
{
    #ifdef DEBUG
    
        [self lockContext];
        [SGLShader reloadAll];
        [self shadersDidReload];
        [self unlockContext];
        
    #endif
}

- (void) checkGLCapabilities
{
    NSLog(@"Checking OpenGL:");
    
    //
    // Vendor.
    //
    
    const GLubyte* vendor = glGetString(GL_VENDOR);
    const GLubyte* renderer = glGetString(GL_RENDERER);
    
    NSLog(@"Vendor:       %s", vendor);
    NSLog(@"Renderer:     %s", renderer);
	
	// Intel GMA 950
	// Unsupported: No OpenGL 2.0.
	// MacBook 2006-2007
	// MacMini 2006-2009
	// iMac	   2006-2007
	
	if (strstr((char*)renderer, "Intel GMA 950") != NULL)
        ExitGracefully(@"Your graphics card (Intel GMA 950) is not supported.");
	
	// Intel GMA X3100
	// Unsupported: Breaks frequently.  Renders slowly.
	// MacBook    2007-2008
	// MacBookAir 2008
	
    #ifndef ALLOW_INTEL_GMA_X3100
        if (strstr((char*)renderer, "X3100") != NULL)
            ExitGracefully(@"Your graphics card (Intel GMA X3100) is not supported.");
    #endif
	
	// ATI Mobility Radeon X1600
	// Unsupported: Red frame box.
	// MacBookPro 2006-2007
	
	// ATI Radeon X1600
	// Unknown.  Assumed red frame box.
	// iMac 2006-2007
	
	if (strstr((char*)renderer, "X1600") != NULL)
        ExitGracefully(@"Your graphics card (ATI Radeon X1600) is not supported.");
	
	// ATI Radeon X1900 XT
	// Unsupported: Red frame box.
	// MacPro 2006-2007
	
	if (strstr((char*)renderer, "X1900") != NULL)
        ExitGracefully(@"Your graphics card (ATI Radeon X1900 XT) is not supported.");
	
	// NVIDIA Quadro FX 4500
	// Supported: Characters are shifted.
	// MacPro 2006-2007
	
	// NVIDIA GeForce 7300 GT
	// Supported: Characters are shifted.
	// iMac	  2006-2007
	// MacPro 2006-2007
	
	// NVIDIA GeForce 7600 GT
	// Supported: Characters are shifted.
	// iMac 2006-2007
	
	// NVIDIA GeForce 8600M GT
	// Unknown.
	// MacBookPro 2007-2008
	
	// NVIDIA GeForce 8800 GT
	// Unknown.
	// MacPro 2006-2007
	
	// NVIDIA GeForce 9600M GT
	// Unknown.
	// MacBookPro 2007-2008
	
	// ATI Radeon HD 2400 XT
	// Unknown.
	// iMac 2007-2009
	
	// ATI Radeon HD 2600 PRO
	// Unknown.
	// iMac 2007-2009
	
	// ATI Radeon HD 2600 XT
	// Unknown.
	// MacPro 2008-2009
	
	// NVIDIA Quadro FX 4800
	// Unknown.
	// MacPro 2008-2009
	
	// NVIDIA Quadro FX 5600
	// Unknown.
	// MacPro 2008-2009
	
	// NVIDIA GeForce 8800 GS
	// Unknown.
	// iMac 2008-2009
	
	// NVIDIA GeForce 8800 GT
	// Unknown.
	// MacPro 2008-2009
	
	// NVIDIA GeForce 9400M
	// Supported.
	// MacBook    2008-2009
	// MacBookAir 2008-2009
	// MacBookPro 2009-2010
	// MacMini    2009-2010
	// iMac	      2009-2010
	
	// NVIDIA GeForce 320M
	// Supported.
	// MacBook    2010-2011
	// MacBookAir 2010-2011
	// MacBookPro 2010-2011
	// MacMini    2010-2011
    
    // Intel HD Graphics 3000
    // Supported.
    // MacBookPro 2011 (primary on the 13 inch, secondary on the 15 and 17 inch).
    
    //
    // Versions.
    //
    
    const GLubyte* version     = glGetString(GL_VERSION);
    const GLubyte* glslVersion = glGetString(GL_SHADING_LANGUAGE_VERSION);
    
    NSLog(@"Version:      %s", version);
    NSLog(@"GLSL Version: %s", glslVersion);
    
    int majorVersion = version[0] - '0';
    //int minorVersion = version[2] - '0';
    
    if (majorVersion < 2)
        ExitGracefully(@"OpenGL 2.0 or later is required.");
    
    int glslMajorVersion = glslVersion[0] - '0';
    //int glslMinorVersion = glslVersion[2] - '0';
    
    if (10 * glslMajorVersion + glslMajorVersion < 11)
        ExitGracefully(@"GLSL 1.1 or later is required.");
    
    //
    // Textures.
    //
    
    //GLint maxTextureUnits;
    //glGetIntegerv(GL_MAX_TEXTURE_UNITS, &maxTextureUnits);
    //NSLog(@"Max Texture Units: %d", maxTextureUnits);
    
    GLint maxTextureImageUnits;
    glGetIntegerv(GL_MAX_TEXTURE_IMAGE_UNITS, &maxTextureImageUnits);
    NSLog(@"Max Texture Image Units: %d", maxTextureImageUnits);
    
    if (/*maxTextureUnits < 8 ||*/ maxTextureImageUnits < 8)
        ExitGracefully(@"A GPU with at least eight texture units is required.");
    
    //
    // Extensions.
    //
    
    #ifdef PRINT_EXTENSIONS
    
        const GLubyte* extensions = glGetString(GL_EXTENSIONS);
        
        if (strstr((char*)extensions, "GL_ARB_framebuffer_object") == NULL)
            ExitGracefully(@"The OpenGL framebuffer extension is required.");
        
        //if (strstr((char*)extensions, "GL_EXT_framebuffer_object") == NULL)
        //    ExitGracefully(@"The OpenGL framebuffer extension is required.");
        
        //NSLog(@"Extensions: %s", extensions);
    
    #endif
}

@end
