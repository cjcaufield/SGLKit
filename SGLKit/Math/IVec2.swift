//
//  IVec2.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation
import CoreGraphics

//
// IVec2
//

extension ivec2: GenericVector {
    
    public init() {
        self.init(0)
    }
    
    public init(_ i: Int32) {
        self.init(i, i)
    }
    
    public init(_ i: Int32, _ j: Int32) {
        self.x = i
        self.y = j
    }
    public init(_ v: vec2) {
        self.init(Int32(v.x), Int32(v.y))
    }
    
    public init(_ point: CGPoint) {
        self.init(Int32(point.x), Int32(point.y))
    }
    
    public init(_ size: CGSize) {
        self.init(Int32(size.width), Int32(size.height))
    }
    
    func toPoint() -> CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    func toSize() -> CGSize {
        return CGSize(width: CGFloat(x), height: CGFloat(y))
    }
    
    subscript(index: Int32) -> Int32 {
        get {
            switch index {
            case 0:
                return self.x
            case 1:
                return self.y
            default:
                assert(false)
                return 0
            }
        }
        set {
            switch index {
            case 0:
                self.x = newValue
            case 1:
                self.y = newValue
            default:
                assert(false)
            }
        }
    }
    
    public func at(_ index: Int32) -> Int32 {
        return self[index]
    }
    
    public func aspect() -> Float {
        return Float(x) / Float(y)
    }
    
    public func length() -> Float {
        return distance(self, ivec2(0))
    }
    
    public func dot(_ v: ivec2) -> Float {
        return Float(self.x * v.x + self.y * v.y)
    }
}

// Arithmetic operators.

public func +(a: ivec2, b: ivec2) -> ivec2 {
    return ivec2(a.x + b.x, a.y + b.y)
}

public func -(a: ivec2, b: ivec2) -> ivec2 {
    return ivec2(a.x - b.x, a.y - b.y)
}

public func *(v: ivec2, k: Int32) -> ivec2 {
    return ivec2(v.x * k, v.y * k)
}

public func *(k: Int32, v: ivec2) -> ivec2 {
    return ivec2(k * v.x, k * v.y)
}

public func *(v: ivec2, k: Float) -> ivec2 {
    return ivec2(Int32(Float(v.x) * k), Int32(Float(v.y) * k))
}

public func *(k: Float, v: ivec2) -> ivec2 {
    return ivec2(Int32(k * Float(v.x)), Int32(k * Float(v.y)))
}

public func *(a: ivec2, b: ivec2) -> ivec2 {
    return ivec2(a.x * b.x, a.y * b.y)
}

public func /(v: ivec2, k: Int32) -> ivec2 {
    return ivec2(v.x / k, v.y / k)
}

public func /(v: ivec2, k: Float) -> ivec2 {
    return ivec2(Int32(Float(v.x) / k), Int32(Float(v.y) / k))
}

public func /(a: ivec2, b: ivec2) -> ivec2 {
    return ivec2(a.x / b.x, a.y / b.y)
}

// Mutating arithmetic operators.

public func +=(a: inout ivec2, b: ivec2) {
    a.x += b.x
    a.y += b.y
}

public func -=(a: inout ivec2, b: ivec2) {
    a.x -= b.x
    a.y -= b.y
}

public func *=(a: inout ivec2, b: ivec2) {
    a.x *= b.x
    a.y *= b.y
}

public func /=(a: inout ivec2, b: ivec2) {
    a.x /= b.x
    a.y /= b.y
}

// Equality operators.

public func ==(a: ivec2, b: ivec2) -> Bool {
    return a.x == b.x && a.y == b.y
}

public func !=(a: ivec2, b: ivec2) -> Bool {
    return a.x != b.x || a.y != b.y
}

typealias Int32Pair  = ivec2
typealias Int32Point = ivec2
typealias Int32Size  = ivec2
