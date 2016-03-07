//
//  SGLVertexAttribute.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLHeader.h"


typedef enum SGLVertexAttribute
{
    POSITIONS  = 0,
    NORMALS    = 1,
    RGBACOLORS = 2,
    TEXCOORDS  = 3,
    
} SGLVertexAttribute;

struct SGLVertexAttributeInfo
{
    SGLVertexAttribute attribute;
    GLenum dataType;
    size_t elementCount;
    size_t byteCount;
};
