//
//  Sphere.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Sphere
//

extension sphere {
    
    public init() {
        self.init(center: ORIGIN_3D, radius: 0.0)
    }
    
    public init(center: vec3, radius: Float) {
        self.center = center
        self.radius = radius
    }
    
    public func circumference() -> Float {
        return 2.0 * Float(PI) * self.radius
    }
    
    public func contains(point: vec3) -> Bool {
        return distancesqrd(self.center, point) <= self.radius * self.radius
    }
    
    public func convertSphereCoordsToCartesian(coords: vec2) -> vec3 {
        
        // Find the point on the sphere when it's at the origin.
        let angles = convertSphereCoordsToEuler(coords)
        
        // Calculate the point.
        let r = +self.radius
        let x = -sin(angles.y) * r
        let y = +sin(angles.x) * r
        let z = -sqrt(r * r - x * x - y * y)
        
        // Move the point back into the sphere's space.
        return vec3(x, y, z) + self.center
    }
    
    public func convertSphereCoordsToEuler(coords: vec2) -> vec2 {
        return vec2(-coords.x / radius, +coords.y / radius)
    }
}
