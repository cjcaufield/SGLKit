//
//  Tri.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Tri
//

extension tri {
    
    public init() {
        let p = ORIGIN_3D
        self.init(p, p, p)
    }
    
    public init(_ a: vec3, _ b: vec3, _ c: vec3) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    public func normal() -> vec3 {
        let u = self.b - self.a
        let v = self.c - self.a
        var c = cross(u, v)
        c.normalize() // CJC: is the normalize necessary?
        return c
    }
}
