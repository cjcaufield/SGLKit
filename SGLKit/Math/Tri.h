//
//  Tri.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_TRI_H
#define SGL_TRI_H

#import "SGLMath.h"

//
// Tri
//

typedef struct tri
{
    vec3 a;
    vec3 b;
    vec3 c;
    
    #ifdef __cplusplus
        
        tri() {}
        
        tri(vec3 d, vec3 e, vec3 f) : a(d), b(e), c(f) {}
        
        vec3 normal()
        {
            vec3 u = b - a;
            vec3 v = c - a;
            return cross(u, v).normalize(); // CJC note: is the normalize necessary?
        }
        
    #endif
    
} tri;

#endif
