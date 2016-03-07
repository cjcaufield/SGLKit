//
//  Functions.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

public func intersect(r: ray, s: sphere, sphereAspect: Float, inout intersectPos: vec3) -> Bool
{
    var theray = r
    var thesphere = s
    
    let sphereOffset = thesphere.center
    
    // Translate the ray and the sphere so that the sphere is at the origin.
    
    thesphere.center -= sphereOffset
    theray -= sphereOffset
    
    if sphereAspect > 1 {
        theray /= vec3(sphereAspect, 1.0, 1.0)
    } else {
        theray *= vec3(1.0, sphereAspect, 1.0)
    }
    
    let rayDirection = theray.direction()
    
    // Compute A, B and C coefficients.
    
    let a = dot(rayDirection, rayDirection)
    let b = 2.0 * dot(rayDirection, theray.origin)
    let c = dot(theray.origin, theray.origin) - (thesphere.radius * thesphere.radius)
    
    // Find discriminant.
    
    let disc = b * b - 4.0 * a * c
    
    // If discriminant is negative there are no real roots, so return false as ray misses sphere.
    
    if disc < 0.0 {
        return false
    }
    
    // Compute q as described above.
    
    let distSqrt = sqrtf(disc)
    let sign: Float = (b < 0) ? -1.0 : +1.0
    let q = (-b + sign * distSqrt) / 2.0
    
    // Compute t0 and t1.
    
    var t0 = q / a
    var t1 = c / q
    
    // Make sure t0 is smaller than t1.
    
    if t0 > t1 {
        swap(&t0, &t1)
    }
    
    // If t1 is less than zero, the object is in the ray's negative direction and consequently the ray misses the sphere.
    
    if t1 < 0 {
        return false
    }
    
    let intersectOffset = (t0 < 0) ? t1 : t0
    
    var solution = theray.origin + rayDirection * intersectOffset
    
    if sphereAspect > 1 {
        solution.x *= sphereAspect
    } else {
        solution.y /= sphereAspect
    }
    
    solution += sphereOffset
    
    intersectPos = solution
    
    return true
}

public func intersects(aray: ray, _ atri: tri) -> Bool
{
    // Calculate the triangle's edge vectors and normal.
    
    let u = atri.b - atri.a
    let v = atri.c - atri.a
    let n = cross(u, v)
    
    // No degenerate triangles, please.
    
    assert(n.length() >= FLOAT_EPSILON)
    
    let dir = aray.target - aray.origin
    let way = aray.origin - atri.a
    
    let a = -dot(n, way)
    let b = +dot(n, dir)
    
    // Check if the line is parallel to the triangle's plane.
    
    if fabsf(b) < FLOAT_EPSILON {
        return false
    }
    
    // Calculate the intersection between the line and the triangle's plane.
    
    let q = a / b
    
    if q < 0.0 {
        return false
    }
    
    //let test1 = dir * q
    //let test2 = q * dir
    
    let intersect = aray.origin + dir * q
    
    // Generate some intermediates for our parametric coord.
    
    let uu = dot(u, u)
    let uv = dot(u, v)
    let vv = dot(v, v)
    let d  = uv * uv - uu * vv
    
    let w = intersect - atri.a
    let wu = dot(w, u)
    let wv = dot(w, v)
    
    // Test whether the parametric coord (s,t) is within the triangle.
    
    let s = (uv * wv - vv * wu) / d
    
    if s < 0 || s > 1 {
        return false
    }
    
    let e = (uv * wu - uu * wv) / d
    
    if e < 0 || (s + e) > 1 {
        return false
    }
    
    return true
}

public func intersects(r: ray, q: quad) -> Bool {
    
    // There are better methods, but this is the easiest for now.
    
    let tri1 = tri(q.bottomLeft, q.bottomRight, q.topLeft)
    let tri2 = tri(q.topLeft, q.bottomRight, q.topRight)
    
    return intersects(r, tri1) || intersects(r, tri2)
}
