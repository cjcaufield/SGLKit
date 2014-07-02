//
//  Gaussian.frag
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-07.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#include <Platform.glsl>

HIGHP_FLOAT

uniform sampler2D tex;

FRAG_IN vec2 coords0;
FRAG_IN vec2 coords1;
FRAG_IN vec2 coords2;
FRAG_IN vec2 coords3;

void main()
{
    vec4 sum = texture2D(tex, coords0) +
               texture2D(tex, coords1) +
               texture2D(tex, coords2) +
               texture2D(tex, coords3);
    
    sum *= 0.25;
    
    sum = pow(sum, vec4(0.35));

    sum = clamp(sum, 0.0, 1.0);
    
    FRAG_OUT = sum;
}
