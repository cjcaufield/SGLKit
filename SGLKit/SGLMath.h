//
//  SGLMath.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_MATH_H
#define SGL_MATH_H

struct ivec2;
struct vec2;
struct vec3;
struct vec4;
struct sphere;
struct ray;
struct aabb;
struct tri;
struct quad;
struct plane;
struct mat3;
struct mat4;

#include <stdlib.h>
#include <math.h>

#ifdef SGL_IOS
    #import <UIKit/UIKit.h>
#endif

#import <CoreGraphics/CGGeometry.h>

#ifdef __cplusplus
    #include <algorithm>
#endif

#import "SGLDebug.h"
#import "SGLTypes.h"
#import "Constants.h"
#import "IVec2.h"
#import "Vec2.h"
#import "Vec3.h"
#import "Vec4.h"
#import "Sphere.h"
#import "Ray.h"
#import "AABB.h"
#import "Tri.h"
#import "Quad.h"
#import "Plane.h"
#import "Mat3.h"
#import "Mat4.h"
#import "Conversions.h"
#import "Functions.h"

#endif
