//
//  Ray.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Ray
//

extension ray {
    
    public init() {
        let p = ORIGIN_3D
        self.init(from: p, to: p)
    }
    
    public init(from: vec3, to: vec3) {
        self.origin = from
        self.target = to
    }
    
    public func direction() -> vec3 {
        return normalize(self.target - self.origin)
    }
}

public func +=(r: inout ray, v: vec3) {
    r.origin += v
    r.target += v
}

public func -=(r: inout ray, v: vec3) {
    r.origin -= v
    r.target -= v
}

public func *=(r: inout ray, v: vec3) {
    r.origin *= v
    r.target *= v
}

public func /=(r: inout ray, v: vec3) {
    r.origin /= v
    r.target /= v
}
