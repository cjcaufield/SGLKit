//
// Copyright 2017 Secret Geometry, Inc.  All rights reserved.
//

#include <Platform.glsl>

HIGHP_FLOAT

uniform sampler2D inputTex;
uniform vec2      inputTexSize;

void main()
{
    vec2 coords = gl_FragCoord.st / inputTexSize;
    FRAG_OUT = texture2D(inputTex, coords);
}
