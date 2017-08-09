//
//  Vec2.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Vec2
//

extension vec2: GenericVector {
    
    public init() {
        self.init(0.0)
    }
    
    public init(_ i: Float) {
        self.init(i, i)
    }
    
    public init(_ i: Float, _ j: Float) {
        self.x = i
        self.y = j
    }
    
    public init(_ v: ivec2) {
        self.init(Float(v.x), Float(v.y))
    }
    
    public init(_ point: CGPoint) {
        self.init(Float(point.x), Float(point.y))
    }
    
    public init(_ size: CGSize) {
        self.init(Float(size.width), Float(size.height))
    }
    
    func toPoint() -> CGPoint {
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    func toSize() -> CGSize {
        return CGSize(width: CGFloat(x), height: CGFloat(y))
    }
    
    public func indexIsValid(_ index: Int) -> Bool {
        return index < 4
    }
    
    subscript(index: Int) -> Float {
        get {
            switch index {
            case 0:
                return self.x
            case 1:
                return self.y
            default:
                assert(false)
                return 0.0
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
    
    public func at(_ index: Int) -> Float {
        return self[index]
    }
    
    public func aspect() -> Float {
        return x / y
    }
    
    public func length() -> Float {
        return distance(self, ORIGIN_2D)
    }
    
    public func dot(_ v: vec2) -> Float {
        return self.x * v.x + self.y * v.y
    }
    
    public mutating func normalize() {
        let l = length()
        if l > 0.0 {
            self /= l
        }
    }
}

// Arithmetic operators.

public func +(a: vec2, b: vec2) -> vec2 {
    return vec2(a.x + b.x, a.y + b.y)
}

public func -(a: vec2, b: vec2) -> vec2 {
    return vec2(a.x - b.x, a.y - b.y)
}

public func *(v: vec2, k: Float) -> vec2 {
    return vec2(v.x * k, v.y * k)
}

public func *(k: Float, v: vec2) -> vec2 {
    return vec2(k * v.x, k * v.y)
}

public func *(a: vec2, b: vec2) -> vec2 {
    return vec2(a.x * b.x, a.y * b.y)
}

public func /(v: vec2, k: Float) -> vec2 {
    return vec2(v.x / k, v.y / k)
}

public func /(a: vec2, b: vec2) -> vec2 {
    return vec2(a.x / b.x, a.y / b.y)
}

// Mutating arithmetic operators.

public func +=(a: inout vec2, b: vec2) {
    a.x += b.x
    a.y += b.y
}

public func -=(a: inout vec2, b: vec2) {
    a.x -= b.x
    a.y -= b.y
}

public func *=(a: inout vec2, b: vec2) {
    a.x *= b.x
    a.y *= b.y
}

public func /=(a: inout vec2, b: vec2) {
    a.x /= b.x
    a.y /= b.y
}

public func /=(vector: inout vec2, scalar: Float) {
    vector.x /= scalar
    vector.y /= scalar
}

// Equality operators.

public func ==(a: vec2, b: vec2) -> Bool {
    return a.x == b.x && a.y == b.y
}

public func !=(a: vec2, b: vec2) -> Bool {
    return a.x != b.x || a.y != b.y
}

//

public func floor(_ v: vec2) -> vec2 {
    return vec2(floorf(v.x), floorf(v.y))
}

public func ceil(_ v: vec2) -> vec2 {
    return vec2(ceilf(v.x), ceilf(v.y))
}

public func randomVec2() -> vec2 {
    return vec2(randomFloat(), randomFloat())
}

public func randomVec2InRange(_ lo: Float, hi: Float) -> vec2 {
    return vec2(randomFloatInRange(lo, hi), randomFloatInRange(lo, hi))
}

public func minComponent(_ v: vec2) -> Float {
    return min(v.x, v.y)
}

public func maxComponent(_ v: vec2) -> Float {
    return max(v.x, v.y)
}
