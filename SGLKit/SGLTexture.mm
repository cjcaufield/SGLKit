//
//  SGLTexture.mm
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLTexture.h"
#import "SGLUtilities.h"
#import "SGLDebug.h"
#import "SGLHeader.h"
#import <GLKit/GLKit.h>
#include <algorithm>
#include <vector>
#include <array>

typedef std::array<GLint, 4> Viewport;

static const unsigned int MAX_NUM_SAMPLERS = 8;
static std::vector<GLuint> _parentFboNames;
static std::vector<Viewport> _parentFboViewports;

inline uint8_t randomUInt8()
{
    return random() % 256;
}


@interface SGLTexture ()

@property (nonatomic) GLuint glFboName;
@property (nonatomic) GLenum glType;
@property (nonatomic) GLint glMinFilter;
@property (nonatomic) GLint glMagFilter;
@property (nonatomic) GLint glWrap;
@property (nonatomic) TextureType textureType;
@property (nonatomic) ColorType colorType;
@property (nonatomic) WrappingType wrappingType;
@property (nonatomic) BOOL canBeRenderTarget;

@end


@implementation SGLTexture

+ (void) deactivateAll
{
    for (unsigned int i = 0; i < MAX_NUM_SAMPLERS; i++)
    {
        glActiveTexture(GL_TEXTURE0 + i);
        glDisable(GL_TEXTURE_2D);
        glDisable(GL_TEXTURE_CUBE_MAP);
    }
}

- (id) initWithFilename:(NSString*)filename options:(TextureOptions*)options
{
    NSDictionary* loadOptions =
    @{
        GLKTextureLoaderGenerateMipmaps  : @(options->samplingType == TRILINEAR),
        GLKTextureLoaderOriginBottomLeft : @YES
    };
    
    // Clear any existing errors.
    glGetError();
    
    NSError* err = nil;
    GLKTextureInfo* info = [GLKTextureLoader textureWithContentsOfFile:filename options:loadOptions error:&err];
    SGL_ASSERT(info != nil);
    
    return [self initWithTextureInfo:info options:options];
}

- (id) initWithCGImage:(CGImageRef)image options:(TextureOptions*)options
{
    NSDictionary* loadOptions =
    @{
        GLKTextureLoaderGenerateMipmaps  : @(options->samplingType == TRILINEAR),
        GLKTextureLoaderOriginBottomLeft : @YES
    };
    
    // Clear any existing errors.
    glGetError();
    
    NSError* err = nil;
    GLKTextureInfo* info = [GLKTextureLoader textureWithCGImage:image options:loadOptions error:&err];
    SGL_ASSERT(info != nil);
    
    return [self initWithTextureInfo:info options:options];
}

- (id) initWithTextureInfo:(GLKTextureInfo*)texInfo options:(TextureOptions*)options
{
    self = [super init];
    
    _glName = texInfo.name;
    _glType = texInfo.target;
    _width  = GLint(texInfo.width);
    _height = GLint(texInfo.height);
    _size   = vec2(_width, _height);
    
    _textureType       = options->textureType;
    _sampler           = options->sampler;
    _colorType         = options->colorType;
    _samplingType      = options->samplingType;
    _wrappingType      = options->wrappingType;
    _canBeRenderTarget = options->canBeRenderTarget;
    
    [self setSamplingType:_samplingType];
    [self setWrappingType:_wrappingType];
    
    _maxMipLevel = 0; // CJC ???
    
    if (_canBeRenderTarget)
    {
        SGL_ASSERT(_glType == GL_TEXTURE_2D);
        glGenFramebuffers(1, &_glFboName);
    }
    
    return self;
}

