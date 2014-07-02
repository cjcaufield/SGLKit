//
//  SGLMeshes.mm
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLMeshes.h"
#import "SGLMath.h"
#import "SGLDebug.h"


@implementation SGLMeshes

+ (SGLMesh*) quadMesh
{
    static GLfloat vertexData[] =
    {
        // position.xyz    
        1.0f,  1.0f,  0.0f,
       -1.0f,  1.0f,  0.0f,
        1.0f, -1.0f,  0.0f,
        1.0f, -1.0f,  0.0f,
       -1.0f,  1.0f,  0.0f,
       -1.0f, -1.0f,  0.0f
    };
    
    SGLVertexAttributeList attrs;
    attrs.push_back(POSITIONS);
    
    return [[SGLMesh alloc] initWithMode:MeshMode_Triangles
                              vertexData:vertexData
                        vertexAttributes:attrs
                             vertexCount:sizeof(vertexData) / (sizeof(GLfloat) * 3)
                               indexData:nil
                              indexCount:0];
}

+ (SGLMesh*) quadMeshWithNormals
{
    static GLfloat vertexData[] =
    {
         // position.xyz            // normal.xyz
         1.0f,  1.0f,  0.0f,        0.0f,  0.0f,  1.0f,
        -1.0f,  1.0f,  0.0f,        0.0f,  0.0f,  1.0f,
         1.0f, -1.0f,  0.0f,        0.0f,  0.0f,  1.0f,
         1.0f, -1.0f,  0.0f,        0.0f,  0.0f,  1.0f,
        -1.0f,  1.0f,  0.0f,        0.0f,  0.0f,  1.0f,
        -1.0f, -1.0f,  0.0f,        0.0f,  0.0f,  1.0f
    };
    
    SGLVertexAttributeList attrs;
    attrs.push_back(POSITIONS);
    attrs.push_back(NORMALS);
    
    return [[SGLMesh alloc] initWithMode:MeshMode_Triangles
                              vertexData:vertexData
                        vertexAttributes:attrs
                             vertexCount:sizeof(vertexData) / (sizeof(GLfloat) * 6)
                               indexData:nil
                              indexCount:0];
}

+ (SGLMesh*) quadMeshWithTexCoords
{
    static GLfloat vertexData[] =
    {
        // position.xyz         // texcoord.stp
        1.0f,  1.0f,  0.0f,     1.0f,  1.0f,  0.0f,
       -1.0f,  1.0f,  0.0f,     0.0f,  1.0f,  0.0f,
        1.0f, -1.0f,  0.0f,     1.0f,  0.0f,  0.0f,
        1.0f, -1.0f,  0.0f,     1.0f,  0.0f,  0.0f,
       -1.0f,  1.0f,  0.0f,     0.0f,  1.0f,  0.0f,
       -1.0f, -1.0f,  0.0f,     0.0f,  0.0f,  0.0f
    };
    
    SGLVertexAttributeList attrs;
    attrs.push_back(POSITIONS);
    attrs.push_back(TEXCOORDS);
    
    return [[SGLMesh alloc] initWithMode:MeshMode_Triangles
                              vertexData:vertexData
                        vertexAttributes:attrs
                             vertexCount:sizeof(vertexData) / (sizeof(GLfloat) * 6)
                               indexData:nil
                              indexCount:0];
}

+ (SGLMesh*) quadMeshWithNormalsAndTexCoords
{
    static GLfloat vertexData[] =
    {
        // position.xyz         // normal.xyz           // texcoord.stp
        1.0f,  1.0f,  0.0f,     0.0f,  0.0f,  1.0f,     1.0f,  1.0f,  0.0f,
       -1.0f,  1.0f,  0.0f,     0.0f,  0.0f,  1.0f,     0.0f,  1.0f,  0.0f,
        1.0f, -1.0f,  0.0f,     0.0f,  0.0f,  1.0f,     1.0f,  0.0f,  0.0f,
        1.0f, -1.0f,  0.0f,     0.0f,  0.0f,  1.0f,     1.0f,  0.0f,  0.0f,
       -1.0f,  1.0f,  0.0f,     0.0f,  0.0f,  1.0f,     0.0f,  1.0f,  0.0f,
       -1.0f, -1.0f,  0.0f,     0.0f,  0.0f,  1.0f,     0.0f,  0.0f,  0.0f
    };
    
    SGLVertexAttributeList attrs;
    attrs.push_back(POSITIONS);
    attrs.push_back(NORMALS);
    attrs.push_back(TEXCOORDS);
    
    return [[SGLMesh alloc] initWithMode:MeshMode_Triangles
                              vertexData:vertexData
                        vertexAttributes:attrs
                             vertexCount:sizeof(vertexData) / (sizeof(GLfloat) * 9)
                               indexData:nil
                              indexCount:0];
}

