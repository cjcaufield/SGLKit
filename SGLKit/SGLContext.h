//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLMath.h"
#import "SGLShader.h"
#import "SGLTexture.h"

//
// GLContext
//

@interface SGLContext : NSObject

@property (nonatomic, strong) SGLShader* basicShader;
@property (nonatomic, strong) SGLShader* currentShader;
@property (nonatomic) BOOL backfaceCulling;

- (id) initWithCocoaContext:(id)context;
- (void) activate;
- (void) push;
- (void) pop;
- (void) loadIdentity;
- (void) translate:(vec3)translation;
- (void) rotate:(vec2)rotation;
- (void) scale:(vec3)scale;
- (void) clear;
- (void) clear:(vec4)color;
- (const mat4) modelViewMatrix;
- (void) setModelViewMatrix:(const mat4)matrix;

+ (void) lockGL;
+ (void) unlockGL;
+ (void) flushAll;
+ (void) checkForErrors;

@end