#ifdef SGL_MAC

    - (id) initWithBitmap:(NSBitmapImageRep*)bitmap options:(TextureOptions*)options
    {
        int w = options->width = (int)bitmap.pixelsWide;
        int h = options->height = (int)bitmap.pixelsHigh;
        
        _width = w;
        _height = h;
        
        if (options->textureType == CUBEMAP)
        {
            // CJC: For now, cubemap textures can only be RGBA and BILINEAR.  Add support for the other modes later.
            SGL_ASSERT(options->colorType == RGBA);
            SGL_ASSERT(options->samplingType == BILINEAR);
            
            // This must be true if the image has the appropriate 'cross' shape and square sides.
            SGL_ASSERT(w / 4 == h / 3);
            
            int faceSize = (w / 4);
            
            // The data for all six faces is stored sequentially in one buffer.
            std::vector<uint32_t> imageData(w * h * 6);
            
            // The order is:
            //   1
            // 0 2 4 5
            //   3
            IntPoint origins[6] =
            {
                IntPoint(0 * faceSize, 1 * faceSize), // 0
                IntPoint(1 * faceSize, 2 * faceSize), // 1
                IntPoint(1 * faceSize, 1 * faceSize), // 2
                IntPoint(1 * faceSize, 0 * faceSize), // 3
                IntPoint(2 * faceSize, 1 * faceSize), // 4
                IntPoint(3 * faceSize, 1 * faceSize)  // 5
            };
            
            int index = 0;
            
            for (int face = 0; face < 6; face++)
            {
                IntPoint origin = origins[face];
                
                for (int y = origin.y; y < origin.y + faceSize; y++)
                {
                    for (int x = origin.x; x < origin.x + faceSize; x++)
                    {
                        NSColor* color = [bitmap colorAtX:x y:y];
                        CGFloat fr, fg, fb, fa;
                        [color getRed:&fr green:&fg blue:&fb alpha:&fa];
                        
                        uint32_t r = (uint32_t)(fr * 255.0f);
                        uint32_t g = (uint32_t)(fg * 255.0f);
                        uint32_t b = (uint32_t)(fb * 255.0f);
                        uint32_t a = (uint32_t)(fa * 255.0f);
                        
                        // The order is 0xAARRGGBB.
                        uint32_t colorAsInt = (a << 24) | (r << 16) | (g << 8) | (b << 0);
                        
                        imageData[index++] = colorAsInt;
                    }
                }
            }
            
            return [self initWithNSData:VectorToData(imageData) options:options];
        }
        else // textureType == RECTANGLE
        {
            // I'm sure there's a better way to do this than iterating over each pixel,
            // but I don't really want to figure out the pitch of all possible NSBitmapImageReps.
            
            if (options->colorType == RGBA)
            {
                std::vector<uint32_t> imageData(w * h);
                
                for (int y = 0; y < h; y++)
                {
                    for (int x = 0; x < w; x++)
                    {
                        NSColor* color = [bitmap colorAtX:x y:y];
                        CGFloat fr, fg, fb, fa;
                        [color getRed:&fr green:&fg blue:&fb alpha:&fa];
                        
                        uint32_t r = (uint32_t)(fr * 255.0f);
                        uint32_t g = (uint32_t)(fg * 255.0f);
                        uint32_t b = (uint32_t)(fb * 255.0f);
                        uint32_t a = (uint32_t)(fa * 255.0f);
                        
                        // The order is 0xAARRGGBB.
                        uint32_t colorAsInt = (a << 24) | (r << 16) | (g << 8) | (b << 0);
                        
                        int index = w * (h - y - 1) + x;
                        imageData[index] = colorAsInt;
                    }
                }
                
                return [self initWithNSData:VectorToData(imageData) options:options];
            }
            else // (options->colorType == Luminance)
            {
                std::vector<uint8_t> imageData(w * h);
                
                //
                for (int y = 0; y < h; y++)
                {
                    for (int x = 0; x < w; x++)
                    {
                        NSColor* color = [bitmap colorAtX:x y:y];
                        CGFloat r, g, b, a;
                        [color getRed:&r green:&g blue:&b alpha:&a];
                        
                        int index = w * (h - y - 1) + x;
                        imageData[index] = (uint8_t)(r * 255.0f);
                    }
                }
                
                return [self initWithNSData:VectorToData(imageData) options:options];
            }
        }
    }

#endif

- (id) initWithNSData:(NSData*)data options:(TextureOptions*)options
{
    return [self initWithNSDataArray:@[data] options:options];
}

