//
//  SGLIosViewController.mm
//  SGLKitTouchTest
//
//  Created by Colin Caufield on 2014-05-02.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLIosViewController.h"
#import "SGLIosSceneView.h"
#import "SGLMotionManager.h"
#import "SGLContext.h"
#import "SGLScene.h"
#import "SGLUtilities.h"
#import "SGLDebug.h"

EAGLSharegroup* __weak sharedRenderingGroup = nil;

#pragma mark - Private

@interface SGLIosViewController ()

@property (nonatomic, strong) UIView* blackoutView;

@end

#pragma mark - Public

@implementation SGLIosViewController

#pragma mark - Lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    if (_cocoaContext == nil)
    {
        if (sharedRenderingGroup == nil)
        {
            _cocoaContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
            sharedRenderingGroup = _cocoaContext.sharegroup;
        }
        else
        {
            _cocoaContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2 sharegroup:sharedRenderingGroup];
        }
    }
    
    if (_cocoaContext == nil)
    {
        SGL_ASSERT(false);
        NSLog(@"Failed to create OpenGL ES context.");
    }
    
    EAGLContext.currentContext = _cocoaContext;
    
    GLKView* view = (id)self.view;
    view.context = _cocoaContext;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    _context = [[SGLContext alloc] initWithCocoaContext:_cocoaContext];
    
    _motionManager = [SGLMotionManager shared];
    [_motionManager startMotionDetection];

    [self setupGL];
    
    [self addObservers];
}

- (void) viewDidUnload
{
    [self removeObservers];
    
    [super viewDidUnload];
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if (self.isViewLoaded && self.view.window == nil)
    {
        self.view = nil;
        
        [self tearDownGL];
        
        if (EAGLContext.currentContext == _cocoaContext)
            EAGLContext.currentContext = nil;
        
        _context = nil;
        _cocoaContext = nil;
    }
}

- (void) dealloc
{
    [self removeObservers];
    [self tearDownGL];
    
    if (EAGLContext.currentContext == _cocoaContext)
        EAGLContext.currentContext = nil;
}

#pragma mark - Observers

- (void) addObservers
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(sceneChanged:) name:SGLSceneNeedsDisplayNotification object:nil];
    [center addObserver:self selector:@selector(orientationChanged:) name:SGLOrientationChangedNotification object:nil];
    //[center addObserver:self selector:@selector(accelerationChanged:) name:SGLAccelerationChangedNotification object:nil];
}

- (void) removeObservers
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:SGLSceneNeedsDisplayNotification object:nil];
    [center removeObserver:self name:SGLOrientationChangedNotification object:nil];
    //[center removeObserver:self name:SGLAccelerationChangedNotification object:nil];
}

#pragma mark - Rendering

- (void) setupGL
{
    EAGLContext.currentContext = _cocoaContext;
    
    [(id)self.view openGLWasPrepared];
}

- (void) tearDownGL
{
    SGL_METHOD_LOG;
    
    EAGLContext.currentContext = _cocoaContext;
    
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    
    // Unload all shared shaders.
    //[SGLShader deleteAll];
    //[SGLProgram deleteAll];
    
    [(id)self.view openGLWasDestroyed];
    
    glFinish();
}

- (void) glkView:(GLKView*)view drawInRect:(CGRect)rect
{
    //SGL_METHOD_LOG_ARGS(@"%@ isRotating:%d", NSStringFromCGSize(rect.size), _isRotating);
    
    // CJC: Attempting to prevent OpenGL calls from happening in the background.
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateBackground)
        return;
    
    if (_isRotating)
    {
        [self.context clear:OPAQUE_BLACK];
        //[self.context clear:vec4(0.3, 0.0, 0.0, 1.0)];
        return;
    }
    
    [self render];
}

- (void) render
{
    SGLScene* scene = [(id)self.view scene];
    
    if (scene)
        [scene render];
}

- (void) requestRedisplay
{
    // CJC revisit: should setNeedsDisplay only be called for continuous rendering qualities?
    //if (self.shouldRenderContinuously == NO)
    [self.view setNeedsDisplay];
}

- (void) sceneChanged:(NSNotification*)note
{
    SGLScene* scene = [(id)self.view scene];
    
    if (note.object == scene)
        [self requestRedisplay];
}

#pragma mark - Layout

- (void) viewWillLayoutSubviews
{
    SGL_METHOD_LOG;
    
    [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews
{
    SGL_METHOD_LOG;
    
    [super viewWillLayoutSubviews];
    
    [(id)self.view transformWasChanged];
}

#pragma mark - Rotation

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration
{
    SGL_METHOD_LOG;
    
    _isRotating = YES;
    
    [self.view setNeedsDisplay];
    
    /*
    _blackoutView = [[UIView alloc] initWithFrame:self.view.bounds];
    _blackoutView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _blackoutView.opaque = NO;
    _blackoutView.backgroundColor = [UIColor blackColor];
    _blackoutView.alpha = 0.0;
    
    [self.view addSubview:_blackoutView];
    
    [UIView animateWithDuration:0.2 animations:^
    {
        _blackoutView.alpha = 1.0;
    }];
    */
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    SGL_METHOD_LOG;
    
    SGLScene* scene = [(id)self.view scene];
    
    vec2 viewSize = vec2(self.view.bounds.size);
    vec2 originOffset = -0.5 * viewSize;
    
    float pixelDensity = [(id)self.view pixelDensity];
    
    [scene setOriginOffset:originOffset
              centerOffset:ORIGIN_2D
                  viewSize:viewSize
              pixelDensity:pixelDensity];
    
    scene.viewUsedRect = self.view.bounds;
    
    /*
    [UIView animateWithDuration:0.5
    
        animations:^
        {
            _blackoutView.alpha = 0.0;
        }

        completion:^(BOOL finished)
        {
            [_blackoutView removeFromSuperview];
            _blackoutView = nil;
        }
    ];
    */
    
    _isRotating = NO;
    
    [self.view setNeedsDisplay];
}

- (void) orientationChanged:(NSNotification*)note
{
    //SGL_METHOD_LOG;
    
    SGLScene* scene = [(id)self.view scene];
    
    scene.inverseOrientationMatrix = _motionManager.inverseOrientationMatrix;
}

/*
- (void) accelerationChanged:(NSNotification*)note
{
    SGL_METHOD_LOG;
}
*/

@end
