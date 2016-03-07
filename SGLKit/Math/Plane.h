//
//  Plane.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#ifndef SGL_PLANE_H
#define SGL_PLANE_H

#import "SGLMath.h"

//
// Plane
//

typedef struct plane
{
    vec3 point;
    vec3 normal;
    
    #ifdef __cplusplus
        
        plane() {}
        
        plane(vec3 p, vec3 n) : point(p), normal(n) {}
        
    #endif
    
} plane;

#ifdef __cplusplus

    inline float distance(const plane& p, vec3 v)
    {
        return dot(v - p.point, p.normal);
    }

    inline bool infront(const plane& p, vec3 v)
    {
        return distance(p, v) > 0.0f;
    }

#endif

#endif
