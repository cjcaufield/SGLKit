//
//  SGLUniform.mm
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLUniform.h"
#import "SGLShader.h"
#import "SGLProgram.h"
#import "SGLTexture.h"
#import "SGLUtilities.h"
#import "SGLDebug.h"
#import "SGLHeader.h"


@implementation SGLUniform

- (id) init
{
    SGL_ASSERT(false);
    return nil;
}

- (id) initWithName:(NSString*)name location:(int)location
{
    self = [super init];
    
    _name = [name copy];
    _location = location;
    
    return self;
}

- (void) dealloc
{
    //NSLog(@"%@ dealloc: %@ (%d)", NSStringFromClass([self class]), self.name, self.location);
}

- (void) bind
{
    // abstract
    SGL_ASSERT(false);
}

- (id) copyWithZone:(NSZone*)zone
{
    return [[[self class] allocWithZone:zone] initWithName:self.name location:self.location];
}

- (void) copyValueFrom:(SGLUniform*)other
{
    // abstract
    SGL_ASSERT(false);
}

- (NSString*) description
{
    // abstract
    SGL_ASSERT(false);
    return @"";
}

@end


@implementation SGLFloatUniform

- (void) setValue:(float)f
{
    _value = f;
    self.modificationCount++;
}

- (void) bind
{
    SGL_ASSERT(self.location == glGetUniformLocation(SGLShader.currentShader.program.glName, self.name.UTF8String));
    
    if (self.location >= 0)
        glUniform1f(self.location, _value);
}

- (id) copyWithZone:(NSZone*)zone
{
    SGLFloatUniform* copy = [super copyWithZone:zone];
    copy.value = self.value;
    copy.modificationCount = 0;
    return copy;
}

- (void) copyValueFrom:(SGLFloatUniform*)other
{
    if ([[self class] isEqual:[other class]] == NO)
        return;
    
    self.value = other.value;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%d: %f", self.location, self.value];
}

@end


@implementation SGLVec2Uniform

- (void) bind
{
    SGL_ASSERT(self.location == glGetUniformLocation(SGLShader.currentShader.program.glName, self.name.UTF8String));
    
    if (self.location >= 0)
        glUniform2fv(self.location, 1, value);
}

- (vec2) value
{
    return vec2(value[0], value[1]);
}

- (void) setValue:(vec2)v
{
    value[0] = v.x;
    value[1] = v.y;
    self.modificationCount++;
}

- (id) copyWithZone:(NSZone*)zone
{
    SGLVec2Uniform* copy = [super copyWithZone:zone];
    vec2 myValue = self.value;
    copy.value = myValue;
    copy.modificationCount = 0;
    return copy;
}

- (void) copyValueFrom:(SGLVec2Uniform*)other
{
    if ([[self class] isEqual:[other class]] == NO)
        return;
    
    self.value = other.value;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%d: %f,%f", self.location, value[0], value[1]];
}

@end


@implementation SGLVec3Uniform

- (void) bind
{
    SGL_ASSERT(self.location == glGetUniformLocation(SGLShader.currentShader.program.glName, self.name.UTF8String));
    
    if (self.location >= 0)
        glUniform3fv(self.location, 1, value);
}

- (vec3) value
{
    return vec3(value[0], value[1], value[2]);
}

- (void) setValue:(vec3)v
{
    value[0] = v.x;
    value[1] = v.y;
    value[2] = v.z;
    self.modificationCount++;
}

- (id) copyWithZone:(NSZone*)zone
{
    SGLVec3Uniform* copy = [super copyWithZone:zone];
    vec3 myValue = self.value;
    copy.value = myValue;
    copy.modificationCount = 0;
    return copy;
}

- (void) copyValueFrom:(SGLVec3Uniform*)other
{
    if ([[self class] isEqual:[other class]] == NO)
        return;
    
    self.value = other.value;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%d: %f,%f,%f", self.location, value[0], value[1], value[2]];
}

@end


@implementation SGLVec4Uniform

- (void) bind
{
    SGL_ASSERT(self.location == glGetUniformLocation(SGLShader.currentShader.program.glName, self.name.UTF8String));
    
    if (self.location >= 0)
        glUniform4fv(self.location, 1, value);
}

