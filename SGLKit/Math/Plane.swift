//
//  Plane.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Plane
//

extension plane {
    
    public init() {
        self.init(point: ORIGIN_3D, normal: vec3(0.0))
    }
    
    public init(point: vec3, normal: vec3) {
        self.point = point
        self.normal = normal
    }
}

public func distance(_ p: plane, _ v: vec3) -> Float {
    return dot(v - p.point, p.normal)
}

public func infront(_ p: plane, v: vec3) -> Bool {
    return distance(p, v) > Float(0.0)
}
