//
//  Sphere.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_SPHERE_H
#define SGL_SPHERE_H

#import "SGLMath.h"

//
// Sphere
//

typedef struct sphere
{
    vec3 center;
    float radius;
    
    #ifdef __cplusplus
        
        sphere() {}
        
        sphere(vec3 p, float r) : center(p), radius(r) {}
        
        float circumference() const
        {
            return 2.0f * PI * radius;
        }
        
        bool contains(vec3 point) const
        {
            return distancesqrd(center, point) <= radius * radius;
        }
        
        vec3 convertSphereCoordsToCartesian(vec2 coords) const
        {
            // Find the point on the sphere when it's at the origin.
            vec2 angles = convertSphereCoordsToEuler(coords);
            
            // Calculate the point.
            float r = +radius;
            float x = -sin(angles.y) * r;
            float y = +sin(angles.x) * r;
            float z = -sqrt(r * r - x * x - y * y);
            
            // Move the point back into the sphere's space.
            return vec3(x, y, z) + center;
        }
        
        vec2 convertSphereCoordsToEuler(vec2 coords) const
        {
            return vec2(-coords.x / radius, +coords.y / radius);
        }
        
    #endif
    
} sphere;

#endif
