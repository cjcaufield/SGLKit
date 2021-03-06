//
//  SGLScene.mm
//  SGLKit
//
//  Created by Colin Caufield on 2014-05-03.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLScene.h"
#import "SGLContext.h"
#import "SGLShader.h"
#import "SGLMeshes.h"
#import "SGLUtilities.h"
#import "SGLDefaults.h"

#define DRAW_AXII

static const float FRUSTUM_NEAR = 1.0f;
static const float FRUSTUM_FAR = 100000.0f;
static const float DEFAULT_CAM_DIST = 5000.0f;

const vec3 ABOVE_LIGHT_POS (0.0, 5000.0, 0.0);
const vec3 ABOVE_BACK_LIGHT_POS (0.0, 5000.0, -3500.0);

NSString* const SGLSceneNeedsDisplayNotification = @"SGLSceneNeedsDisplayNotification";

#pragma mark - Private

@interface SGLScene ()

@property (nonatomic, strong) NSHashTable* allSceneShaders;
@property (nonatomic, strong) SGLShader* colorShader;
@property (nonatomic, strong) SGLMesh* axiiMesh;

@end

#pragma mark - Public

@implementation SGLScene

- (id) initWithContext:(SGLContext*)context;
{
    self = [super initWithScene:nil];
    
    _context = context;
    
    if ([DEFAULTS objectForKey:PositionalPerspective] != nil)
        _projectionType = [DEFAULTS boolForKey:PositionalPerspective] ? PERSPECTIVE : ORTHOGRAPHIC;
    else
        _projectionType = PERSPECTIVE;
    
    _clearColor = TRANSPARENT_BLACK;
    
    //self.lightPosition = vec3(0.0f, 1000.0f, 300.0 - self.cameraDistance);
    
    //_lightPosition = vec3(0.0f, 5000.0f, 300.0);
    
    //BOOL motion = NO;
    
    //#ifdef SGL_IOS
    //    motion = (_dynamicOrientation && self.renderingQuality >= RenderingQuality_High);
    //#endif
    
    //if (motion)
    //{
    //    _lightPosition = AppDelegate.shared.lightPosition;
    //    _inverseOrientationMatrix = AppDelegate.shared.inverseOrientationMatrix;
    //}
    //else
    {
        /*
        #ifdef SGL_IOS
            _lightPosition = ABOVE_BACK_LIGHT_POS;
        #endif
        #ifdef SGL_MAC
            _lightPosition = ABOVE_LIGHT_POS;
        #endif
        */
        
        _lightPosition = ABOVE_BACK_LIGHT_POS;
        
        _inverseOrientationMatrix = mat3::identity();
    }
    
    if ([DEFAULTS objectForKey:LightLevel] != nil)
        _lightLevel = [DEFAULTS floatForKey:LightLevel];
    else
        _lightLevel = 1.0;
    
    _lightColor = WHITE;
    
    #ifdef SGL_MAC
        _allSceneShaders = [NSHashTable hashTableWithWeakObjects];
    #endif
    #ifdef SGL_IOS
        _allSceneShaders = [NSHashTable weakObjectsHashTable];
    #endif
    
    [self resetCamera];
    
    _axiiMesh = [SGLMeshes axiiMesh];
    
    _colorShader = [[SGLShader alloc] initWithName:@"Color"];
    
    [self addLitShader:self.context.basicShader];
    //[self addLitShader:_colorShader];
    
    return self;
}

#pragma mark - Positioning

- (void) setObjectDistance:(float)dist
{
    _cameraDistance -= _objectDistance;
    _objectDistance = dist;
    _cameraDistance += _objectDistance;
    
    [self transformWasChanged];
}

- (void) setOriginOffset:(vec2)originOffset
            centerOffset:(vec2)centerOffset
                viewSize:(vec2)viewSize
            pixelDensity:(float)pixelDensity
{
    //SGL_LOG(@"viewSize = %.1f, %.1f", viewSize.x, viewSize.y);
    
    _originOffset = originOffset;
    _centerOffset = centerOffset;
    _viewSize = viewSize;
    _viewPixelDensity = pixelDensity;
    
    [self transformWasChanged];
}

- (void) setViewUsedRect:(CGRect)rect
{
    _viewUsedRect = rect;
    
    [self transformWasChanged];
}

