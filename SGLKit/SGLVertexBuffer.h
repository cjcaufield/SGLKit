//
//  SGLVertexBuffer.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLVertexAttribute.h"


@interface SGLVertexBuffer : NSObject

@property (nonatomic) NSArray* attributes;
@property (nonatomic) NSArray* attributeInfoList;
@property (nonatomic) void* data;
@property (nonatomic) size_t byteCount;
@property (nonatomic) size_t vertexCount;
@property (nonatomic) BOOL hasNormals;
@property (nonatomic) BOOL hasColors;
@property (nonatomic) BOOL hasTexCoords;

//
// Old Method
//
- (id) initWithAttributes:(NSArray*)attributes
                     data:(void*)data
                byteCount:(size_t)byteCount
              vertexCount:(size_t)vertexCount;

//
// New Method
//
/*
- (id) initWithAttributeInfoList:(GLVertexAttributeInfoList)attributeInfoList
                            data:(void*)data
                       byteCount:(size_t)byteCount
                     vertexCount:(size_t)vertexCount;
*/

@end
