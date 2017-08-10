//
// Copyright 2017 Secret Geometry, Inc.  All rights reserved.
//

#ifndef FRAGMENT_GLSL
#define FRAGMENT_GLSL

#include <Platform.glsl>
#include <Utilities.glsl>

//#define ONLY_SHOW_COVERAGE
//#define ONLY_SHOW_COLORS
//#define ONLY_SHOW_NORMALS
//#define ONLY_SHOW_NDOTL
//#define ONLY_SHOW_OCCLUSION

// Uniforms.
uniform vec4 color;
uniform float shininess;
uniform float lightLevel;
uniform vec3 lightPosition;
uniform float cameraDistance;

FRAG_IN vec4 userSpacePos;
FRAG_IN vec4 objSpacePos;
FRAG_IN vec4 worldSpacePos;
FRAG_IN vec3 worldSpaceNormal;

const vec3  LIGHT_COLOR = vec3(0.6);
const vec3  AMBIENT_LIGHT_COLOR = vec3(0.4);
const float AMBIENT_OCCLUSION_EXP = 8.0;
const float IMAGE_KEY = 0.05;
const float MIDZONE_LUMINANCE = 0.18;
const float WHITE_LUMINANCE = 1.00;

// Globals.
vec3  norm;
vec3  lightVec;
vec3  eyeVec;
vec3  halfVec;
float normalDotLight;
float normalDotEye;
float normalDotHalf;


void calculateVectors(vec3 normalDir)
{
    norm           = normalize(normalDir);
    lightVec       = normalize(lightPosition - worldSpacePos.xyz);
    eyeVec         = normalize(vec3(0.0) - worldSpacePos.xyz);
    halfVec        = normalize(lightVec + eyeVec);
    normalDotLight = max(0.0, dot(norm, lightVec));
    normalDotEye   = max(0.0, dot(norm, eyeVec));
    normalDotHalf  = max(0.0, dot(norm, halfVec));
}

void draw(vec4 color, float shininess, float occlusion, float shadow, vec3 reflection, vec3 emissive)
{
    #ifdef ONLY_SHOW_COVERAGE
        FRAG_OUT = vec4(RED, 1.0);
        return;
    #endif
    
    #ifdef ONLY_SHOW_COLORS
        FRAG_OUT = color;
        return;
    #endif
    
    #ifdef ONLY_SHOW_NORMALS
        FRAG_OUT = vec4(norm, 1.0);
        return;
    #endif
    
    #ifdef ONLY_SHOW_NDOTL
        FRAG_OUT = vec4(vec3(normalDotLight), 1.0);
        return;
    #endif
    
    #ifdef ONLY_SHOW_OCCLUSION
        FRAG_OUT = vec4(vec3(occlusion), 1.0);
        return;
    #endif
    
    vec3 ambient = (1.0 - occlusion) * color.rgb * AMBIENT_LIGHT_COLOR;
    
    vec3 diffuse = (1.0 - shadow) * normalDotLight * color.rgb * LIGHT_COLOR;
    
    vec3 specular = (1.0 - shadow) * pow(normalDotHalf, shininess) * 0.3 * WHITE * LIGHT_COLOR;
    
    vec3 finalColor = emissive + lightLevel * (ambient + diffuse + specular + reflection);
    
    FRAG_OUT = vec4(finalColor, color.a);
}

#endif
