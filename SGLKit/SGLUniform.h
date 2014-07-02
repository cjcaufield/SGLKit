//
//  SGLUniform.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLHeader.h"
#import "SGLMath.h"

@class SGLTexture;


@interface SGLUniform : NSObject <NSCopying>

@property (copy) NSString* name;
@property GLint location;
@property int modificationCount;

- (id) initWithName:(NSString*)name location:(int)location;
- (void) copyValueFrom:(SGLUniform*)other;
- (void) bind;
- (NSString*) description;

@end


@interface SGLFloatUniform : SGLUniform

@property (nonatomic) float value;

@end


@interface SGLVec2Uniform : SGLUniform
{
    float value[2];
}

@property (nonatomic) vec2 value;

@end


@interface SGLVec3Uniform : SGLUniform
{
    float value[3];
}

@property (nonatomic) vec3 value;

@end


@interface SGLVec4Uniform : SGLUniform
{
    float value[4];
}

@property (nonatomic) vec4 value;

@end


@interface SGLMat3Uniform : SGLUniform
{
    float value[9];
}

@property (nonatomic) mat3 value;

@end


@interface SGLMat4Uniform : SGLUniform
{
    float value[16];
}

@property (nonatomic) mat4 value;

@end


@interface SGLTextureUniform : SGLUniform
{
    SGLTexture* value;
}

@property (nonatomic, strong) SGLTexture* value;

@end
