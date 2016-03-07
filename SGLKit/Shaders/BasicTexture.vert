//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#include <Platform.glsl>
#include <Vertex.glsl>

VERT_IN vec3 normal;
VERT_IN vec4 texCoord;

VERT_OUT vec2 coord;

void main()
{
    transform(position, normal);
    
    coord = texCoord.st;
}
