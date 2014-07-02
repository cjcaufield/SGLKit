//
//  SGLRenderer.m
//  SGLKit
//
//  Created by Colin Caufield on 12-03-11.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "SGLRenderer.h"
#import "SGLMesh.h"
#import "SGLShader.h"

@implementation SGLRenderer

- (id) init
{
    self = [super init];
    
    _needsDisplay = YES;
    
    return self;
}

- (id) initWithScene:(SGLScene*)scene
{
    self = [self init];
    
    _scene = scene;
    
    return self;
}

- (void) update:(NSTimeInterval)seconds
{
    // update self
    
    //for (SGLRenderer* child in _children)
    //    [child update:seconds];
}

- (void) render
{
    _timeOfLastDraw = [NSDate timeIntervalSinceReferenceDate];
    
    if (_shader != nil && _mesh != nil)
    {
        [_shader activate];
        [_mesh render];
    }
    
    for (SGLRenderer* child in _children)
        [child render];
}

- (NSArray*) overlayText
{
    return @[];
}

- (void) setRenderingQuality:(int)quality
{
    _renderingQuality = quality;
    
    for (SGLRenderer* child in _children)
        child.renderingQuality = quality;
}

- (void) requestRedisplay
{
    _needsDisplay = YES;
}

- (void) transformWasChanged
{
    for (SGLRenderer* child in _children)
        [child transformWasChanged];
}

- (void) lightingWasChanged
{
    // nothing
}

@end
