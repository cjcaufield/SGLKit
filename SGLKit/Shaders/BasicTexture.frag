//
// Copyright 2017 Secret Geometry, Inc.  All rights reserved.
//

#include <Platform.glsl>

HIGHP_FLOAT

#include <Fragment.glsl>

uniform sampler2D texture;

FRAG_IN vec2 coord;

void main()
{
    calculateVectors(worldSpaceNormal);
    
    vec4 texColor = texture2D(texture, coord);
    
    draw(texColor,  // color
         shininess, // shininess
         0.0,       // occlusion
         0.0,       // shadow
         BLACK,     // reflection
         BLACK);    // emissive
}
