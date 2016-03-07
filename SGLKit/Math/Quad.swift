//
//  Quad.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Quad
//

extension quad {
    
    public init() {
        let p = ORIGIN_3D
        self.init(bottomLeft: p, bottomRight: p, topRight: p, topLeft: p)
    }
    
    public init(bottomLeft: vec3, bottomRight: vec3, topRight: vec3, topLeft: vec3) {
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
        self.topRight = topRight
        self.topLeft = topLeft
    }
    
    public func normal() -> vec3 {
        let u = self.bottomRight - self.bottomLeft
        let v = self.topRight - self.bottomLeft
        return normalize(cross(u, v)) // CJC note: is the normalize necessary?
    }
    
    public func boundingBox() -> aabb {
        
        var box = aabb()
        
        box.lo.x = min(min(bottomLeft.x, bottomRight.x), min(topRight.x, topLeft.x))
        box.lo.y = min(min(bottomLeft.y, bottomRight.y), min(topRight.y, topLeft.y))
        box.lo.z = min(min(bottomLeft.z, bottomRight.z), min(topRight.z, topLeft.z))
        
        box.hi.x = max(max(bottomLeft.x, bottomRight.x), max(topRight.x, topLeft.x))
        box.hi.y = max(max(bottomLeft.y, bottomRight.y), max(topRight.y, topLeft.y))
        box.hi.z = max(max(bottomLeft.z, bottomRight.z), max(topRight.z, topLeft.z))
        
        return box
    }
}
