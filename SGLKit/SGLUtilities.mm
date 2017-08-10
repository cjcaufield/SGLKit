//
//  SGLUtilities.mm
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#import "SGLUtilities.h"
#import "SGLMeshes.h"
#import "SGLShader.h"
#import "SGLDebug.h"
#import "SGLHeader.h"

@implementation SGLUtilities

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

#ifdef SGL_MAC

    + (void) exitGracefullyWithMessage:(NSString*)message
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

+ (void) swapTexture:(__strong SGLTexture**)tex1 with:(__strong SGLTexture**)tex2
{
    SGLTexture* tempTex = *tex1;
    *tex1 = *tex2;
    *tex2 = tempTex;
}

+ (void) drawTexture:(SGLTexture*)tex outputSize:(vec2)outputSize samplingType:(SamplingType)samplingType
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

@end

@implementation NSMutableArray (Unique)

- (void) addObjectIfUnique:(id)object
{
    if ([self containsObject:object] == NO)
        [self addObject:object];
}

@end
