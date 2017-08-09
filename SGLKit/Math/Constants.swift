//
//  Constants.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

public let PI         = Float(3.1415926535897931)
public let HALF_PI    = Float(1.5707963267948966)
public let QUARTER_PI = Float(0.7853981633974483)

public let FLOAT_EPSILON = Float(0.00001)

public let ORIGIN_2D = vec2(0, 0)
public let ORIGIN_3D = vec3(0, 0, 0)
public let ORIGIN_4D = vec4(0, 0, 0, 0)

public let BLACK   = vec3(0, 0, 0)
public let RED     = vec3(1, 0, 0)
public let GREEN   = vec3(0, 1, 0)
public let BLUE    = vec3(0, 0, 1)
public let CYAN    = vec3(0, 1, 1)
public let MAGENTA = vec3(1, 0, 1)
public let YELLOW  = vec3(1, 1, 0)
public let WHITE   = vec3(1, 1, 1)

public let TRANSPARENT_BLACK = vec4(0, 0, 0, 0)
public let OPAQUE_BLACK      = vec4(0, 0, 0, 1)


//
//
//

public protocol GenericVector {
    
    static func +(a: Self, b: Self) -> Self
    static func -(a: Self, b: Self) -> Self
    static func *(a: Self, b: Self) -> Self
    static func /(a: Self, b: Self) -> Self
    
    static func *(v: Self, k: Float) -> Self
    static func *(k: Float, v: Self) -> Self
    static func /(v: Self, k: Float) -> Self
    
    func dot(_ v: Self) -> Float
    
    func length() -> Float
}


//
//
//

public func randomFloat() -> Float {
    return Float(arc4random()) / Float(RAND_MAX)
}

public func randomDouble() -> Double {
    return Double(arc4random()) / Double(RAND_MAX)
}

public func randomFloatInRange(_ lo: Float, _ hi: Float) -> Float {
    return lo + randomFloat() * (hi - lo)
}

public func randomDoubleInRange(_ lo: Double, _ hi: Double) -> Double {
    return lo + randomDouble() * (hi - lo)
}

public func radians(_ degrees: Float) -> Float {
    return degrees * PI / 180.0
}

public func degrees(_ radians: Float) -> Float {
    return radians * 180.0 / PI
}

public func mix(_ a: Float, _ b: Float, offset: Float) -> Float {
    return a + (b - a) * offset
}

public func mix(_ a: Double, _ b: Double, offset: Double) -> Double {
    return a + (b - a) * offset
}

public func mix<T: GenericVector>(_ a: T, _ b: T, offset: Float) -> T {
    return a + (b - a) * offset
}

public func length<T: GenericVector>(_ v: T) -> Float {
    return v.length()
}

public func distance<T: GenericVector>(_ a: T, _ b: T) -> Float {
    return sqrtf(distancesqrd(a, b))
}

public func distancesqrd<T: GenericVector>(_ a: T, _ b: T) -> Float {
    let diff = a - b
    return magnitudesqrd(diff)
}

public func magnitude<T: GenericVector>(_ v: T) -> Float {
    return sqrtf(magnitudesqrd(v))
}

public func magnitudesqrd<T: GenericVector>(_ v: T) -> Float {
    //return dot(v, v)
    //return v · v
    //let d = (v · v)
    //return d
    return dot(v, v)
}

public func dot<T: GenericVector>(_ a: T, _ b: T) -> Float {
    return a.dot(b)
}

public func normalize<T: GenericVector>(_ v: T) -> T {
    let len = v.length()
    if len == 0.0 {
        return v
    } else {
        return v / len
    }
}
