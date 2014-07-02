//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#include <Platform.glsl>

HIGHP_FLOAT

#include <Fragment.glsl>

void main()
{
    calculateVectors(worldSpaceNormal);
    
    draw(color,     // color
         shininess, // shininess
         0.0,       // occlusion
         0.0,       // shadow
         BLACK,     // reflection
         BLACK);    // emissive
}
