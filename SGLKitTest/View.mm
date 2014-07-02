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

- (void) openGLWasPrepared
{
    [super openGLWasPrepared];
    
    self.userControlsCamera = YES;
    self.scene.clearColor = OPAQUE_BLACK;
    self.scene.showAxes = YES;
    self.scene.objectDistance = 4000.0;
    
    _shader = [[SGLShader alloc] initWithName:@"Basic"];
    [_shader setVec4:vec4(vec3(0.5), 1.0) forName:@"color"];
    [_shader setFloat:32.0 forName:@"shininess"];
    [self.scene addSceneShader:_shader];
    
    _axiiMesh = [SGLMeshes axiiMesh];
    _cubeMesh = [SGLMeshes cubeMesh];
}

- (void) render
{
    [super render];
    
    [_shader activate];
    
    switch (_shape)
    {
        case AXII:
            [_axiiMesh render];
            break;
            
        case CUBE:
            [_shader activate];
            [_cubeMesh render];
            break;
        
        default:
            SGL_NOTHING;
    }
}

- (IBAction) changeShape:(id)sender
{
    _shape = (Shape)[sender tag];
    
    [self.window.windowController synchronizeWindowTitleWithDocumentName];
}

@end