- (void) transformWasChanged
{
    vec2 viewPortOffset =
        vec2(CGRectGetMidX(_viewUsedRect), _viewSize.y - CGRectGetMidY(_viewUsedRect)) -
            vec2(0.5 * _viewSize.x, 0.5 * _viewSize.y);
    
    vec2 offset = _centerOffset + _cameraOffset + viewPortOffset;
    vec3 translation = vec3(offset.x, offset.y, -_cameraDistance);
    vec2 rotation = vec2(+_monitorRotation.y, -_monitorRotation.x);
    
    vec2 size = vec2(_viewUsedRect.size);
    
    float minScale = minComponent(size);
    
    vec3 scale = vec3(minScale);
    
    if (_stretch)
        scale = vec3(size, minScale);
    
    _modelViewMatrix = mat4::identity();
    _modelViewMatrix = _modelViewMatrix * mat4::translation(translation);
    _modelViewMatrix = _modelViewMatrix * mat4::rotationYX(rotation.y, rotation.x);
    
    _modelViewMatrix = _modelViewMatrix * mat4::scale(scale); // CJC: use custom scale later.
    
    _normalMatrix = mat3(_modelViewMatrix).inverse();
    
    // CJC: temp
    _floatingModelViewMatrix = _modelViewMatrix * mat4(_inverseOrientationMatrix);
    _floatingNormalMatrix = mat3(_floatingModelViewMatrix).inverse();
    
    if (_projectionType == ORTHOGRAPHIC)
    {
        _projectionMatrix = mat4::ortho(_originOffset.x,
                                        _originOffset.x + _viewSize.x,
                                        _originOffset.y,
                                        _originOffset.y + _viewSize.y,
                                        FRUSTUM_NEAR,
                                        FRUSTUM_FAR);
    }
    else
    {
        float ratio = FRUSTUM_NEAR / DEFAULT_CAM_DIST;

        _projectionMatrix = mat4::offsetProjection(_originOffset.x * ratio,
                                                   (_originOffset.x + _viewSize.x) * ratio,
                                                   _originOffset.y * ratio,
                                                   (_originOffset.y + _viewSize.y) * ratio,
                                                   FRUSTUM_NEAR,
                                                   FRUSTUM_FAR);
    }
    
    _modelViewProjectionMatrix = _projectionMatrix * _modelViewMatrix;
    
    // CJC: temp
    _floatingModelViewProjectionMatrix = _projectionMatrix * _floatingModelViewMatrix;
    
    [self recalculateAxiiMatrix];

    for (SGLShader* shader in self.allSceneShaders)
        [self setSceneUniforms:shader];
    
    [super transformWasChanged];
}

#pragma mark - Lighting

- (void) lightingWasChanged
{
    for (SGLShader* shader in self.allSceneShaders)
        [self setSceneUniforms:shader];
    
    for (SGLRenderer* child in self.children)
        [child lightingWasChanged];
}

- (void) setLightPosition:(vec3)pos
{
    //SGL_METHOD_LOG_ARGS(@"%.3f, %.3f, %.3f", pos.x, pos.y, pos.z);
    
    _lightPosition = pos;
    [self lightingWasChanged];
}

- (void) setLightColor:(vec3)color
{
    _lightColor = color;
    [self lightingWasChanged];
}

- (void) setLightLevel:(float)level
{
    _lightLevel = level;
    [self lightingWasChanged];
}

#pragma mark - Camera

- (void) resetCamera
{
    _cameraDistance = DEFAULT_CAM_DIST + _objectDistance;
    _cameraOffset = ORIGIN_2D;
    _monitorRotation = ORIGIN_2D;
    [self transformWasChanged];
}

- (void) moveCamera:(float)amount
{
    _cameraDistance += amount;
    [self transformWasChanged];
}

- (void) offsetCamera:(vec2)offset
{
    _cameraOffset -= offset;
    [self transformWasChanged];
}

- (void) rotateCamera:(vec2)radians
{
    _monitorRotation += radians;
    [self transformWasChanged];
}

- (void) setProjectionType:(ProjectionType)type
{
    _projectionType = type;
    [self transformWasChanged];
}

- (IBAction) resetCamera:(id)sender
{
    [self resetCamera];
}

#pragma mark - Drawing

- (void) update:(double)seconds
{
    // nothing
}

- (void) render
{
    [self.context clear:OPAQUE_BLACK];
    //[self.context clear:_clearColor];
    
    [super render];
    
    if (_showAxes)
        [self renderAxes];
}

