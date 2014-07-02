//
//  SGLUtilities.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLDebug.h"
#import "SGLTypes.h"
#import "SGLMath.h"
#import "SGLTexture.h"
#include <vector>

void SGLCheckForErrors();

#ifdef SGL_MAC
    void ExitGracefully(NSString* message);
#endif

void SwapTextures(__strong SGLTexture** tex1, __strong SGLTexture** tex2);

void DrawTexture(SGLTexture* tex, vec2 outputSize, SamplingType samplingType);

bool operator==(const NSRange& a, const NSRange& b);
bool operator==(const CGPoint& a, const CGPoint& b);
bool operator==(const CGSize& a, const CGSize& b);
bool operator==(const CGRect& a, const CGRect& b);

CGPoint Vec2ToPoint(vec2 vec);
vec2 PointToVec2(CGPoint point);

CGPoint IVec2ToPoint(ivec2 vec);
ivec2 PointToIVec2(CGPoint size);

CGSize Vec2ToSize(vec2 vec);
vec2 SizeToVec2(CGSize size);

CGSize IVec2ToSize(ivec2 vec);
ivec2 SizeToIVec2(CGSize size);

NSArray* Vec3ToArray(vec3 vec);
vec3 ArrayToVec3(NSArray* array);

XXColor* Vec3ToColor(vec3 vec);
vec3 ColorToVec3(XXColor* color);

XXColor* Vec4ToColor(vec4 vec);
vec4 ColorToVec4(XXColor* color);

template <typename T, int N>
NSData* CArrayToData(T (&array)[N])
{
    unsigned long length = N * sizeof(T);
    return [NSData dataWithBytesNoCopy:array length:length freeWhenDone:NO];
}

template <typename T>
NSData* VectorToData(std::vector<T>& vec)
{
    unsigned long length = vec.size() * sizeof(T);
    return [NSData dataWithBytesNoCopy:&vec[0] length:length freeWhenDone:NO];
}

@interface NSMutableArray (Unique)

- (void) addObjectIfUnique:(id)object;

@end
