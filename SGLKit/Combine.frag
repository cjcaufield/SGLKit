//
// Copyright 2014 Secret Geometry, Inc.  All rights reserved.
//

#include <Platform.glsl>

HIGHP_FLOAT

#include <Utilities.glsl>

uniform sampler2D newTex;
uniform sampler2D oldTex;
uniform vec2      texSize;
uniform float     oldTexAge;
uniform float     fade;

FRAG_IN vec2 coords;


void main()
{
    vec4 newColor = texture2D(newTex, coords);
    vec4 oldColor = texture2D(oldTex, coords);
    
    FRAG_OUT = fadeBetweenColors(oldColor, newColor, oldTexAge, fade);
}