- (id) initWithNSDataArray:(NSArray*)array options:(TextureOptions*)options
{
    self = [super init];
    
    _textureType = options->textureType;
    _width = options->width;
    _height = options->height;
    _size = vec2(_width, _height);
    _sampler = options->sampler;
    _colorType = options->colorType;
    _samplingType = options->samplingType;
    _wrappingType = options->wrappingType;
    _canBeRenderTarget = options->canBeRenderTarget;
    
    GLint maxTextures;
    glGetIntegerv(GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS, &maxTextures);
    SGL_ASSERT(_sampler < GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS);
    
    SGL_ASSERT(_textureType == RECTANGLE || _textureType == CUBEMAP);
    SGL_ASSERT(_width > 0 && _height > 0);
    SGL_ASSERT(array != nil && array.count > 0);
    
    size_t pixelSize = (_colorType == RGBA) ? 4 : 1;
    size_t faceCount = (_textureType == CUBEMAP) ? 6 : 1;
    size_t textureSize = size_t(_width * _height) * pixelSize * faceCount;
    
    NSData* baseMipData = array[0];
    SGL_ASSERT(baseMipData != nil && baseMipData.length == (NSUInteger)textureSize);
    
    GLint givenMipLevels = (GLint)array.count;
    
    _glType = (_textureType == RECTANGLE) ? GL_TEXTURE_2D : GL_TEXTURE_CUBE_MAP;
    
    glActiveTexture(GL_TEXTURE0 + _sampler);
    
    #ifdef SGL_MAC
        glEnable(_glType);
    #endif
    
    glGenTextures(1, &_glName);
    glBindTexture(_glType, _glName);
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    
    if (_canBeRenderTarget)
    {
        SGL_ASSERT(_glType == GL_TEXTURE_2D);
        glGenFramebuffers(1, &_glFboName);
    }
    
    GLint internalFormatGL;
    GLenum formatGL;
    GLenum typeGL;
    
    if (_colorType == RGBA)
    {
        #ifdef SGL_MAC
            internalFormatGL = GL_RGBA;
            formatGL = GL_BGRA;
            typeGL = GL_UNSIGNED_INT_8_8_8_8_REV;
        #endif
        #ifdef SGL_IOS
            internalFormatGL = GL_RGBA;
            formatGL = GL_RGBA;
            typeGL = GL_UNSIGNED_BYTE;
        #endif
    }
    else
    {
        #ifdef SGL_MAC
            internalFormatGL = GL_RED;
            formatGL = GL_RED;
            typeGL = GL_UNSIGNED_BYTE;
        #endif
        #ifdef SGL_IOS
            internalFormatGL = GL_LUMINANCE;
            formatGL = GL_LUMINANCE;
            typeGL = GL_UNSIGNED_BYTE;
        #endif
    }
    
    if (_samplingType == TRILINEAR) // mipmapping
    {
        _glMinFilter = GL_LINEAR_MIPMAP_LINEAR;
        _glMagFilter = GL_LINEAR;
        
        // If only one mip level has been given, auto-generate all other levels.
        if (givenMipLevels == 1)
        {
            glTexImage2D(_glType, 0, internalFormatGL, _width, _height, 0, formatGL, typeGL, baseMipData.bytes);
            //GL_CHECK_FOR_ERRORS;
            
            glGenerateMipmap(_glType);
            //GL_CHECK_FOR_ERRORS;
            
            IntSize singlePixelSize = IntSize(1);
            _maxMipLevel = [self mipLevelForSize:singlePixelSize];
        }
        else
        {
            _maxMipLevel = givenMipLevels - 1;
            
            for (GLint i = 0; i < givenMipLevels; i++)
            {
                NSData* mipData = array[NSUInteger(i)];
                IntSize mipSize = [self sizeForMipLevel:i];
                
                glTexImage2D(_glType, i, internalFormatGL, mipSize.x, mipSize.y, 0, formatGL, typeGL, mipData.bytes);
                //GL_CHECK_FOR_ERRORS;
            }
        }
    }
    else // no mipmapping
    {
        SGL_ASSERT(givenMipLevels == 1);
        
        _glMinFilter = (_samplingType == NEAREST) ? GL_NEAREST : GL_LINEAR;
        _glMagFilter = (_samplingType == NEAREST) ? GL_NEAREST : GL_LINEAR;
		
        if (_textureType == RECTANGLE)
        {
            glTexImage2D(_glType, 0, internalFormatGL, _width, _height, 0, formatGL, typeGL, baseMipData.bytes);
        }
        else // CUBEMAP
        {
            uint32_t* values = (uint32_t*)baseMipData.bytes;
            
            int faceSize = _width / 4;
            int faceArea = faceSize * faceSize;
            
            // The order is:
            //   1
            // 0 2 4 5
            //   3
            
            glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, internalFormatGL, faceSize, faceSize, 0, formatGL, typeGL, values + 0 * faceArea);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, internalFormatGL, faceSize, faceSize, 0, formatGL, typeGL, values + 1 * faceArea);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, internalFormatGL, faceSize, faceSize, 0, formatGL, typeGL, values + 2 * faceArea);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, internalFormatGL, faceSize, faceSize, 0, formatGL, typeGL, values + 3 * faceArea);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, internalFormatGL, faceSize, faceSize, 0, formatGL, typeGL, values + 4 * faceArea);
            glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, internalFormatGL, faceSize, faceSize, 0, formatGL, typeGL, values + 5 * faceArea);
        }
    }
    
    #ifdef SGL_MAC
        _glWrap = (_wrappingType == CLAMP) ? GL_CLAMP_TO_BORDER : (_wrappingType == REPEAT) ? GL_REPEAT : GL_MIRRORED_REPEAT;
    #endif
    #ifdef SGL_IOS
        _glWrap = (_wrappingType == CLAMP) ? GL_CLAMP_TO_EDGE : (_wrappingType == REPEAT) ? GL_REPEAT : GL_MIRRORED_REPEAT;
    #endif

    return self;
}

