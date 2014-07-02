//
//  SGLVertexAttribute.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLHeader.h"
#include <vector>


enum SGLVertexAttribute
{
    POSITIONS = 0,
    NORMALS   = 1,
    COLORS    = 2,
    TEXCOORDS = 3,
};

struct SGLVertexAttributeInfo
{
    SGLVertexAttribute attribute;
    GLenum dataType;
    size_t elementCount;
    size_t byteCount;
};

typedef std::vector<SGLVertexAttribute>     SGLVertexAttributeList;
typedef std::vector<SGLVertexAttributeInfo> SGLVertexAttributeInfoList;
