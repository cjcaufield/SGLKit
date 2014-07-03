//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#include <Platform.glsl>

HIGHP_FLOAT

#include <Fragment.glsl>

FRAG_IN vec3 v_Color;

void main()
{
    FRAG_OUT = color * vec4(v_Color, 1.0);
}
