//
//  ViewController.mm
//  SGLKitTouchTest
//
//  Created by Colin Caufield on 2014-05-02.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "ViewController.h"
#import <SGLKit/SGLIosSceneView.h>
#import <SGLKit/SGLScene.h>
#import <SGLKit/SGLContext.h>
#import <SGLKit/SGLShader.h>
#import <SGLKit/SGLMeshes.h>
#import <SGLKit/SGLMesh.h>

@implementation ViewController

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void) setupGL
{
    [super setupGL];
    
    _shape = CUBE;
    
    _shader = [[SGLShader alloc] initWithName:@"Basic"];
    [_shader setVec4:vec4(vec3(0.5), 1.0) forName:@"color"];
    [_shader setFloat:32.0 forName:@"shininess"];
    [[(id)[self view] scene] addSceneShader:_shader];
    
    _axiiMesh = [SGLMeshes axiiMesh];
    _cubeMesh = [SGLMeshes cubeMesh];
}

- (void) tearDownGL
{
    [super tearDownGL];
}

- (void) render
{
    [self.context clear:OPAQUE_BLACK];
    
    [_shader activate];
    
    switch (_shape)
    {
        case AXII:
            break;
            
        case CUBE:
            [_shader activate];
            [_cubeMesh render];
            break;
            
        default:
            SGL_NOTHING;
    }
    
    // CJC: hack to still show axes with render method override.
    SGLScene* scene = [(id)[self view] scene];
    if (scene.showAxes)
        [scene renderAxes];
}

- (IBAction) changeShape:(id)sender
{
    _shape = (Shape)[sender tag];
}

@end
