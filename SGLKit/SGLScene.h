//
//  SGLScene.h
//  SGLKit
//
//  Created by Colin Caufield on 2014-05-03.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLRenderer.h"
#import "SGLTypes.h"
#import "SGLMath.h"

@class SGLContext, SGLShader;

extern const vec3 ABOVE_LIGHT_POS;
extern const vec3 ABOVE_BACK_LIGHT_POS;

extern NSString* const SGLSceneNeedsDisplayNotification;

@interface SGLScene : SGLRenderer

- (id) initWithContext:(SGLContext*)context;

@property (nonatomic, weak) SGLContext* context;

// View
@property (nonatomic) vec2 viewSize;
@property (nonatomic) CGRect viewUsedRect;
@property (nonatomic) float viewPixelDensity;

// Camera
@property (nonatomic) float objectDistance;
@property (nonatomic) float cameraDistance;
@property (nonatomic) vec2 cameraOffset;
@property (nonatomic) vec2 centerOffset;
@property (nonatomic) ProjectionType projectionType;

// Transforms
@property (nonatomic) vec2 originOffset;
@property (nonatomic) vec2 monitorRotation;
@property (nonatomic) mat4 projectionMatrix;
@property (nonatomic) mat4 modelViewMatrix;
@property (nonatomic) mat4 modelViewProjectionMatrix;
@property (nonatomic) mat3 normalMatrix;
@property (nonatomic) mat4 floatingModelViewMatrix;
@property (nonatomic) mat4 floatingModelViewProjectionMatrix;
@property (nonatomic) mat3 floatingNormalMatrix;

// Light
@property (nonatomic) vec3 lightPosition;
@property (nonatomic) vec3 lightColor;
@property (nonatomic) float lightLevel;

// Orientation
@property (nonatomic) BOOL stretch;
@property (nonatomic) BOOL floatingOrientation;
@property (nonatomic) BOOL dynamicOrientation;
@property (nonatomic) mat3 inverseOrientationMatrix;

// Options
@property (nonatomic) vec4 clearColor;
@property (nonatomic) BOOL showAxes;
@property (nonatomic) BOOL showBoundingBox;

- (void) update:(double)seconds;
- (void) render;
- (void) renderAxes;

- (NSArray*) overlayText;

- (void) setOriginOffset:(vec2)originOffset
            centerOffset:(vec2)centerOffset
                viewSize:(vec2)viewSize
            pixelDensity:(float)pixelDensity;

// Camera
- (void) resetCamera;
- (void) moveCamera:(float)amount;
- (void) offsetCamera:(vec2)offset;
- (void) rotateCamera:(vec2)radians;

// Shaders
- (void) addSceneShader:(SGLShader*)shader;
- (void) removeSceneShader:(SGLShader*)shader;
- (void) setSceneUniforms:(SGLShader*)shader;

// Actions
- (IBAction) resetCamera:(id)sender;

@end