+ (SGLMesh*) cubeMesh
{
    static GLfloat vertexData[] =
    {
         // position.xyz             // normal.xyz
         0.5f, -0.5f, -0.5f,         1.0f,  0.0f,  0.0f,
         0.5f,  0.5f, -0.5f,         1.0f,  0.0f,  0.0f,
         0.5f, -0.5f,  0.5f,         1.0f,  0.0f,  0.0f,
         0.5f, -0.5f,  0.5f,         1.0f,  0.0f,  0.0f,
         0.5f,  0.5f, -0.5f,         1.0f,  0.0f,  0.0f,
         0.5f,  0.5f,  0.5f,         1.0f,  0.0f,  0.0f,
        
         0.5f,  0.5f, -0.5f,         0.0f,  1.0f,  0.0f,
        -0.5f,  0.5f, -0.5f,         0.0f,  1.0f,  0.0f,
         0.5f,  0.5f,  0.5f,         0.0f,  1.0f,  0.0f,
         0.5f,  0.5f,  0.5f,         0.0f,  1.0f,  0.0f,
        -0.5f,  0.5f, -0.5f,         0.0f,  1.0f,  0.0f,
        -0.5f,  0.5f,  0.5f,         0.0f,  1.0f,  0.0f,
        
        -0.5f,  0.5f, -0.5f,        -1.0f,  0.0f,  0.0f,
        -0.5f, -0.5f, -0.5f,        -1.0f,  0.0f,  0.0f,
        -0.5f,  0.5f,  0.5f,        -1.0f,  0.0f,  0.0f,
        -0.5f,  0.5f,  0.5f,        -1.0f,  0.0f,  0.0f,
        -0.5f, -0.5f, -0.5f,        -1.0f,  0.0f,  0.0f,
        -0.5f, -0.5f,  0.5f,        -1.0f,  0.0f,  0.0f,
        
        -0.5f, -0.5f, -0.5f,         0.0f, -1.0f,  0.0f,
         0.5f, -0.5f, -0.5f,         0.0f, -1.0f,  0.0f,
        -0.5f, -0.5f,  0.5f,         0.0f, -1.0f,  0.0f,
        -0.5f, -0.5f,  0.5f,         0.0f, -1.0f,  0.0f,
         0.5f, -0.5f, -0.5f,         0.0f, -1.0f,  0.0f,
         0.5f, -0.5f,  0.5f,         0.0f, -1.0f,  0.0f,
        
         0.5f,  0.5f,  0.5f,         0.0f,  0.0f,  1.0f,
        -0.5f,  0.5f,  0.5f,         0.0f,  0.0f,  1.0f,
         0.5f, -0.5f,  0.5f,         0.0f,  0.0f,  1.0f,
         0.5f, -0.5f,  0.5f,         0.0f,  0.0f,  1.0f,
        -0.5f,  0.5f,  0.5f,         0.0f,  0.0f,  1.0f,
        -0.5f, -0.5f,  0.5f,         0.0f,  0.0f,  1.0f,
        
         0.5f, -0.5f, -0.5f,         0.0f,  0.0f, -1.0f,
        -0.5f, -0.5f, -0.5f,         0.0f,  0.0f, -1.0f,
         0.5f,  0.5f, -0.5f,         0.0f,  0.0f, -1.0f,
         0.5f,  0.5f, -0.5f,         0.0f,  0.0f, -1.0f,
        -0.5f, -0.5f, -0.5f,         0.0f,  0.0f, -1.0f,
        -0.5f,  0.5f, -0.5f,         0.0f,  0.0f, -1.0f
    };
    
    SGLVertexAttributeList attrs;
    attrs.push_back(POSITIONS);
    attrs.push_back(NORMALS);
    
    return [[SGLMesh alloc] initWithMode:MeshMode_Triangles
                              vertexData:vertexData
                        vertexAttributes:attrs
                             vertexCount:sizeof(vertexData) / (sizeof(GLfloat) * 6)
                               indexData:nil
                              indexCount:0];
}

+ (SGLMesh*) axiiMesh
{
    static GLfloat vertexData[] =
    {
        // position.xyz     // color.rgb
        
        0.0f, 0.0f, 0.0f,   1.0f,  0.0f,  0.0f,
        1.0f, 0.0f, 0.0f,   1.0f,  0.0f,  0.0f,
        
        0.0f, 0.0f, 0.0f,   0.0f,  1.0f,  0.0f,
        0.0f, 1.0f, 0.0f,   0.0f,  1.0f,  0.0f,
        
        0.0f, 0.0f, 0.0f,   0.0f,  0.0f,  1.0f,
        0.0f, 0.0f, 1.0f,   0.0f,  0.0f,  1.0f,
    };
    
    SGLVertexAttributeList attrs;
    attrs.push_back(POSITIONS);
    attrs.push_back(COLORS);
    
    return [[SGLMesh alloc] initWithMode:MeshMode_Lines
                              vertexData:vertexData
                        vertexAttributes:attrs
                             vertexCount:sizeof(vertexData) / (sizeof(GLfloat) * 6)
                               indexData:nil
                              indexCount:0];
}
    
+ (SGLMesh*) lineMesh
{
    static GLfloat vertexData[] =
    {
        // position.xyz     // color.rgb
        
        0.0f, 0.0f, 0.0f,   1.0f,  1.0f,  1.0f,
        1.0f, 1.0f, 1.0f,   1.0f,  1.0f,  1.0f,
    };
    
    SGLVertexAttributeList attrs;
    attrs.push_back(POSITIONS);
    attrs.push_back(COLORS);
    
    return [[SGLMesh alloc] initWithMode:MeshMode_Lines
                              vertexData:vertexData
                        vertexAttributes:attrs
                             vertexCount:sizeof(vertexData) / (sizeof(GLfloat) * 6)
                               indexData:nil
                              indexCount:0];
}

@end
