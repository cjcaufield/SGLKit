//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#include <Vertex.glsl>

VERT_IN vec3 normal;

void main()
{
    transform(position, normal);
}