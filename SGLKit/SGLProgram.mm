//
//  SGLProgram.mm
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLProgram.h"
#import "SGLShader.h"
#import "SGLUniform.h"
#import "SGLVertexAttribute.h"
#import "SGLUtilities.h"
#import "AQDataExtensions.h"
#import "SGLDebug.h"
#import "SGLHeader.h"

static NSMutableDictionary* sharedPrograms = nil;
static NSMutableDictionary* sharedSources = nil;
static NSMutableArray* gOtherBundles = [NSMutableArray array];
static NSMutableArray* gSourcePaths = [NSMutableArray array];
static NSString* gShaderEncryptionPassword = nil;
static BOOL gShouldLoadShadersFromProject = NO;

#ifdef DEBUG
    #define LOAD_SHADERS_FROM_PROJECT
#endif

#pragma mark - Private

@interface SGLProgram ()

@property (nonatomic) unsigned int vertexShader;
@property (nonatomic) unsigned int fragmentShader;

@end

#pragma mark - Public

@implementation SGLProgram

#pragma mark - Configuration

+ (void) registerBundle:(NSBundle*)bundle
{
    if ([gOtherBundles containsObject:bundle])
        return;
    
    [gOtherBundles addObject:bundle];
}

+ (void) registerSourcePath:(NSString*)path
{
    if ([gSourcePaths containsObject:path])
        return;
    
    [gSourcePaths addObject:path];
}

+ (void) registerDecryptionPassword:(NSString*)password
{
    SGL_ASSERT(gShaderEncryptionPassword == nil);
    
    gShaderEncryptionPassword = password;
}

#pragma mark - Loading

+ (SGLProgram*) programNamed:(NSString*)name
{
    return [self programNamed:name defines:@[]];
}

