//
//  ViewController.h
//  SGLKitTouchTest
//
//  Created by Colin Caufield on 2014-05-02.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <SGLKit/SGLIosViewController.h>
#import <SGLKit/SGLMath.h>

@class SGLShader, SGLMesh;

enum Shape
{
    SPHERE = 0,
    TORUS = 1,
    CONE = 2,
    AXII = 3,
    TETRAHEDRON = 4,
    CUBE = 6,
    OCTAHEDRON = 8,
    DODECAHEDRON = 12,
    ICOSAHEDRON = 20,
    TEAPOT = 100
};

@interface ViewController : SGLIosViewController

@property (nonatomic) Shape shape;
@property (nonatomic, strong) SGLShader* shader;
@property (nonatomic, strong) SGLMesh* axiiMesh;
@property (nonatomic, strong) SGLMesh* cubeMesh;

- (IBAction) changeShape:(id)sender;

@end
