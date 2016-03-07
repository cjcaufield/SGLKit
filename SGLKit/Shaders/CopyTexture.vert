//
//  CopyTexture.vert
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-07.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#include <Platform.glsl>

VERT_IN vec4 position;
VERT_IN vec4 texCoord;

VERT_OUT vec2 coords;


void main()
{
    gl_Position = position;
    
    coords = texCoord.st;
}
