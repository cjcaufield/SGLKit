//
//  SGLTexture.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "SGLMath.h"
#import "SGLHeader.h"

enum TextureType
{
    RECTANGLE,
    CUBEMAP
};

enum ColorType
{
    RGBA,
    LUMINANCE
};

enum SamplingType
{
    NEAREST,
    BILINEAR,
    TRILINEAR
};

enum WrappingType
{
    CLAMP,
    REPEAT,
    MIRRORED_REPEAT
};

struct TextureOptions
{
    TextureType textureType;
    GLint width;
    GLint height;
    GLint sampler;
    ColorType colorType;
    SamplingType samplingType;
    WrappingType wrappingType;
    BOOL canBeRenderTarget;
};

//
// GLTexture
//

@interface SGLTexture : NSObject

@property (readonly) unsigned int glName;
@property (readonly) GLint sampler;
@property (readonly) GLint width;
@property (readonly) GLint height;
@property (readonly) GLint maxMipLevel;
@property (readonly) vec2 size;
@property (readonly) BOOL isRenderTarget;
@property (nonatomic) SamplingType samplingType;

// New
- (id) initWithFilename:(NSString*)filename options:(TextureOptions*)options;
- (id) initWithCGImage:(CGImageRef)image options:(TextureOptions*)options;

#ifdef SGL_MAC
    - (id) initWithBitmap:(NSBitmapImageRep*)bitmap options:(TextureOptions*)options;
#endif

// Old
- (id) initWithNSData:(NSData*)data options:(TextureOptions*)options;
- (id) initWithNSDataArray:(NSArray*)array options:(TextureOptions*)options;
- (id) initWithNoise:(TextureOptions*)options;
- (id) initWithConstant:(uint32_t)pixel options:(TextureOptions*)options;

- (void) activate;
+ (void) deactivateAll;
- (void) unload;

- (void) write:(const void*)data;
- (void) write:(const void*)data at:(IntPoint)point size:(IntSize)size;

- (void) becomeRenderTarget;
- (void) resignRenderTarget;

- (GLint) mipLevelForSize:(IntSize)size;
- (IntSize) sizeForMipLevel:(GLint)level;

@end