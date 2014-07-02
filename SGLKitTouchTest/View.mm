//
//  View.mm
//  SGLKitTouchTest
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "View.h"
#import "SGLScene.h"

@implementation View

- (void) openGLWasPrepared
{
    [super openGLWasPrepared];
    
    self.userControlsCamera = YES;
    self.scene.showAxes = YES;
    self.scene.floatingOrientation = YES;
    self.scene.objectDistance = 4000.0;
}

@end
