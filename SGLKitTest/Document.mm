//
//  Document.mm
//  SGLKitTest
//
//  Created by Colin Caufield on 2014-11-14.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "Document.h"
#import "WindowController.h"


@implementation Document

- (id) init
{
    self = [super init];
    return self;
}

- (void) makeWindowControllers
{
    self.windowController = [[WindowController alloc] init];
    [self addWindowController:self.windowController];
}

- (void) windowControllerDidLoadNib:(NSWindowController*)controller
{
    [super windowControllerDidLoadNib:controller];
}

@end
