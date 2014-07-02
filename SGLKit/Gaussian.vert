//
//  Gaussian.vert
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-07.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#include <Platform.glsl>

VERT_IN vec4 position;
VERT_IN vec4 texCoord;

uniform vec2 texSize;
uniform vec2 outputSize;

VERT_OUT vec2 coords0;
VERT_OUT vec2 coords1;
VERT_OUT vec2 coords2;
VERT_OUT vec2 coords3;

void main()
{
    gl_Position = position;
    
    vec2 step = vec2(0.5) / texSize;
    
    coords0 = texCoord.st + vec2(-1,  0) * step;
    coords1 = texCoord.st + vec2( 0, -1) * step;
    coords2 = texCoord.st + vec2(+1,  0) * step;
    coords3 = texCoord.st + vec2( 0, +1) * step;
}
