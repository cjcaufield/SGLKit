//
//  SGLVertexBuffer.mm
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLVertexBuffer.h"
#import "SGLUtilities.h"
#import "SGLDebug.h"
#import "SGLHeader.h"
#include <algorithm>


size_t GLDataTypeSize(GLenum dataType)
{
    switch (dataType)
    {
        case GL_BYTE:
        case GL_UNSIGNED_BYTE:
            
            return 1;
            
        case GL_SHORT:
        case GL_UNSIGNED_SHORT:
            
        #ifdef SGL_MAC
            case GL_HALF_FLOAT:
        #endif
        #ifdef SGL_IOS
            case GL_HALF_FLOAT_OES:
        #endif

            return 2;
            
        case GL_FLOAT:
            
            return 4;
            
        default:
            
            SGL_ASSERT(NO);
            return 1;
    }
}


@interface SGLVertexBuffer ()

@property (nonatomic) unsigned int glName;

@end


@implementation SGLVertexBuffer

//
// Old Method
//
- (id) initWithAttributes:(SGLVertexAttributeList)attributes
                     data:(void*)data
                byteCount:(size_t)byteCount
              vertexCount:(size_t)vertexCount
{
    self = [super init];
    
    SGL_ASSERT(attributes.size() > 0);
    SGL_ASSERT(data != NULL);
    SGL_ASSERT(byteCount > 0);
    SGL_ASSERT(vertexCount * attributes.size() * 3 * sizeof(GLfloat) == byteCount);
    
    self.attributes = attributes;
    self.data = data;
    self.byteCount = byteCount;
    self.vertexCount = vertexCount;
    
    glGenBuffers(1, &_glName);
    glBindBuffer(GL_ARRAY_BUFFER, _glName);
    glBufferData(GL_ARRAY_BUFFER, GLsizeiptr(byteCount), data, GL_STATIC_DRAW);
    
    const uint8_t* offset = 0;
    GLsizei stride = GLsizei(attributes.size() * 3 * sizeof(GLfloat));
    
    for (size_t i = 0; i < attributes.size(); i++)
    {
        SGLVertexAttribute attribute = attributes[i];
        
        if (attribute == NORMALS)
            _hasNormals = YES;
        
        else if (attribute == COLORS)
            _hasColors = YES;
        
        else if (attribute == TEXCOORDS)
            _hasTexCoords = YES;
        
        //NSLog(@"Enabling vertex attribute %d", attribute);
        
        glEnableVertexAttribArray(attribute);
        glVertexAttribPointer(attribute, 3, GL_FLOAT, GL_FALSE, stride, offset);
        
        offset += 3 * sizeof(GLfloat);
    }
    
    return self;
}

//
// New Method
//
/*
- (id) initWithAttributeInfoList:(GLVertexAttributeInfoList)attributeInfoList
                            data:(void*)data
                       byteCount:(size_t)byteCount
                     vertexCount:(size_t)vertexCount
{
    self = [super init];
    
    SGL_ASSERT(attributeInfoList.size() > 0);
    SGL_ASSERT(data != NULL);
    SGL_ASSERT(byteCount > 0);
    SGL_ASSERT(vertexCount > 0);
    
    self.attributeInfoList = attributeInfoList;
    self.data = data;
    self.byteCount = byteCount;
    self.vertexCount = vertexCount;
    
    glGenBuffers(1, &_glName);
    glBindBuffer(GL_ARRAY_BUFFER, _glName);
    glBufferData(GL_ARRAY_BUFFER, GLsizeiptr(byteCount), data, GL_STATIC_DRAW);
    
    //
    // Calculate the stride.
    //
    
    GLsizei stride = 0;
    
    for (size_t i = 0; i < attributeInfoList.size(); i++)
    {
        const GLVertexAttributeInfo& info = attributeInfoList[i];
        size_t dataTypeSize = GLDataTypeSize(info.dataType);
        stride += dataTypeSize * info.elementCount;
    }
    
    SGL_ASSERT(vertexCount * size_t(stride) == byteCount);
    
    //
    // Set up the vertex attributes.
    //
    
    const uint8_t* offset = 0;
    
    for (size_t i = 0; i < attributeInfoList.size(); i++)
    {
        const GLVertexAttributeInfo& info = attributeInfoList[i];
        GLVertexAttribute attribute = info.attribute;
        
        SGL_ASSERT(attribute != INDICES);
        
        if (attribute == NORMALS)
            _hasNormals = YES;
 
        if (attribute == COLORS)
            _hasColors = YES;
 
        else if (attribute == TEXCOORDS)
            _hasTexCoords = YES;
        
        //NSLog(@"Enabling vertex attribute %d", attribute);
        
        glEnableVertexAttribArray(attribute);
        glVertexAttribPointer(attribute, GLint(info.elementCount), info.dataType, GL_FALSE, stride, offset);
        
        size_t dataTypeSize = GLDataTypeSize(info.dataType);
        
        offset += dataTypeSize * info.elementCount;
    }
    
    return self;
}
*/

- (void) dealloc
{
    //NSLog(@"GLVertexBuffer dealloc");
    
    glDeleteBuffers(1, &_glName);
}

@end
