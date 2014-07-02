//
//  SGLIndexBuffer.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLHeader.h"

@interface SGLIndexBuffer : NSObject

@property (nonatomic) unsigned int glName;
@property (nonatomic) GLushort* data;
@property (nonatomic) size_t byteCount;
@property (nonatomic) size_t indexCount;

- (id) initWithData:(GLushort*)data byteCount:(size_t)byteCount indexCount:(size_t)indexCount;

@end
