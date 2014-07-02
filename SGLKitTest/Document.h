//
//  Document.h
//  SGLKitTest
//
//  Created by Colin Caufield on 2014-11-14.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WindowController;

@interface Document : NSDocument

@property (nonatomic) WindowController* windowController;

@end