- (vec4) value
{
    return vec4(value[0], value[1], value[2], value[3]);
}

- (void) setValue:(vec4)v
{
    value[0] = v.x;
    value[1] = v.y;
    value[2] = v.z;
    value[3] = v.w;
    self.modificationCount++;
}

- (id) copyWithZone:(NSZone*)zone
{
    SGLVec4Uniform* copy = [super copyWithZone:zone];
    vec4 myValue = self.value;
    copy.value = myValue;
    copy.modificationCount = 0;
    return copy;
}

- (void) copyValueFrom:(SGLVec4Uniform*)other
{
    if ([[self class] isEqual:[other class]] == NO)
        return;
    
    self.value = other.value;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%d: %f,%f,%f,%f", self.location, value[0], value[1], value[2], value[3]];
}

@end


@implementation SGLMat3Uniform

- (void) bind
{
    SGL_ASSERT(self.location == glGetUniformLocation(SGLShader.currentShader.program.glName, self.name.UTF8String));
    
    if (self.location >= 0)
        glUniformMatrix3fv(self.location, 1, false, value);
}

- (mat3) value
{
    return mat3(value);
}

- (void) setValue:(mat3)m
{
    memcpy(value, m.array(), 9 * sizeof(float));
    self.modificationCount++;
}

- (id) copyWithZone:(NSZone*)zone
{
    SGLMat3Uniform* copy = [super copyWithZone:zone];
    mat3 myValue = self.value;
    copy.value = myValue;
    copy.modificationCount = 0;
    return copy;
}

- (void) copyValueFrom:(SGLMat3Uniform*)other
{
    if ([[self class] isEqual:[other class]] == NO)
        return;
    
    self.value = other.value;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%d: %f,%f,%f\n%f,%f,%f\n%f,%f,%f",
            self.location,
            value[0], value[1], value[2],
            value[3], value[4], value[5],
            value[6], value[7], value[8]];
}

@end


@implementation SGLMat4Uniform

- (void) bind
{
    SGL_ASSERT(self.location == glGetUniformLocation(SGLShader.currentShader.program.glName, self.name.UTF8String));
    
    if (self.location >= 0)
        glUniformMatrix4fv(self.location, 1, false, value);
}

- (mat4) value
{
    return mat4(value);
}

- (void) setValue:(mat4)m
{
    memcpy(value, m.array(), 16 * sizeof(float));
    self.modificationCount++;
}

- (id) copyWithZone:(NSZone*)zone
{
    SGLMat4Uniform* copy = [super copyWithZone:zone];
    mat4 myValue = self.value;
    copy.value = myValue;
    copy.modificationCount = 0;
    return copy;
}

- (void) copyValueFrom:(SGLMat4Uniform*)other
{
    if ([[self class] isEqual:[other class]] == NO)
        return;
    
    self.value = other.value;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%d: %f,%f,%f,%f\n%f,%f,%f,%f\n%f,%f,%f,%f\n%f,%f,%f,%f",
            self.location,
            value[0],  value[1],  value[2],  value[3],
            value[4],  value[5],  value[6],  value[7],
            value[8],  value[9],  value[10], value[11],
            value[12], value[13], value[14], value[15]];
}

@end


@implementation SGLTextureUniform

- (void) bind
{
    #ifdef DEBUG
        int loc = glGetUniformLocation(SGLShader.currentShader.program.glName, self.name.UTF8String);
        SGL_ASSERT(loc == self.location);
    #endif
    
    if (self.location >= 0)
        glUniform1i(self.location, value.sampler);
}

- (SGLTexture*) value
{
    return value;
}

- (void) setValue:(SGLTexture*)tex
{
    //SGL_ASSERT(tex != nil);
    
    value = tex;
    self.modificationCount++;
}

- (id) copyWithZone:(NSZone*)zone
{
    SGLTextureUniform* copy = [super copyWithZone:zone];
    copy.value = self.value;
    copy.modificationCount = 0;
    return copy;
}

- (void) copyValueFrom:(SGLTextureUniform*)other
{
    if ([[self class] isEqual:[other class]] == NO)
        return;
    
    self.value = other.value;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%d: %p", self.location, value];
}

@end
