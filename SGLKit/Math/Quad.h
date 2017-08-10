//
//  Quad.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_QUAD_H
#define SGL_QUAD_H

#import "SGLMath.h"

//
// Quad
//

typedef struct quad
{
    vec3 bottomLeft;
    vec3 bottomRight;
    vec3 topRight;
    vec3 topLeft;
    
    #ifdef __cplusplus
        
        quad() {}
        
        quad(vec3 bl, vec3 br, vec3 tr, vec3 tl)
        :
            bottomLeft(bl),
            bottomRight(br),
            topRight(tr),
            topLeft(tl)
        {}
        
        vec3 normal()
        {
            vec3 u = bottomRight - bottomLeft;
            vec3 v = topRight - bottomLeft;
            return normalize(cross(u, v)); // CJC: is this normalize necessary?
        }
        
        aabb boundingBox()
        {
            aabb box;
            
            box.lo.x = min(min(bottomLeft.x, bottomRight.x), min(topRight.x, topLeft.x));
            box.lo.y = min(min(bottomLeft.y, bottomRight.y), min(topRight.y, topLeft.y));
            box.lo.z = min(min(bottomLeft.z, bottomRight.z), min(topRight.z, topLeft.z));
            
            box.hi.x = max(max(bottomLeft.x, bottomRight.x), max(topRight.x, topLeft.x));
            box.hi.y = max(max(bottomLeft.y, bottomRight.y), max(topRight.y, topLeft.y));
            box.hi.z = max(max(bottomLeft.z, bottomRight.z), max(topRight.z, topLeft.z));
            
            return box;
        }
        
    #endif
    
} quad;

#endif
