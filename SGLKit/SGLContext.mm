//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#import "SGLContext.h"
#import "SGLProgram.h"
#import "SGLTexture.h"
#import "SGLUtilities.h"
#import "SGLHeader.h"

#ifdef SGL_MAC
    #import <GLUT/GLUT.h>
#endif

static NSRecursiveLock* glLock = nil;


@interface SGLContext ()

@property (nonatomic, strong) id cocoaContext;
@property (nonatomic) std::vector<mat4> modelViewStack;

@end


@implementation SGLContext

+ (void) initialize
{
    //NSLog(@"SGLKit D");
          
    #ifdef DEBUG
        NSLog(@"SGLKit running in DEBUG mode.");
    #else
        NSLog(@"SGLKit running in RELEASE mode.");
    #endif
    
    glLock = [[NSRecursiveLock alloc] init];
    
    #ifdef SGL_MAC
    
        NSBundle* sglResourcesBundle = [NSBundle bundleForClass:[self class]];
        NSString* sglResourcesBundlePath = sglResourcesBundle.resourcePath;
        NSString* sglSourcePath = @"file:///Users/colin/Work/SGLKit/SGLKit";
    
    #endif
    
    #ifdef SGL_IOS
    
        NSString* sglResourcesBundlePath = [NSBundle.mainBundle pathForResource:@"SGLKitResources" ofType:@"bundle"];
        NSBundle* sglResourcesBundle = [NSBundle bundleWithPath:sglResourcesBundlePath];
        NSString* sglSourcePath = @"http://MacBookPro.local/~colin/SGLKit"; // CJC revisit
    
    #endif
    
    NSLog(@"SGLKit path: %@", sglResourcesBundle.bundlePath);
    NSLog(@"SGLKit resources path: %@", sglResourcesBundlePath);
    
    [SGLProgram registerSourcePath:sglSourcePath];
    [SGLProgram registerResourceBundle:sglResourcesBundle];
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

+ (void) lockGL
{
    SGL_ASSERT(glLock != nil);
    [glLock lock];
}

+ (void) unlockGL
{
    SGL_ASSERT(glLock != nil);
    [glLock unlock];
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

- (const mat4&) modelViewMatrix
{   
    return _modelViewStack.back();
}

- (void) setModelViewMatrix:(const mat4&)matrix
{
    _modelViewStack.back() = matrix;
}

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

- (void) activate
{
    #ifdef SGL_MAC
        [self.cocoaContext makeCurrentContext];
    #endif
    #ifdef SGL_IOS
        EAGLContext.currentContext = self.cocoaContext;
    #endif
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

- (void) clear
{
    [self clear:TRANSPARENT_BLACK];
}

- (void) clear:(vec4)color
{
    glClearColor(color.x, color.y, color.z, color.w);
    glClear(GL_COLOR_BUFFER_BIT);
}

@end
