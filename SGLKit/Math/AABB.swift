//
//  AABB.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// AABB
//

extension aabb {
    
    public init() {
        let p = ORIGIN_3D
        self.init(low: p, high: p)
    }
    
    public init(low: vec3, high: vec3) {
        self.lo = low
        self.hi = high
    }
    
    public var width: Float {
        return hi.x - lo.x
    }
    
    public var height: Float {
        return hi.y - lo.y
    }
    
    public var depth: Float {
        return hi.z - lo.z
    }
    
    public func contains(_ p: vec3) -> Bool {
        
        return lo.x <= p.x && p.x <= hi.x &&
               lo.y <= p.y && p.y <= hi.y &&
               lo.z <= p.z && p.z <= hi.z
    }
}
