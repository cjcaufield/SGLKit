//
//  SGLMeshes.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLMesh.h"


@interface SGLMeshes : NSObject

+ (SGLMesh*) quadMesh;
+ (SGLMesh*) quadMeshWithNormals;
+ (SGLMesh*) quadMeshWithTexCoords;
+ (SGLMesh*) quadMeshWithNormalsAndTexCoords;
+ (SGLMesh*) cubeMesh;
+ (SGLMesh*) axiiMesh;
+ (SGLMesh*) lineMesh;

@end
