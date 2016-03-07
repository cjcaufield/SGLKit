//
//  View.mm
//  SGLKitTest
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "View.h"
#import <SGLKit/SGLContext.h>
#import <SGLKit/SGLScene.h>
#import <SGLKit/SGLMeshes.h>

@implementation View

- (id) initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    _shape = CUBE;
    
    return self;
}

- (id) initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    
    _shape = CUBE;
    
    return self;
}

- (void) openGLWasPrepared
{
    [super openGLWasPrepared];
    
    self.userControlsCamera = YES;
    self.scene.clearColor = OPAQUE_BLACK;
    self.scene.showAxes = YES;
    self.scene.objectDistance = 4000.0;
    
    vec4 color = { 0.5, 0.5, 0.5, 1.0 };
    
    _cubeShader = [[SGLShader alloc] initWithName:@"Basic"];
    [_cubeShader setVec4:color forName:@"color"];
    [_cubeShader setFloat:32.0 forName:@"shininess"];
    [self.scene addSceneShader:_cubeShader];
    
    _cubeMesh = [SGLMeshes cubeMesh];
}

- (void) render
{
    [super render];
    
    switch (_shape)
    {
        case AXII:
            break;
            
        case CUBE:
            [_cubeShader activate];
            [_cubeMesh render];
            break;
        
        default:
            SGL_NOTHING;
    }
}

- (IBAction) changeShape:(id)sender
{
    _shape = [sender tag];
    
    [self.window.windowController synchronizeWindowTitleWithDocumentName];
}

@end
