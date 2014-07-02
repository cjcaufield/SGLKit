//
//  SGLShader.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLMath.h"

@class SGLProgram, SGLTexture;


@interface SGLShader : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) SGLProgram* program;
@property (nonatomic, strong) NSMutableArray* defines;

- (id) initWithName:(NSString*)name;
- (void) activate;
+ (void) deactivateAll;
+ (void) reloadAll;
+ (void) deleteAll;
+ (SGLShader*) currentShader;
- (void) recompile;
- (id) uniformForName:(NSString*)uniformName;
- (void) setFloat:(float)value forName:(NSString*)name;
- (void) setVec2:(vec2)value forName:(NSString*)name;
- (void) setVec3:(vec3)value forName:(NSString*)name;
- (void) setVec4:(vec4)value forName:(NSString*)name;
- (void) setMat3:(mat3)value forName:(NSString*)name;
- (void) setMat4:(mat4)value forName:(NSString*)name;
- (void) setBool:(BOOL)value forName:(NSString*)name;
- (void) setInt:(int)value forName:(NSString*)name;
- (void) setIVec2:(ivec2)value forName:(NSString*)name;
- (void) setTexture:(SGLTexture*)tex forName:(NSString*)name;

@end
