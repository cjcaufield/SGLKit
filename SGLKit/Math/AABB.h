//
//  AABB.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_AABB_H
#define SGL_AABB_H

#import "SGLMath.h"

//
// AABB
//

typedef struct aabb
{
    vec3 lo;
    vec3 hi;
        
    #ifdef __cplusplus
        
        aabb() {}
        
        aabb(vec3 low, vec3 high) : lo(low), hi(high) {}
        
        bool contains(vec3 p)
        {
            return lo.x <= p.x && p.x <= hi.x &&
            lo.y <= p.y && p.y <= hi.y &&
            lo.z <= p.z && p.z <= hi.z;
        }
        
        float width()  {return hi.x - lo.x;}
        float height() {return hi.y - lo.y;}
        float depth()  {return hi.z - lo.z;}
        
    #endif
    
} aabb;

#endif