+ (SGLProgram*) programNamed:(NSString*)name defines:(NSArray*)defs
{
    if (sharedPrograms == nil)
        sharedPrograms = [[NSMutableDictionary alloc] init];
    
    NSArray* sortedDefs = [defs sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString* key = [name mutableCopy];
    
    for (NSString* def in sortedDefs)
        [key appendFormat:@" %@", def];
    
    SGLProgram* program = sharedPrograms[key];
    
    if (program == nil)
    {
        program = [[SGLProgram alloc] initWithName:name defines:defs];
        sharedPrograms[key] = program;
    }
    
    return program;
}

+ (NSString*) sourceNamed:(NSString*)filename
{
    if (sharedSources == nil)
        sharedSources = [[NSMutableDictionary alloc] init];
    
    NSString* source = sharedSources[filename];
    
    if (source != nil)
        return source;
    
    NSString* name = [filename stringByDeletingPathExtension];
    NSString* extension = [filename pathExtension];
    NSString* encryptedExtension = [extension stringByAppendingString:@"data"];
    
    NSBundle* appBundle = NSBundle.mainBundle;
    NSBundle* sglKitBundle = [NSBundle bundleForClass:[SGLShader class]];
    
    NSString* filepath = nil;
    NSData* data = nil;
    BOOL encrypted = NO;
    
    //
    // Try to load from the project.
    //
    
    #ifdef LOAD_SHADERS_FROM_PROJECT
    
        if (gShouldLoadShadersFromProject)
        {
            for (NSString* path in gSourcePaths)
            {
                filepath = [NSString stringWithFormat:@"%@/%@", path, filename];
                
                data = [NSData dataWithContentsOfURL:[NSURL URLWithString:filepath]];
            
                if (data != nil)
                    break;
                else
                    filepath = nil;
            }
        }
    
    #endif
    
    //
    // Look for an encrypted shader in the app's bundles.
    //
    
    if (gShaderEncryptionPassword != nil)
    {
        if (filepath == nil)
        {
            filepath = [appBundle pathForResource:name ofType:encryptedExtension];
            
            if (filepath == nil)
            {
                for (NSBundle* bundle in gOtherBundles)
                {
                    filepath = [bundle pathForResource:name ofType:encryptedExtension];
                    
                    if (filepath != nil)
                        break;
                }
            }
            
            if (filepath == nil)
                filepath = [sglKitBundle pathForResource:name ofType:encryptedExtension];
        
            encrypted = (filepath != nil);
        }
    }
    
    //
    // Look for a plain shader in the app's bundles.
    //
    
    if (filepath == nil)
    {
        filepath = [appBundle pathForResource:name ofType:extension];
        
        if (filepath == nil)
        {
            for (NSBundle* bundle in gOtherBundles)
            {
                filepath = [bundle pathForResource:name ofType:extension];
                
                if (filepath != nil)
                    break;
            }
        }
        
        if (filepath == nil)
            filepath = [sglKitBundle pathForResource:name ofType:extension];
    }
    
    //
    // 
    //
    
    if (filepath != nil && data == nil)
        data = [NSData dataWithContentsOfFile:filepath];
    
    if (encrypted)
    {
        SGL_ASSERT(gShaderEncryptionPassword != nil);
        data = [data dataDecryptedWithPassword:gShaderEncryptionPassword];
    }
    
    if (data == nil || data.length == 0)
    {
        SGL_ASSERT(false);
        NSLog(@"The shader %@.%@ could not be loaded.", name, extension);
    }
    
    source = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //
    // Merge included files.
    //
    
    NSRange scanRange = NSMakeRange(0, source.length);
    
    NSMutableString* mergedSource = [NSMutableString string];
    
    NSCharacterSet* angleBrackets = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    
    while (YES)
    {
        NSRange matchRange = [source rangeOfString:@"#include" options:0 range:scanRange];
        
        if (matchRange.location != NSNotFound)
        {
            NSRange lineRange = [source lineRangeForRange:matchRange];
            
            NSRange previousRange = NSMakeRange(scanRange.location, lineRange.location - scanRange.location);
            NSString* previous = [source substringWithRange:previousRange];
            [mergedSource appendString:previous];
            
            NSString* line = [source substringWithRange:lineRange];
            NSArray* components = [line componentsSeparatedByCharactersInSet:angleBrackets];
            
            if (components.count != 3)
            {
                components = [line componentsSeparatedByString:@"\""];
                
                if (components.count != 3)
                {
                    NSLog(@"Badly formed directive: %@", line);
                    return nil;
                }
            }
            
            NSString* includeName = components[1];
            NSString* includeSource = [SGLProgram sourceNamed:includeName];
            [mergedSource appendString:includeSource];
            
            scanRange.location = lineRange.location + lineRange.length;
            scanRange.length = source.length - scanRange.location;
        }
        else
        {
            NSString* remainder = [source substringWithRange:scanRange];
            [mergedSource appendString:remainder];
            break;
        }
    }
    
    sharedSources[filename] = mergedSource;
    
    return mergedSource;
}

#pragma mark - Creation

- (id) initWithName:(NSString*)name
{
    return [self initWithName:name defines:@[]];
}

- (id) initWithName:(NSString*)name defines:(NSArray*)defs
{
    self = [super init];
    
    _name = name;
    _defines = [defs mutableCopy];
    _positionLoc = -1;
    _normalLoc = -1;
    _colorLoc = -1;
    _texCoordLoc = -1;
    
    [self reload];
    
    return self;
}

+ (void) reloadAll
{
    [sharedSources removeAllObjects];
    
    gShouldLoadShadersFromProject = YES;
    
    for (SGLProgram* program in sharedPrograms.allValues)
        [program reload];
}

- (void) reload
{
    NSString* vertName = [self.name stringByAppendingPathExtension:@"vert"];
    NSString* fragName = [self.name stringByAppendingPathExtension:@"frag"];
    
    self.vertexSource = [SGLProgram sourceNamed:vertName];
    self.fragmentSource = [SGLProgram sourceNamed:fragName];
    
    [self compile];
}

- (void) activate
{
    SGL_ASSERT(glIsProgram(_glName));
    glUseProgram(_glName);
}

#pragma mark - Destruction

- (void) dealloc
{
    glDeleteShader(_vertexShader);
    glDeleteShader(_fragmentShader);
    glDeleteProgram(_glName);
}

+ (void) deleteAll
{
    [sharedPrograms removeAllObjects];
}

#pragma mark - Compilation

- (void) compile
{
    [self compileVertexSource];
    [self compileFragmentSource];
    [self link];
    [self createUniforms];
}

- (void) compileVertexSource
{
    self.vertexShader = [self compileSource:_vertexSource defines:_defines type:GL_VERTEX_SHADER];
}

- (void) compileFragmentSource
{
    self.fragmentShader = [self compileSource:_fragmentSource defines:_defines type:GL_FRAGMENT_SHADER];
}

- (GLuint) compileSource:(NSString*)source defines:(NSArray*)defines type:(GLenum)theType
{
    NSMutableString* header = [NSMutableString string];
    
    for (NSString* symbol in defines)
        [header appendFormat:@"#define %@\n", symbol];
    
    const GLchar* headerSource = (GLchar*)[header UTF8String];
    GLint headerLength = (GLint)strlen(headerSource);
    
    const GLchar* mainSource = [source UTF8String];
    GLint mainLength = (GLint)strlen(mainSource);
    
    std::vector<const GLchar*> sources;
    std::vector<GLint> lengths;
    
    if (headerSource != NULL && headerLength > 0)
    {
        sources.push_back(headerSource);
        
        lengths.push_back(headerLength);
    }
    
    sources.push_back(mainSource);
    lengths.push_back(mainLength);
    
    GLuint shader = glCreateShader(theType);
    glShaderSource(shader, (GLsizei)sources.size(), &sources[0], &lengths[0]);
    
    int compileStatus;
    glCompileShader(shader);
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compileStatus);
    
    int infoLogLength;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLogLength);
    
    NSString* typeName = (theType == GL_VERTEX_SHADER) ? @"vert" : @"frag";
    
    if (compileStatus == 0)
        NSLog(@"Shader %@.%@ failed to compile!", self.name, typeName);
    
    #ifdef DEBUG
        
        if (infoLogLength > 0)
        {
            NSLog(@"Shader %@.%@ compile info:", self.name, typeName);
            char infoLog[2048];
            glGetShaderInfoLog(shader, 2048, NULL, infoLog);
            printf("%s", infoLog);
        }
        
    #endif
    
    return shader;
}

