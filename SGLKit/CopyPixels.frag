//
//  CopyPixels.frag
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-07.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#include <Platform.glsl>

HIGHP_FLOAT

uniform sampler2D tex;
uniform vec2 texSize;
uniform float alpha;

FRAG_IN vec2 coords;


void main()
{
    FRAG_OUT = texture2D(tex, coords);
    FRAG_OUT.a *= alpha;
}