- (void) renderBoundingBox
{
    // nothing
}

- (void) renderAxes
{
    #ifdef DRAW_AXII
        
        [_colorShader setVec4:vec4(1.0) forName:@"color"];
        [_colorShader activate];
        [_axiiMesh render];
        
    #endif
}

- (NSArray*) overlayText
{
    return
    @[
        [NSString stringWithFormat:@"Camera Offset: %.2f, %.2f", _cameraOffset.x, _cameraOffset.y],
        [NSString stringWithFormat:@"Origin Offset: %.2f, %.2f", _originOffset.x, _originOffset.y],
        [NSString stringWithFormat:@"Center Offset: %.2f, %.2f", _centerOffset.x, _centerOffset.y]
    ];
}

- (void) setRenderingQuality:(unsigned int)quality
{
    super.renderingQuality = quality;
    
    // Nothing else yet.
}

- (void) requestRedisplay
{
    [super requestRedisplay];
    
    [NSNotificationCenter.defaultCenter postNotificationName:SGLSceneNeedsDisplayNotification object:self];
}

#pragma mark - Shaders

- (void) addLitShader:(SGLShader*)shader
{
    [self setSceneUniforms:shader];
    
    [self.allSceneShaders addObject:shader];
}

- (void) removeSceneShader:(SGLShader*)shader
{
    [self.allSceneShaders removeObject:shader];
}

- (void) setSceneUniforms:(SGLShader*)shader
{
    if (_floatingOrientation)
    {
        [shader setMat4:_floatingModelViewMatrix forName:@"modelViewMatrix"];
        [shader setMat4:_floatingModelViewProjectionMatrix forName:@"modelViewProjectionMatrix"];
        [shader setMat3:_floatingNormalMatrix forName:@"normalMatrix"];
    }
    else
    {
        [shader setMat4:_modelViewMatrix forName:@"modelViewMatrix"];
        [shader setMat4:_modelViewProjectionMatrix forName:@"modelViewProjectionMatrix"];
        [shader setMat3:_normalMatrix forName:@"normalMatrix"];
    }
    
    [shader setFloat:_cameraDistance forName:@"cameraDistance"];
    [shader setMat3:_inverseOrientationMatrix forName:@"inverseOrientationMatrix"];
    [shader setVec3:_lightPosition forName:@"lightPosition"];
    [shader setVec3:_lightColor forName:@"lightColor"];
    [shader setFloat:_lightLevel forName:@"lightLevel"];
}

#pragma mark - Transforms

- (void) setInverseOrientationMatrix:(mat3)mat
{
    //SGL_METHOD_LOG;
    //SGL_LOG(@"%.2f, %.2f, %.2f", mat.at(0, 0), mat.at(0, 1), mat.at(0, 2));
    //SGL_LOG(@"%.2f, %.2f, %.2f", mat.at(1, 0), mat.at(1, 1), mat.at(1, 2));
    //SGL_LOG(@"%.2f, %.2f, %.2f", mat.at(2, 0), mat.at(2, 1), mat.at(2, 2));
    
    _inverseOrientationMatrix = mat;
    
    [self recalculateAxiiMatrix];
    
    #ifdef SGL_IOS
        _lightPosition = _inverseOrientationMatrix * ABOVE_LIGHT_POS;
    #endif
    #ifdef SGL_MAC
        _lightPosition = ABOVE_BACK_LIGHT_POS;
    #endif
    
    [self lightingWasChanged];
    
    // CJC temp.
    //[self transformWasChanged]; // CJC: needed?
}

- (void) recalculateAxiiMatrix
{
    #ifdef DRAW_AXII
        
        mat4 translationMatrix;
        translationMatrix.reset();
        translationMatrix.setRow(3, _modelViewMatrix.row(3));
        
        mat4 rescaledTranslationMatrix = translationMatrix * mat4::scale(vec3(100.0));
        
        mat4 axiiModelViewMatrix = rescaledTranslationMatrix * mat4(_inverseOrientationMatrix);
        mat4 axiiModelViewProjectionMatrix = _projectionMatrix * axiiModelViewMatrix;
        
        [_colorShader setMat4:axiiModelViewMatrix forName:@"modelViewMatrix"];
        [_colorShader setMat4:axiiModelViewProjectionMatrix forName:@"modelViewProjectionMatrix"];
        
    #endif
}

@end
