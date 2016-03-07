//
//  SGLMacWindowController.h
//  SGLKit
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SGLMacView;


@interface SGLMacWindowController : NSWindowController

- (id) initWithWindowNibName:(NSString*)name;

@property (nonatomic, strong) IBOutlet SGLMacView* view;
@property (nonatomic) NSTimeInterval timeWhenLastMain;
@property (readonly) BOOL isFullscreen;

- (void) windowDidReposition;
- (void) windowDidResignMain:(NSNotification*)note;

@end
