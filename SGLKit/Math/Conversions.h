//
//  Conversions.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#ifndef SGL_CONVERSIONS_H
#define SGL_CONVERSIONS_H

#import "SGLMath.h"

#ifdef __cplusplus

    inline ivec2::ivec2(const vec2& v) : x(v.x), y(v.y) {}

    inline vec2::vec2(const vec3& v) : x(v.x), y(v.y) {}

    inline vec2::vec2(const vec4& v) : x(v.x), y(v.y) {}

    inline vec3::vec3(const vec4& v) : x(v.x), y(v.y), z(v.z) {}

    inline vec3::vec3(XXColor* color)
    {
        vec4 v = vec4(color);
        
        x = v.x;
        y = v.y;
        z = v.z;
    }

    inline mat3::mat3(const mat4& m)
    {
        for (int i = 0; i < 3; i++)
            for (int j = 0; j < 3; j++)
                at(i, j) = m.at(i, j);
    }

#endif

#endif
