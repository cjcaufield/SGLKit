//
//  Ray.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#ifndef SGL_RAY_H
#define SGL_RAY_H

#import "SGLMath.h"

//
// Ray
//

typedef struct ray
{
    vec3 origin;
    vec3 target;
    
    #ifdef __cplusplus
        
        ray() {}
        
        ray(vec3 from, vec3 to) : origin(from), target(to) {}
        
        ray& operator+=(const vec3& v)
        {
            origin += v;
            target += v;
            return *this;
        }
        
        ray& operator-=(const vec3& v)
        {
            origin -= v;
            target -= v;
            return *this;
        }
        
        ray& operator*=(const vec3& v)
        {
            origin *= v;
            target *= v;
            return *this;
        }
        
        ray& operator/=(const vec3& v)
        {
            origin /= v;
            target /= v;
            return *this;
        }
        
        vec3 direction()
        {
            return normalize(target - origin);
        }
        
    #endif
    
} ray;

#endif
