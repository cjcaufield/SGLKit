//
//  Functions.mm
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#import "SGLMath.h"

bool intersect(ray& r, sphere& s, float sphereAspect, vec3* intersectPos)
{
    ray theray = r;
    sphere thesphere = s;
    
    vec3 sphereOffset = thesphere.center;
    
    // Translate the ray and the sphere so that the sphere is at the origin.
    thesphere.center -= sphereOffset;
    theray -= sphereOffset;
    
    if (sphereAspect > 1.0)
        theray /= vec3(sphereAspect, 1.0, 1.0);
    else
        theray *= vec3(1.0, sphereAspect, 1.0);
    
    vec3 rayDirection = theray.direction();
    
    // Compute A, B and C coefficients.
    float a = dot(rayDirection, rayDirection);
    float b = 2.0 * dot(rayDirection, theray.origin);
    float c = dot(theray.origin, theray.origin) - (thesphere.radius * thesphere.radius);
    
    // Find discriminant.
    float disc = b * b - 4 * a * c;
    
    // If discriminant is negative there are no real roots, so return false as ray misses sphere.
    if (disc < 0)
        return false;
    
    // Compute q as described above.
    float distSqrt = sqrtf(disc);
    float sign = (b < 0) ? -1.0 : +1.0;
    float q = (-b + sign * distSqrt) / 2.0;
    
    // Compute t0 and t1.
    float t0 = q / a;
    float t1 = c / q;
    
    // Make sure t0 is smaller than t1.
    if (t0 > t1)
        std::swap(t0, t1);
    
    // If t1 is less than zero, the object is in the ray's negative direction and consequently the ray misses the sphere.
    if (t1 < 0)
        return false;
    
    float intersectOffset = (t0 < 0) ? t1 : t0;
    
    vec3 solution = theray.origin + rayDirection * intersectOffset;
    
    if (sphereAspect > 1.0)
        solution.x *= sphereAspect;
    else
        solution.y /= sphereAspect;
    
    solution += sphereOffset;
    
    *intersectPos = solution;
    
    return true;
}

bool intersects(const ray& aray, const tri& atri)
{
    // Calculate the triangle's edge vectors and normal.
    vec3 u = atri.b - atri.a;
    vec3 v = atri.c - atri.a;
    vec3 n = cross(u, v);
    
    // No degenerate triangles, please.
    SGL_ASSERT(n.length() >= FLOAT_EPSILON);
    
    //
    vec3 dir = aray.target - aray.origin;
    vec3 way = aray.origin - atri.a;
    float a = -dot(n, way);
    float b = +dot(n, dir);
    
    // Check if the line is parallel to the triangle's plane.
    if (fabsf(b) < FLOAT_EPSILON)
        return false;
    
    // Calculate the intersection between the line and the triangle's plane.
    float q = a / b;
    if (q < 0.0f)
        return false;
    vec3 intersect = aray.origin + dir * q;
    
    // Generate some intermediates for our parametric coord.
    
    float uu = dot(u, u);
    float uv = dot(u, v);
    float vv = dot(v, v);
    float d  = uv * uv - uu * vv;
    
    vec3  w  = intersect - atri.a;
    float wu = dot(w, u);
    float wv = dot(w, v);
    
    // Test whether the parametric coord (s,t) is within the triangle.
    float s = (uv * wv - vv * wu) / d;
    if (s < 0.0f || s > 1.0f)
        return false;
    
    float e = (uv * wu - uu * wv) / d;
    
    if (e < 0.0f || (s + e) > 1.0f)
        return false;
    
    return true;
}

bool intersects(const ray& r, const quad& q)
{
    // There must be a better method, but this is the easiest for now.
    
    tri tri1(q.bottomLeft, q.bottomRight, q.topLeft);
    tri tri2(q.topLeft, q.bottomRight, q.topRight);
    
    return intersects(r, tri1) || intersects(r, tri2);
}
