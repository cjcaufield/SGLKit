//
//  Vec3.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Vec3
//

extension vec3: GenericVector {
    
    public init() {
        self.init(0.0)
    }
    
    public init(_ i: Float) {
        self.init(i, i, i)
    }
    
    public init(_ i: Float, _ j: Float, _ k: Float) {
        self.x = i
        self.y = j
        self.z = k
    }
    
    public init(_ v: vec2, _ k: Float) {
        self.init(v.x, v.y, k)
    }
    
    public init(_ i: Float, _ v: vec2) {
        self.init(i, v.x, v.y)
    }
    
    public init(_ color: XXColor?) {
        
        var v = vec4(0.0)
        if color != nil {
            v = vec4(color!)
        }
        
        self.init(v.x, v.y, v.z)
    }
    
    public func toColor() -> XXColor? {
        return XXColor(
            red:   CGFloat(self.x),
            green: CGFloat(self.y),
            blue:  CGFloat(self.z),
            alpha: 1.0
        )
    }
    
    public func indexIsValid(_ index: Int) -> Bool {
        return index < 3
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
            default:
                assert(false)
            }
        }
    }
    
    public func at(_ index: Int) -> Float {
        return self[index]
    }
    
    public func length() -> Float {
        return distance(self, ORIGIN_3D)
    }
    
    public func dot(_ v: vec3) -> Float {
        return self.x * v.x + self.y * v.y + self.z * v.z
    }
    
    public mutating func normalize() {
        let l = length()
        if l > 0.0 {
            self /= l
        }
    }
}

// Arithmetic functions.

public func +=(a: inout vec3, b: vec3) {
    a.x += b.x
    a.y += b.y
    a.z += b.z
}

public func -=(a: inout vec3, b: vec3) {
    a.x -= b.x
    a.y -= b.y
    a.z -= b.z
}

public func *=(a: inout vec3, b: vec3) {
    a.x *= b.x
    a.y *= b.y
    a.z *= b.z
}

public func *=(vector: inout vec3, scalar: Float) {
    vector.x *= scalar
    vector.y *= scalar
    vector.z *= scalar
}

public func /=(a: inout vec3, b: vec3) {
    a.x /= b.x
    a.y /= b.y
    a.z /= b.z
}

public func /=(vector: inout vec3, scalar: Float) {
    vector.x /= scalar
    vector.y /= scalar
    vector.z /= scalar
}

// Equality functions.

public func ==(a: vec3, b: vec3) -> Bool {
    return a.x == b.x && a.y == b.y && a.z == b.z
}

public func !=(a: vec3, b: vec3) -> Bool {
    return a.x != b.x || a.y != b.y || a.z != b.z
}

// Arithmetic functions.

public func +(a: vec3, b: vec3) -> vec3 {
    return vec3(a.x + b.x, a.y + b.y, a.z + b.z)
}

public func -(a: vec3, b: vec3) -> vec3 {
    return vec3(a.x - b.x, a.y - b.y, a.z - b.z)
}

public func *(v: vec3, k: Float) -> vec3 {
    return vec3(v.x * k, v.y * k, v.z * k)
}

public func *(k: Float, v: vec3) -> vec3 {
    return vec3(k * v.x, k * v.y, k * v.z)
}

public func *(a: vec3, b: vec3) -> vec3 {
    return vec3(a.x * b.x, a.y * b.y, a.z * b.z)
}

public func /(v: vec3, k: Float) -> vec3 {
    return vec3(v.x / k, v.y / k, v.z / k)
}

public func /(a: vec3, b: vec3) -> vec3 {
    return vec3(a.x / b.x, a.y / b.y, a.z / b.z)
}

// Other functions.

public func randomVec3() -> vec3 {
    return vec3(randomFloat(), randomFloat(), randomFloat())
}

public func randomVec3InRange(_ lo: Float, _ hi: Float) -> vec3 {
    return vec3(randomFloatInRange(lo, hi), randomFloatInRange(lo, hi), randomFloatInRange(lo, hi))
}

public func maxComponent(_ v: vec3) -> Float {
    return max(max(v.x, v.y), v.z)
}

public func minComponent(_ v: vec3) -> Float {
    return min(min(v.x, v.y), v.z)
}

public func cross(_ a: vec3, _ b: vec3) -> vec3 {
    let x = a.y * b.z - a.z * b.y
    let y = a.z * b.x - a.x * b.z
    let z = a.x * b.y - a.y * b.x
    return vec3(x, y, z)
}
