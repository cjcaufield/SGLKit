//
// Copyright 2017 Secret Geometry, Inc.  All rights reserved.
//

#ifndef VERTEX_GLSL
#define VERTEX_GLSL

#include <Platform.glsl>

VERT_IN vec4 position;

uniform mat4 modelViewMatrix;
uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec3 lightPosition;
uniform float cameraDistance;

VERT_OUT vec4 userSpacePos;
VERT_OUT vec4 objSpacePos;
VERT_OUT vec4 worldSpacePos;
VERT_OUT vec3 worldSpaceNormal;

void transform(vec4 pos, vec3 norm)
{
    userSpacePos     = position;
    objSpacePos      = pos;
    worldSpacePos    = modelViewMatrix * pos;
    worldSpaceNormal = normalize(normalMatrix * norm);
    gl_Position      = modelViewProjectionMatrix * pos;
}

#endif
