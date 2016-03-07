//
//  Vec4.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Vec4
//

extension vec4: GenericVector {
    
    public init() {
        self.init(0.0)
    }
    
    public init(_ i: Float) {
        self.init(i, i, i, i)
    }
    
    public init(_ i: Float, _ j: Float, _ k: Float, _ l: Float) {
        self.x = i
        self.y = j
        self.z = k
        self.w = l
    }
    
    public init(_ v: vec3, _ l: Float) {
        self.init(v.x, v.y, v.z, l)
    }
    
    public func indexIsValid(index: Int) -> Bool {
        return index < 4
    }
    
    subscript(index: Int) -> Float {
        get {
            switch index {
            case 0:
                return self.x
            case 1:
                return self.y
            case 2:
                return self.z
            case 3:
                return self.w
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
            case 2:
                self.z = newValue
            case 3:
                self.w = newValue
            default:
                assert(false)
            }
        }
    }
    
    public func at(index: Int) -> Float {
        return self[index]
    }
    
    public func length() -> Float {
        return distance(self, ORIGIN_4D)
    }
    
    public func dot(v: vec4) -> Float {
        return self.x * v.x + self.y * v.y + self.z * v.z + self.w * v.w
    }
    
    public mutating func normalize() {
        let l = length()
        if l > 0.0 {
            self /= l
        }
    }
}

// Arithmetic functions.

public func +=(inout a: vec4, b: vec4) {
    a.x += b.x
    a.y += b.y
    a.z += b.z
    a.w += b.w
}

public func -=(inout a: vec4, b: vec4) {
    a.x -= b.x
    a.y -= b.y
    a.z -= b.z
    a.w -= b.w
}

public func *=(inout a: vec4, b: vec4) {
    a.x *= b.x
    a.y *= b.y
    a.z *= b.z
    a.w *= b.w
}

public func /=(inout a: vec4, b: vec4) {
    a.x /= b.x
    a.y /= b.y
    a.z /= b.z
    a.w /= b.w
}

public func /=(inout vector: vec4, scalar: Float) {
    vector.x /= scalar
    vector.y /= scalar
    vector.z /= scalar
    vector.w /= scalar
}

// Equality functions.

public func ==(a: vec4, b: vec4) -> Bool {
    return a.x == b.x && a.y == b.y && a.z == b.z && a.w == b.w
}

public func !=(a: vec4, b: vec4) -> Bool {
    return a.x != b.x || a.y != b.y || a.z != b.z && a.w != b.w
}

// Arithmetic functions.

public func +(a: vec4, b: vec4) -> vec4 {
    return vec4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
}

public func -(a: vec4, b: vec4) -> vec4 {
    return vec4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
}

public func *(v: vec4, k: Float) -> vec4 {
    return vec4(v.x * k, v.y * k, v.z * k, v.w * k)
}

public func *(k: Float, v: vec4) -> vec4 {
    return vec4(k * v.x, k * v.y, k * v.z, k * v.w)
}

public func *(a: vec4, b: vec4) -> vec4 {
    return vec4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w)
}

public func /(v: vec4, k: Float) -> vec4 {
    return vec4(v.x / k, v.y / k, v.z / k, v.w / k)
}

public func /(a: vec4, b: vec4) -> vec4 {
    return vec4(a.x / b.x, a.y / b.y, a.z / b.z, a.w / b.w)
}

// Other functions.

public func randomVec4() -> vec4 {
    return vec4(randomFloat(), randomFloat(), randomFloat(), randomFloat())
}

public func randomVec4InRange(lo: Float, hi: Float) -> vec4 {
    return vec4(randomFloatInRange(lo, hi), randomFloatInRange(lo, hi), randomFloatInRange(lo, hi), randomFloatInRange(lo, hi))
}

public func maxComponent(v: vec4) -> Float {
    return max(max(max(v.x, v.y), v.z), v.w)
}

public func minComponent(v: vec4) -> Float {
    return min(min(min(v.x, v.y), v.z), v.w)
}
