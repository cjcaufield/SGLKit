//
// Copyright 2017 Secret Geometry, Inc.  All rights reserved.
//

#include <Platform.glsl>
#include <Vertex.glsl>

VERT_IN vec3 color;

VERT_OUT vec3 v_Color;

void main()
{
    v_Color = color;
    
    vec3  unusedNormal = vec3(0.0, 0.0, 1.0);
    
    transform(position, unusedNormal);
}
