//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#import "SGLContext.h"
#import "SGLProgram.h"
#import "SGLTexture.h"
#import "SGLUtilities.h"
#import "SGLHeader.h"
#import "SGLDebug.h"

#ifdef SGL_MAC
    #import <GLUT/GLUT.h>
#endif

static NSRecursiveLock* glLock = nil;
//static int lockDepth = 0;
//static NSTimeInterval lockTimes[128] = {0.0};

#pragma mark - Private

@interface SGLContext ()

@property (nonatomic, strong) id cocoaContext;
@property (nonatomic) std::vector<mat4> modelViewStack;

@end

#pragma mark - Public

@implementation SGLContext

#pragma mark - Creation

+ (void) initialize
{
    #ifdef DEBUG
        NSLog(@"SGLKit running in DEBUG mode.");
    #else
        NSLog(@"SGLKit running in RELEASE mode.");
    #endif
        
    glLock = [[NSRecursiveLock alloc] init];
}

- (id) initWithCocoaContext:(id)cc
{
    self = [super init];
    
    _cocoaContext = cc;
	
	self.backfaceCulling = YES;
	
    // DEPTH NOT USED YET
    //glEnable(GL_DEPTH_TEST);
    
    #ifdef SGL_MAC
        glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
    #endif
    
	_basicShader = [[SGLShader alloc] initWithName:@"Basic"];
    
    _modelViewStack.reserve(16);
    _modelViewStack.push_back(mat4::identity());
    
    return self;
}

- (void) activate
{
    #ifdef SGL_MAC
        [self.cocoaContext makeCurrentContext];
    #endif
    #ifdef SGL_IOS
        EAGLContext.currentContext = self.cocoaContext;
    #endif
}

#pragma mark - Locking

+ (void) lockGL
{
    //lockTimes[lockDepth] = NSDate.timeIntervalSinceReferenceDate;
    //SGL_METHOD_LOG_ARGS(@"%d", lockDepth);
    //lockDepth++;
    
    SGL_ASSERT(glLock != nil);
    [glLock lock];
}

+ (void) unlockGL
{
    //lockDepth--;
    //NSTimeInterval duration = NSDate.timeIntervalSinceReferenceDate - lockTimes[lockDepth];
    //SGL_METHOD_LOG_ARGS(@"%d, %.3f", lockDepth, duration);
    
    SGL_ASSERT(glLock != nil);
    [glLock unlock];
}

#pragma mark - Transform

- (const mat4) modelViewMatrix
{   
    return _modelViewStack.back();
}

- (void) setModelViewMatrix:(const mat4)matrix
{
    _modelViewStack.back() = matrix;
}

- (void) push
{
    _modelViewStack.push_back(_modelViewStack.back());
}

- (void) pop
{
    if (_modelViewStack.size() > 1)
        _modelViewStack.pop_back();
}

- (void) loadIdentity
{
    mat4 newMatrix = mat4::identity();
    self.modelViewMatrix = newMatrix;
}

- (void) translate:(vec3)v
{
    mat4 tm = mat4::translation(v);
    const mat4& mvm = self.modelViewMatrix;
    
    mat4 newMatrix = mvm * tm;
    self.modelViewMatrix = newMatrix;
}

- (void) rotate:(vec2)v
{
    mat4 rm = mat4::rotationYX(v.y, v.x);
    const mat4& mvm = self.modelViewMatrix;
    
    mat4 newMatrix = mvm * rm;
    self.modelViewMatrix = newMatrix;
}

- (void) scale:(vec3)v
{
    mat4 sm = mat4::scale(v);
    const mat4& mvm = self.modelViewMatrix;
    
    mat4 newMatrix = mvm * sm;
    self.modelViewMatrix = newMatrix;
}

#pragma mark - State

- (void) setBackfaceCulling:(BOOL)b
{
	if (_backfaceCulling == b)
        return;
    
    _backfaceCulling = b;
    
    if (_backfaceCulling)
        glEnable(GL_CULL_FACE);
    else
        glDisable(GL_CULL_FACE);
}

#pragma mark - Clearing

- (void) clear
{
    [self clear:TRANSPARENT_BLACK];
}

- (void) clear:(vec4)color
{
    glClearColor(color.x, color.y, color.z, color.w);
    glClear(GL_COLOR_BUFFER_BIT);
}

#pragma mark - Commands

+ (void) flushAll
{
    glBindFramebuffer(UInt32(GL_FRAMEBUFFER), 0);
    glFinish();
}

+ (void) checkForErrors
{
    GLenum error;
    
    do
    {
        error = glGetError();
        SGL_ASSERT(error == GL_NO_ERROR);
    }
    while (error != GL_NO_ERROR);
}

@end
