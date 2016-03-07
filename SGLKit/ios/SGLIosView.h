//
//  SGLIosView.h
//  SGLKitTouch
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import <GLKit/GLKit.h>


@interface SGLIosView : GLKView

@property (nonatomic, strong) UITapGestureRecognizer* tripleTapRecognizer;
@property (readonly) CGFloat pixelDensity;

- (void) openGLWasPrepared;
- (void) openGLWasDestroyed;
- (void) update:(double)seconds;
- (void) render;
- (void) renderOverlay;
- (void) drawText:(NSString*)text;
- (void) drawTextLines:(NSArray*)lines;
- (void) shadersDidReload;

@end
