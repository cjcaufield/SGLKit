//
//  SGLMacWindowController.mm
//  SGLKit
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "SGLMacWindowController.h"
#import "SGLMacView.h"


@implementation SGLMacWindowController

- (void) windowDidResignMain:(NSNotification*)note
{
    _timeWhenLastMain = NSDate.timeIntervalSinceReferenceDate;
}

- (void) windowDidReposition
{
    [self.view reposition];
}

- (BOOL) isFullscreen
{
    return ((self.window.styleMask & NSFullScreenWindowMask) > 0);
}

@end
