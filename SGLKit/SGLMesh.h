//
//  SGLMesh.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLVertexBuffer.h"
#import "SGLIndexBuffer.h"

enum MeshMode
{
    MeshMode_Triangles,
    MeshMode_Lines
};


@interface SGLMesh : NSObject

- (id) initWithMode:(MeshMode)mode
         vertexData:(GLfloat*)vertexData
   vertexAttributes:(SGLVertexAttributeList)attributes
        vertexCount:(size_t)vertexCount
          indexData:(GLushort*)indexData
         indexCount:(size_t)indexCount;

/*
- (id) initWithPositions:(GLfloat*)positions
                 normals:(GLfloat*)normals
             vertexCount:(size_t)vertexCount
                 indices:(GLushort*)indices
              indexCount:(size_t)indexCount;
*/

- (void) render;

@property (nonatomic) GLint glMode;
@property (nonatomic) BOOL hasNormals;
@property (nonatomic) BOOL hasColors;
@property (nonatomic) BOOL hasTexCoords;

@end
