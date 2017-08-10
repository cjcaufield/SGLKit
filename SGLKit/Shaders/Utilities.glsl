//
// Copyright 2017 Secret Geometry, Inc.  All rights reserved.
//

#ifndef UTILITIES_GLSL
#define UTILITIES_GLSL

const float PI         = 3.14159265358979323846264;
const float HALF_PI    = PI / 2.0;
const float QUARTER_PI = PI / 4.0;

const vec2  ORIGIN_2D = vec2(0.0, 0.0);
const vec3  ORIGIN_3D = vec3(0.0, 0.0, 0.0);
const vec4  ORIGIN_4D = vec4(0.0, 0.0, 0.0, 0.0);

const vec3  BLACK   = vec3(0.0, 0.0, 0.0);
const vec3  RED     = vec3(1.0, 0.0, 0.0);
const vec3  GREEN   = vec3(0.0, 1.0, 0.0);
const vec3  BLUE    = vec3(0.0, 0.0, 1.0);
const vec3  CYAN    = vec3(0.0, 1.0, 1.0);
const vec3  MAGENTA = vec3(1.0, 0.0, 1.0);
const vec3  YELLOW  = vec3(1.0, 1.0, 0.0);
const vec3  WHITE   = vec3(1.0, 1.0, 1.0);

const float EPSILON = 0.000001;

float linearstep(float lo, float hi, float x)
{
    return (clamp(x, lo, hi) - lo) / (hi - lo);
}

// Given a float [0.0, 1.0], returns an int [0, 255].
int uint8(float value)
{
    return int(floor(255.0 * value + 0.5));
}

// "Proximity" is here defined as a function of distance, such that:
// - two identical points have a proximity of 1.0.
// - two points with a distance of more than 0.5 have a proximity of 0.0.
// - inbetween, values are linearly interpolated.

float proximity(float dist)
{
    return -2.0 * dist + 1.0;
}

vec2 proximity(vec2 dists)
{
    return -2.0 * dists + 1.0;
}

// 
vec4 addColorsWithAlpha(vec4 colorAbove, vec4 colorBelow)
{
    vec3 scaledColorAbove = colorAbove.rgb * colorAbove.a;
    vec3 scaledColorBelow = colorBelow.rgb * colorBelow.a;
    
    float oneMinusAlpha = (1.0 - colorAbove.a);
    
    vec3 outColor = scaledColorAbove + oneMinusAlpha * scaledColorBelow;
    
    float outAlpha = colorAbove.a + oneMinusAlpha * colorBelow.a;
    
    // The divide below keeps this operation associative, but changes the look slightly.
    outColor.rgb /= (outAlpha + EPSILON);
    
    return vec4(outColor, outAlpha);
}

// 
float perpendicularAdd(float a, float b)
{
	// 2D.
    //return a + b - a * b;
    
	// 3D.
    float a2 = a * a;
    float b2 = b * b;
    return a2 + b2 - a2 * b2;
}

//
vec4 transparentize(vec3 color)
{
    float maxComponent = max(color.r, max(color.g, color.b));
    vec3 finalColor = color.rgb * ((1.0 + EPSILON) / (maxComponent + EPSILON));
    return vec4(finalColor, maxComponent);
}

//
vec4 transparentize(vec4 color)
{
    vec4 newColor = transparentize(color.rgb);
    newColor.a *= color.a;
    return newColor;
}

// 
vec4 fadeBetweenColors(vec4 oldColor, vec4 newColor, float oldColorAge, float fade)
{
    const float MAX_FADE_TIME = 0.5;
    
    float offset = (oldColorAge + EPSILON) / (fade * MAX_FADE_TIME + EPSILON);
    offset = clamp(offset, 0.0, 1.0);
    
    oldColor *= (1.0 - offset);
    return max(oldColor, newColor);
}

#endif
