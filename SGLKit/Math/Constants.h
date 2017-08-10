//
//  Constants.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_CONSTANTS_H
#define SGL_CONSTANTS_H

#import "SGLMath.h"

extern struct vec2 ORIGIN_2D;
extern struct vec3 ORIGIN_3D;
extern struct vec4 ORIGIN_4D;

extern struct vec3 BLACK;
extern struct vec3 RED;
extern struct vec3 GREEN;
extern struct vec3 BLUE;
extern struct vec3 CYAN;
extern struct vec3 MAGENTA;
extern struct vec3 YELLOW;
extern struct vec3 WHITE;

extern struct vec4 TRANSPARENT_BLACK;
extern struct vec4 OPAQUE_BLACK;

#define PI            3.1415926535897931
#define HALF_PI       1.5707963267948966
#define QUARTER_PI    0.7853981633974483
#define FLOAT_EPSILON 0.00001f

//
// Global Functions
//

inline float randomFloat()
{
    return ((float)rand()) / ((float)RAND_MAX);
}

inline float randomFloatInRange(float lo, float hi)
{
    return lo + randomFloat() * (hi - lo);
}

inline float radians(float d)
{
    return d * PI / 180.0f;
}

inline float degrees(float r)
{
    return r * 180.0f / PI;
}

#ifdef __cplusplus

    template <typename T>
    T min(const T& a, const T& b)
    {
        return (a < b) ? a : b;
    }

    template <typename T>
    T max(const T& a, const T& b)
    {
        return (a > b) ? a : b;
    }

    template <typename T>
    T mix(const T& a, const T& b, float offset)
    {
        return a + (b - a) * offset;
    }

    template <typename T>
    float length(const T& v)
    {
        return v.length();
    }

    template <typename T>
    float distance(const T& a, const T& b)
    {
        return sqrtf(distancesqrd(a, b));
    }

    template <typename T>
    float distancesqrd(const T& a, const T& b)
    {
        T diff = a - b;
        return dot(diff, diff);
    }

    template <typename T>
    float magnitude(const T& v)
    {
        return sqrtf(magnitudesqrd(v));
    }

    template <typename T>
    float magnitudesqrd(const T& v)
    {
        return dot(v, v);
    }

    template <typename T>
    T normalize(const T& v)
    {
        float len = v.length();
        
        T scaledVector = v;
        
        if (len > 0.0f)
            scaledVector /= len;
        
        return scaledVector;
    }

#endif

#endif
