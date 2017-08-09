//
//  SGLIndexBuffer.mm
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLIndexBuffer.h"
#import "SGLVertexAttribute.h"
#import "SGLUtilities.h"
#import "SGLDebug.h"
#import "SGLHeader.h"


@implementation SGLIndexBuffer

- (id) initWithData:(GLushort*)data byteCount:(size_t)byteCount indexCount:(size_t)indexCount
{
    self = [super init];
    
    SGL_ASSERT(data != NULL);
    SGL_ASSERT(byteCount > 0);
    SGL_ASSERT(indexCount > 0);
    SGL_ASSERT(byteCount == indexCount * sizeof(GLushort));
    
    self.data = data;
    self.byteCount = byteCount;
    self.indexCount = indexCount;
    
    glGenBuffers(1, &_glName);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _glName);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, GLsizeiptr(byteCount), data, GL_STATIC_DRAW);
    
    return self;
}

- (void) dealloc
{
    //NSLog(@"GLIndexBuffer dealloc");
    
    glDeleteBuffers(1, &_glName);
}

@end
