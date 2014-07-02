//
//  SGLUtilities.mm
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#import "SGLUtilities.h"
#import "SGLMeshes.h"
#import "SGLShader.h"
#import "SGLDebug.h"
#import "SGLHeader.h"

void SGLCheckForErrors()
{
    GLenum error;
    
    do
    {
        error = glGetError();
        SGL_ASSERT(error == GL_NO_ERROR);
    }
    while (error != GL_NO_ERROR);
}

#ifdef SGL_MAC

    void ExitGracefully(NSString* message)
    {
        NSLog(@"%@", message);
        
        NSString* appName = [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        
        NSAlert* alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"%@ must quit.", appName]
                                         defaultButton:nil
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:@"%@", message];
        
        [alert performSelectorOnMainThread:@selector(runModal) withObject:nil waitUntilDone:YES];
        
        [NSApp terminate:nil];
    }

#endif

void SwapTextures(__strong SGLTexture** tex1, __strong SGLTexture** tex2)
{
    SGLTexture* tempTex = *tex1;
    *tex1 = *tex2;
    *tex2 = tempTex;
}

void DrawTexture(SGLTexture* tex, vec2 outputSize, SamplingType samplingType)
{
    if (tex == nil)
        return;
    
    static SGLMesh* quadMeshWithTexCoords = nil;
    static SGLShader* drawPixelsShader = nil;
    
    if (quadMeshWithTexCoords == nil)
        quadMeshWithTexCoords = [SGLMeshes quadMeshWithTexCoords];
    
    if (drawPixelsShader == nil)
        drawPixelsShader = [[SGLShader alloc] initWithName:@"CopyPixels"];
    
    // For now, require the texture to be the same size as the output.  Follow up: why?
    //SGL_ASSERT(tex.size == outputSize);
    
    SamplingType oldSamplingType = tex.samplingType;
    tex.samplingType = samplingType;
    [tex activate];
    
    [drawPixelsShader setTexture:tex forName:@"tex"];
    [drawPixelsShader setVec2:tex.size forName:@"texSize"];
    [drawPixelsShader setVec2:outputSize forName:@"outputSize"];
    [drawPixelsShader setFloat:1.0 forName:@"alpha"];
    [drawPixelsShader activate];
    
    [quadMeshWithTexCoords render];
    
    tex.samplingType = oldSamplingType;
}

NSArray* Vec3ToArray(vec3 v)
{
    id nx = @(v.x);
    id ny = @(v.y);
    id nz = @(v.z);
    
    return @[nx, ny, nz, @1.0f];
}

vec3 ArrayToVec3(NSArray* array)
{
    float r = [array[0] floatValue];
    float g = [array[1] floatValue];
    float b = [array[2] floatValue];
    
    return vec3(r, g, b);
}

XXColor* Vec3ToColor(vec3 v)
{
	return Vec4ToColor(vec4(v, 1.0)); // Always full alpha.
}

vec3 ColorToVec3(XXColor* color)
{
	vec4 v = ColorToVec4(color);
	return vec3(v.x, v.y, v.z);
}

XXColor* Vec4ToColor(vec4 v)
{
    return [XXColor colorWithRed:v.x green:v.y blue:v.z alpha:v.w];
}

vec4 ColorToVec4(XXColor* color)
{
    if (color == nil)
        return TRANSPARENT_BLACK;
    
    CGFloat r, g, b, a;
    CGColorRef cgColor = color.CGColor;
    size_t componentCount = CGColorGetNumberOfComponents(cgColor);
    const CGFloat* components = CGColorGetComponents(cgColor);
    
    switch (componentCount)
    {
        case 2:
            r = g = b = components[0];
            a = components[1];
            break;
            
        case 4:
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
            break;
            
        default:
            return TRANSPARENT_BLACK;
    }
    
    return vec4(r, g, b, a);
}

CGPoint Vec2ToPoint(vec2 vec)
{
    return CGPointMake(vec.x, vec.y);
}

vec2 PointToVec2(CGPoint point)
{
    return vec2(point.x, point.y);
}

CGPoint IVec2ToPoint(ivec2 vec)
{
    return Vec2ToPoint(vec2(vec));
}

ivec2 PointToIVec2(CGPoint size)
{
    return ivec2(PointToVec2(size));
}

CGSize Vec2ToSize(vec2 vec)
{
    return CGSizeMake(vec.x, vec.y);
}

vec2 SizeToVec2(CGSize size)
{
    return vec2(size.width, size.height);
}

CGSize IVec2ToSize(ivec2 vec)
{
    return Vec2ToSize(vec2(vec));
}

ivec2 SizeToIVec2(CGSize size)
{
    return ivec2(SizeToVec2(size));
}

@implementation NSMutableArray (Unique)

- (void) addObjectIfUnique:(id)object
{
    if ([self containsObject:object] == NO)
        [self addObject:object];
}

@end