- (id) initWithNoise:(TextureOptions*)options;
{
    size_t numBytes = size_t(options->width * options->height) * ((options->colorType == RGBA) ? 4 : 1);
    std::vector<uint8_t> noiseData(numBytes);
    std::generate(noiseData.begin(), noiseData.end(), randomUInt8);
    
    return [self initWithNSData:VectorToData(noiseData) options:options];
}

- (id) initWithConstant:(uint32_t)pixel options:(TextureOptions*)options
{
    uint8_t* comps = (uint8_t*)&pixel;
    std::swap(comps[0], comps[2]);
    
    size_t numPixels = size_t(options->width * options->height);
    
    if (options->colorType == RGBA)
    {
        std::vector<uint32_t> constantData(numPixels, pixel);
        return [self initWithNSData:VectorToData(constantData) options:options];
    }
    else
    {
        std::vector<uint8_t> constantData(numPixels, uint8_t(pixel));
        return [self initWithNSData:VectorToData(constantData) options:options];
    }
}

- (void) dealloc
{
    //NSLog(@"Destroying Texture: %d, %d", width, height);
    [self unload];
}

- (void) unload
{
    glDeleteTextures(1, &_glName);
    
    #ifdef SGL_MAC
        if (_isRenderTarget)
            [self resignRenderTarget];
    #endif
    
    if (_canBeRenderTarget)
        glDeleteFramebuffers(1, &_glFboName);
}

- (GLint) mipLevelForSize:(IntSize)givenSize
{
    SGL_ASSERT(givenSize.x >= 1 && givenSize.y >= 1);
    SGL_ASSERT(givenSize.x <= _width && givenSize.y <= _height);
    
    GLint level = 0;
    
    while (true)
    {
        IntSize mipSize = [self sizeForMipLevel:level];
        
        if (mipSize.x == 1 && mipSize.y == 1)
            return level;
        
        if (mipSize.x < givenSize.x || mipSize.y < givenSize.y)
            return level - 1;
        
        level++;
    }
    
    SGL_ASSERT(false);
    return level;
}

- (IntSize) sizeForMipLevel:(GLint)level
{
    SGL_ASSERT(level >= 0);
    
    int denominator = 0x1 << level;
    
    IntPair result;
    result.x = std::max<int>(1, _width / denominator);
    result.y = std::max<int>(1, _height / denominator);
    
    return result;
}

- (void) setSamplingType:(SamplingType)newType
{
    switch (newType)
    {
        case NEAREST:
            _glMinFilter = GL_NEAREST;
            _glMagFilter = GL_NEAREST;
            break;
            
        case BILINEAR:
            _glMinFilter = GL_LINEAR;
            _glMagFilter = GL_LINEAR;
            break;
        
        case TRILINEAR:
            _glMinFilter = GL_LINEAR_MIPMAP_LINEAR;
            _glMagFilter = GL_LINEAR;
            break;
    }
}

- (void) setWrappingType:(WrappingType)newType
{
    switch (newType)
    {
        case CLAMP:
            
            #ifdef SGL_MAC
                _glWrap = GL_CLAMP_TO_BORDER;
            #endif
            #ifdef SGL_IOS
                _glWrap = GL_CLAMP_TO_EDGE;
            #endif
            
            break;
            
        case REPEAT:
            _glWrap = GL_REPEAT;
            break;
            
        case MIRRORED_REPEAT:
            _glWrap = GL_MIRRORED_REPEAT;
            break;
    }
}

