//
//  SGLShader.mm
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLShader.h"
#import "SGLProgram.h"
#import "SGLUniform.h"
#import "SGLTexture.h"
#import "SGLUtilities.h"
#import "SGLDebug.h"
#import "SGLHeader.h"

static NSMutableArray* gAllShaders = nil;

static __weak SGLShader* gCurrentShader = nil;

@interface SGLShader ()

@property (nonatomic, strong) NSMutableDictionary* uniforms;
@property (nonatomic) int activationCount;

@end


@implementation SGLShader

+ (void) deactivateAll
{
    gCurrentShader = nil;
    
    glUseProgram(0);
}

+ (void) reloadAll
{
    [SGLProgram reloadAll];
    
    for (NSValue* value in gAllShaders)
    {
        SGLShader* shader = [value nonretainedObjectValue];
        [shader reloadUniforms];
    }
}

+ (void) deleteAll
{
    [gAllShaders removeAllObjects];
}

+ (SGLShader*) currentShader
{
    return gCurrentShader;
}

- (void) recompile
{
    self.program = [SGLProgram programNamed:self.name defines:self.defines];
    
    [self reloadUniforms];
}

- (id) initWithName:(NSString*)name
{
	if (gAllShaders == nil)
        gAllShaders = [NSMutableArray array];
    
    self = [super init];
    
    _name = name;
    _program = [SGLProgram programNamed:name];
    _defines = [NSMutableArray array];
	
    [self reloadUniforms];
    
    NSValue* value = [NSValue valueWithNonretainedObject:self];
    [gAllShaders addObject:value];
    
    return self;
}

- (void) dealloc
{
    if (gCurrentShader == self)
        gCurrentShader = nil;
    
    NSValue* value = [NSValue valueWithNonretainedObject:self];
    [gAllShaders removeObject:value];
}

- (void) activate
{
    gCurrentShader = self;
    
    [self.program activate];
    
    // Useful for logging the initial state of a shader.
    //if (activationCount == 0)
    //    NSLog(@"%@", self.description);
    
    [_uniforms.allValues makeObjectsPerformSelector:@selector(bind)];
    
    _activationCount++;
}

- (void) setFloat:(float)value forName:(NSString*)aName
{
    SGLFloatUniform* uniform = [self uniformForName:aName];
    
    if (uniform == nil)
    {
        uniform = [[SGLFloatUniform alloc] initWithName:aName location:-1];
        _uniforms[aName] = uniform;
    }
    
    [uniform setValue:value];
}

- (void) setVec2:(vec2)value forName:(NSString*)aName
{
    SGLVec2Uniform* uniform = [self uniformForName:aName];
    
    if (uniform == nil)
    {
        uniform = [[SGLVec2Uniform alloc] initWithName:aName location:-1];
        _uniforms[aName] = uniform;
    }
    
    [uniform setValue:value];
}

- (void) setVec3:(vec3)value forName:(NSString*)aName
{
    SGLVec3Uniform* uniform = [self uniformForName:aName];
    
    if (uniform == nil)
    {
        uniform = [[SGLVec3Uniform alloc] initWithName:aName location:-1];
        _uniforms[aName] = uniform;
    }
    
    [uniform setValue:value];
}

- (void) setVec4:(vec4)value forName:(NSString*)aName
{
    SGLVec4Uniform* uniform = [self uniformForName:aName];
    
    if (uniform == nil)
    {
        uniform = [[SGLVec4Uniform alloc] initWithName:aName location:-1];
        _uniforms[aName] = uniform;
    }
    
    [uniform setValue:value];
}

- (void) setMat3:(mat3)value forName:(NSString*)aName
{
    SGLMat3Uniform* uniform = [self uniformForName:aName];
    
    if (uniform == nil)
    {
        uniform = [[SGLMat3Uniform alloc] initWithName:aName location:-1];
        _uniforms[aName] = uniform;
    }
    
    [uniform setValue:value];
}

- (void) setMat4:(mat4)value forName:(NSString*)aName
{
    SGLMat4Uniform* uniform = [self uniformForName:aName];
    
    if (uniform == nil)
    {
        uniform = [[SGLMat4Uniform alloc] initWithName:aName location:-1];
        _uniforms[aName] = uniform;
    }
    
    [uniform setValue:value];
}

- (void) setBool:(BOOL)value forName:(NSString*)aName
{
    [self setFloat:(value) ? 1.0f : 0.0f forName:aName];
}

- (void) setInt:(int)value forName:(NSString*)aName
{
    [self setFloat:float(value) forName:aName];
}

- (void) setIVec2:(ivec2)value forName:(NSString*)aName
{
    [self setVec2:vec2(value) forName:aName];
}

- (void) setTexture:(SGLTexture*)tex forName:(NSString*)aName
{
    SGLTextureUniform* uniform = [self uniformForName:aName];
    
    if (uniform == nil)
    {
        uniform = [[SGLTextureUniform alloc] initWithName:aName location:-1];
        _uniforms[aName] = uniform;
    }
    
    [uniform setValue:tex];
}

- (void) reloadUniforms
{
    NSMutableDictionary* newUniforms = [[NSMutableDictionary alloc] initWithDictionary:_program.uniforms copyItems:YES];
    
    for (NSString* uniformName in _uniforms.allKeys)
    {
        SGLUniform* oldUniform = _uniforms[uniformName];
        SGLUniform* newUniform = newUniforms[uniformName];
        
        if (newUniform != nil)
        {
            [newUniform copyValueFrom:oldUniform];
        }
        else
        {
            newUniform = [oldUniform copy];
            newUniform.location = -1;
            newUniforms[uniformName] = newUniform;
        }
    }
    
    self.uniforms = newUniforms;
}

- (id) uniformForName:(NSString*)uniformName
{
    SGLUniform* uniform = _uniforms[uniformName];

    // Useful for catching attempts to set non-existent uniforms.
    //if (activationCount == 0)
    //    if (uniform == nil)
    //        NSLog(@"Uniform %@.%@ doesn't exist.", name, uniformName);
    
    return uniform;
}

- (NSString*) description
{
    NSMutableString* str = [NSMutableString string];
    [str appendFormat:@"%@:\n", self.name];
    
    for (SGLUniform* uniform in _uniforms.allValues)
        [str appendFormat:@"  %@ = %@\n", uniform.name, uniform.description];
    
    return str;
}

@end
