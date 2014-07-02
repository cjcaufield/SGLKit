//
//  SGLRenderer.h
//  SGLKit
//
//  Created by Colin Caufield on 12-03-11.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGLScene, SGLMesh, SGLShader;

@interface SGLRenderer : NSObject

@property (nonatomic, strong) SGLScene* scene;
@property (nonatomic, strong) NSArray* children;
@property (nonatomic, strong) NSArray* dependencies;
@property (nonatomic, strong) NSArray* dependents;
@property (nonatomic) NSTimeInterval timeOfLastDraw;
@property (nonatomic) BOOL needsDisplay;
@property (nonatomic) int renderingQuality;
@property (nonatomic) float timeEffectsLevel;
@property (nonatomic) SGLMesh* mesh;
@property (nonatomic) SGLShader* shader;

- (id) initWithScene:(SGLScene*)scene;
- (void) transformWasChanged;
- (void) lightingWasChanged;
- (void) requestRedisplay;
- (void) update:(NSTimeInterval)seconds;
- (void) render;
- (NSArray*) overlayText;

@end