- (void) activate
{
    glActiveTexture(GL_TEXTURE0 + _sampler);
    
    #ifdef SGL_MAC
        glEnable(_glType);
    #endif
    
    glBindTexture(_glType, _glName);
    
    glTexParameteri(_glType, GL_TEXTURE_MIN_FILTER, _glMinFilter);
    glTexParameteri(_glType, GL_TEXTURE_MAG_FILTER, _glMagFilter);
    glTexParameteri(_glType, GL_TEXTURE_WRAP_S,     _glWrap);
    glTexParameteri(_glType, GL_TEXTURE_WRAP_T,     _glWrap);
    
    #ifdef SGL_MAC
        glTexParameteri(_glType, GL_TEXTURE_BASE_LEVEL, 0);
        glTexParameteri(_glType, GL_TEXTURE_MAX_LEVEL,  _maxMipLevel);
    #endif
}

- (void) write:(const void*)data
{
    [self write:data at:IntPair(0, 0) size:IntPair(_width, _height)];
}

- (void) write:(const void*)data at:(IntPoint)p size:(IntSize)s
{
    SGL_ASSERT(data != NULL);
    SGL_ASSERT(_samplingType != TRILINEAR);
    SGL_ASSERT(0 < s.x && 0 < s.y);
    SGL_ASSERT(0 <= p.x && p.x + s.x <= _width);
    SGL_ASSERT(0 <= p.y && p.y + s.y <= _height);
    
    [self activate];
    
    GLenum dataTypeGL;;
    
    if (_colorType == RGBA)
    {
        #ifdef SGL_MAC
            dataTypeGL = GL_BGRA;
        #endif
        #ifdef SGL_IOS
            dataTypeGL = GL_RGBA;
        #endif
    }
    else
    {
        #ifdef SGL_MAC
            dataTypeGL = GL_RED;
        #endif
        #ifdef SGL_IOS
            dataTypeGL = GL_LUMINANCE;
        #endif
    }
    
    glTexSubImage2D(_glType, 0, p.x, p.y, s.x, s.y, dataTypeGL, GL_UNSIGNED_BYTE, data);
}

- (void) becomeRenderTarget
{
    //NSLog(@"%@ becomeRenderTarget", self);
    
    SGL_ASSERT(self.canBeRenderTarget);
        
    #ifdef SGL_MAC
        [self activate];
    #endif
    
    if (_isRenderTarget)
        return;
    
    GLint fbo;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &fbo);
    _parentFboNames.push_back(GLuint(fbo));
    
    GLint temps[4];
    glGetIntegerv(GL_VIEWPORT, temps);
    Viewport viewport = { temps[0], temps[1], temps[2], temps[3] };
    _parentFboViewports.push_back(viewport);
    
    [self checkFramebufferStatus];
    
    glBindFramebuffer(GL_FRAMEBUFFER, _glFboName);
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _glName, 0);
    
    [self checkFramebufferStatus];
    
    _isRenderTarget = YES;
    
    glViewport(0, 0, _width, _height);
}

- (void) resignRenderTarget
{
    //NSLog(@"%@ resignRenderTarget", self);
    
    SGL_ASSERT(self.canBeRenderTarget);
    
    if (!_isRenderTarget)
        return;
    
    [self checkFramebufferStatus];
    
    GLuint fbo = _parentFboNames.back();
    _parentFboNames.pop_back();
    
    glBindFramebuffer(GL_FRAMEBUFFER, fbo);
    
    [self checkFramebufferStatus];
    
    #ifdef SGL_MAC
        if (_samplingType == TRILINEAR)
        {
            [self activate];
            glGenerateMipmap(GL_TEXTURE_2D);
        }
    #endif
    
    _isRenderTarget = NO;
    
    Viewport viewport = _parentFboViewports.back();
    _parentFboViewports.pop_back();
    
    glViewport(viewport[0], viewport[1], viewport[2], viewport[3]);
}

- (void) checkFramebufferStatus
{
    #ifdef DEBUG
        
        GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
        if (status != GL_FRAMEBUFFER_COMPLETE)
        {
            NSLog(@"FRAMEBUFFER IS NOT COMPLETE: %u", status);
            SGL_ASSERT(false);
        }
        
    #endif
}

@end
