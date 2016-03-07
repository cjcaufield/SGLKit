//
//  View.h
//  SGLKitTest
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import <SGLKit/SGLMacSceneView.h>

@class SGLMesh, SGLShader;


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


@interface View : SGLMacSceneView

@property (nonatomic) enum Shape shape;
@property (nonatomic, strong) SGLMesh* cubeMesh;
@property (nonatomic, strong) SGLShader* cubeShader;

- (IBAction) changeShape:(id)sender;

@end