#pragma mark - Linking

- (BOOL) link
{
    _glName = glCreateProgram();
    SGL_ASSERT(glIsProgram(_glName));
    
    glAttachShader(_glName, _vertexShader);
    glAttachShader(_glName, _fragmentShader);
    
    glBindAttribLocation(_glName, POSITIONS,  "position");
    glBindAttribLocation(_glName, NORMALS,    "normal");
    glBindAttribLocation(_glName, RGBACOLORS, "color");
    glBindAttribLocation(_glName, TEXCOORDS,  "texCoord");
    
    glLinkProgram(_glName);
    
    int linkStatus;
    int infoLogLength;
    glGetProgramiv(_glName, GL_LINK_STATUS, &linkStatus);
    glGetProgramiv(_glName, GL_INFO_LOG_LENGTH, &infoLogLength);
    
    if (linkStatus == 0)
        NSLog(@"Shader %@ failed to link!", self.name);
    
    #ifdef DEBUG
    
        if (infoLogLength > 0)
        {
            NSLog(@"Shader %@ link info:", self.name);
            char infoLog[2048];
            glGetProgramInfoLog(_glName, 2048, NULL, infoLog);
            printf("%s", infoLog);
        }
        
    #endif
    
    _positionLoc = glGetAttribLocation(_glName, "position");
    _normalLoc   = glGetAttribLocation(_glName, "normal");
    _colorLoc    = glGetAttribLocation(_glName, "color");
    _texCoordLoc = glGetAttribLocation(_glName, "texCoord");
    
    SGL_ASSERT(_positionLoc != -1);
    
    return (linkStatus > 0);
}

- (void) validate
{
    glValidateProgram(_glName);
    
    int validateStatus;
    int infoLogLength;
    glGetProgramiv(_glName, GL_VALIDATE_STATUS, &validateStatus);
    glGetProgramiv(_glName, GL_INFO_LOG_LENGTH, &infoLogLength);
    
    if (validateStatus == 0)
        NSLog(@"Shader %@ failed to validate!", _name);
    
    #ifdef DEBUG
    
        if (infoLogLength > 0)
        {
            NSLog(@"Shader %@ validation info:", _name);
            char infoLog[2048];
            glGetProgramInfoLog(_glName, 2048, NULL, infoLog);
            printf("%s", infoLog);
        }
    
    #endif
}

- (void) createUniforms
{
    NSMutableDictionary* newUniforms = [NSMutableDictionary dictionary];
    
    GLint uniformCount;
    glGetProgramiv(_glName, GL_ACTIVE_UNIFORMS, &uniformCount);
    
    for (GLint i = 0; i < uniformCount; i++)
    {
        int size;
        unsigned int type;
        char nameBuffer[256];
        glGetActiveUniform(_glName, GLuint(i), 256, NULL, &size, &type, nameBuffer);
        
        NSString* uniformName = @(nameBuffer);
        
        int location = glGetUniformLocation(_glName, nameBuffer);
        if (location < 0)
            continue;
        
        Class UniformClass = [SGLUniform class];
        
        switch (type)
        {
            case GL_FLOAT:        UniformClass = [SGLFloatUniform   class]; break;
            case GL_FLOAT_VEC2:   UniformClass = [SGLVec2Uniform    class]; break;
            case GL_FLOAT_VEC3:   UniformClass = [SGLVec3Uniform    class]; break;
            case GL_FLOAT_VEC4:   UniformClass = [SGLVec4Uniform    class]; break;
            case GL_FLOAT_MAT3:   UniformClass = [SGLMat3Uniform    class]; break;
            case GL_FLOAT_MAT4:   UniformClass = [SGLMat4Uniform    class]; break;
            case GL_SAMPLER_2D:   UniformClass = [SGLTextureUniform class]; break;
            case GL_SAMPLER_CUBE: UniformClass = [SGLTextureUniform class]; break;
                
            default:
                SGL_ASSERT(false);
        }
        
        newUniforms[uniformName] = [[UniformClass alloc] initWithName:uniformName location:location];
    }
    
    self.uniforms = newUniforms;
}

@end
