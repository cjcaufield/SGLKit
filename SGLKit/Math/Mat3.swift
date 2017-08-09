//
//  Mat3.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Mat3
//

public extension mat3 {
    
    public init() {
        self.elements.0 = 1.0
        self.elements.1 = 0.0
        self.elements.2 = 0.0
        self.elements.3 = 0.0
        self.elements.4 = 1.0
        self.elements.5 = 0.0
        self.elements.6 = 0.0
        self.elements.7 = 0.0
        self.elements.8 = 1.0
    }
    
    public init(_ repeatedValue: Float) {
        self.init()
        self.fill(repeatedValue)
    }
    
    public init(_ buffer: UnsafePointer<Float>) {
        self.init()
        self.fill(buffer)
    }
    
    /*
    public func pointerToElements() -> UnsafePointer<Float> {
        
        // Old way
        return UnsafePointer<Float>(unsafeAddressOf(self.elements.0))
        
        // New Way 1
        //let x = Unmananged.passUnretained(self.elements.0).toOpaque()
        //return UnsafePointer<Float>(self.elements.0 as AnyObject)
        
        // New Way 2
        //withUnsafePointer(to: self.elements.0) {
        //    return UnsafePointer<Float>($0)
        //}
        
        // New Way 3
        //return self.elements.0
        
        // New Way 4
        //let f1 = Float(0)
        //let f2 = (Float(0), Float(1), Float(2))
        
        //return UnsafePointer(f1)
        
        //return UnsafeRawPointer(self.elements)
    }
    */
    
    public func indexForRow(_ row: Int, col: Int) -> Int {
        return row * 3 + col
    }
    
    public func indexIsValid(_ index: Int) -> Bool {
        return index < 9
    }
    
    subscript(index: Int) -> Float {
        
        get {
            switch index {
            case 0: return self.elements.0
            case 1: return self.elements.1
            case 2: return self.elements.2
            case 3: return self.elements.3
            case 4: return self.elements.4
            case 5: return self.elements.5
            case 6: return self.elements.6
            case 7: return self.elements.7
            case 8: return self.elements.8
            default:
                assert(false)
                return 0.0
            }
        }
        
        set {
            switch index {
            case 0: self.elements.0 = newValue
            case 1: self.elements.1 = newValue
            case 2: self.elements.2 = newValue
            case 3: self.elements.3 = newValue
            case 4: self.elements.4 = newValue
            case 5: self.elements.5 = newValue
            case 6: self.elements.6 = newValue
            case 7: self.elements.7 = newValue
            case 8: self.elements.8 = newValue
            default:
                assert(false)
            }
        }
    }
    
    subscript(row: Int, col: Int) -> Float {
        
        get {
            let index = self.indexForRow(row, col: col)
            return self[index]
        }
        
        set {
            let index = self.indexForRow(row, col: col)
            self[index] = newValue
        }
    }
    
    public func at(_ row: Int, _ col: Int) -> Float {
        return self[row, col]
    }
    
    public func row(_ row: Int) -> vec3 {
        
        let x = self[row, 0]
        let y = self[row, 1]
        let z = self[row, 2]
        
        return vec3(x, y, z)
    }
    
    public mutating func setRow(_ row: Int, v: vec3) {
        
        assert(row < 3)
        
        self[row, 0] = v.x
        self[row, 1] = v.y
        self[row, 2] = v.z
    }
        
    public func isAffine() -> Bool {
        
        return self[0, 3] == 0.0 &&
               self[1, 3] == 0.0 &&
               self[2, 3] == 0.0
    }
    
    public func position() -> vec3 {
        return vec3(self[3, 0], self[3, 1], self[3, 2])
    }
    
    public func transpose() -> mat3 {
        
        var result = mat3()
        
        for i in 0 ..< 3 {
            for j in 0 ..< 3 {
                result[i, j] = self[j, i]
            }
        }
        
        return result
    }
    
    public func inverse() -> mat3 {
        
        let e00 = self[0, 0]
        let e01 = self[0, 1]
        let e02 = self[0, 2]
        let e10 = self[1, 0]
        let e11 = self[1, 1]
        let e12 = self[1, 2]
        let e20 = self[2, 0]
        let e21 = self[2, 1]
        let e22 = self[2, 2]
        
        var result = mat3(0.0)
        
        result[0, 0] = e11 * e22 - e21 * e12
        result[0, 1] = e12 * e20 - e22 * e10
        result[0, 2] = e10 * e21 - e20 * e11
        result[1, 0] = e02 * e21 - e01 * e22
        result[1, 1] = e00 * e22 - e02 * e20
        result[1, 2] = e01 * e20 - e00 * e21
        result[2, 0] = e12 * e01 - e11 * e02
        result[2, 1] = e10 * e02 - e12 * e00
        result[2, 2] = e11 * e00 - e10 * e01
        
        let determinant =
            e00 * (e11 * e22 - e21 * e12) -
            e10 * (e01 * e22 - e21 * e02) +
            e20 * (e01 * e12 - e11 * e02)
        
        result /= determinant
        
        return result
    }
    
    public mutating func fill(_ value: Float) {
        for i in 0 ..< 9 {
            self[i] = value
        }
    }
    
    public mutating func fill(_ values: UnsafePointer<Float>) {
        for i in 0 ..< 9 {
            self[i] = values[i]
        }
    }
    
    public mutating func reset() {
        self.fill(0.0)
        for i in 0 ..< 3 {
            self[i, i] = 1.0
        }
    }
    
    public static func identity() -> mat3 {
        return mat3()
    }
    
    public static func rotationX(_ radians: Float) -> mat3 {
        
        let s = sin(radians)
        let c = cos(radians)
        
        var xrm = mat3()
        
        xrm[1, 1] = +c
        xrm[1, 2] = -s
        xrm[2, 1] = +s
        xrm[2, 2] = +c
        
        return xrm
    }
    
    public static func rotationY(_ radians: Float) -> mat3 {
    
        let s = sin(radians)
        let c = cos(radians)
        
        var yrm = mat3()
        
        yrm[0, 0] = +c
        yrm[0, 2] = +s
        yrm[2, 0] = -s
        yrm[2, 2] = +c
        
        return yrm
    }
    
    public static func rotationZ(_ radians: Float) -> mat3 {
    
        let s = sin(radians)
        let c = cos(radians)
        
        var zrm = mat3()
        
        zrm[0, 0] = +c
        zrm[0, 1] = -s
        zrm[1, 0] = +s
        zrm[1, 1] = +c
        
        return zrm
    }
    
    public static func rotationYX(_ yradians: Float, xradians: Float) -> mat3 {
    
        let siny = sin(yradians)
        let cosy = cos(yradians)
        let sinx = sin(xradians)
        let cosx = cos(xradians)
        
        var yrm = mat3()
        
        yrm[0, 0] = +cosy
        yrm[0, 2] = +siny
        yrm[2, 0] = -siny
        yrm[2, 2] = +cosy
        
        var xrm = mat3()
        
        xrm[1, 1] = +cosx
        xrm[1, 2] = -sinx
        xrm[2, 1] = +sinx
        xrm[2, 2] = +cosx
        
        return yrm * xrm
    }
    
    public static func scale(_ scale: vec3) -> mat3 {
    
        var sm = mat3()
        
        sm[0, 0] = scale.x
        sm[1, 1] = scale.y
        sm[2, 2] = scale.z
        
        return sm
    }
}

public func *(matrix: inout mat3, vector: vec3) -> vec3 {
    
    var result = vec3(0.0)
    
    for i in 0 ..< 3 {
        for c in 0 ..< 3 {
            result[i] += matrix[c, i] * vector[c]
        }
    }
    
    return result
}

public func *(a: mat3, b: mat3) -> mat3 {
    
    var result = mat3(0.0)
    
    for i in 0 ..< 3 {
        for j in 0 ..< 3 {
            for c in 0 ..< 3 {
                result[i, j] += a[c, j] * b[i, c]
            }
        }
    }
    
    return result
}

public func *=(matrix: inout mat3, scalar: Float) {
    for i in 0 ..< 9 {
        matrix[i] *= scalar
    }
}

public func /=(matrix: inout mat3, scalar: Float) {
    for i in 0 ..< 9 {
        matrix[i] /= scalar
    }
}

// Equality Operators.

public func ==(a: mat3, b: mat3) -> Bool {
    
    for i in 0 ..< 3 {
        for j in 0 ..< 3 {
            if a[i, j] != b[i, j] {
                return false
            }
        }
    }
    
    return true
}

public func !=(a: mat3, b: mat3) -> Bool {
    return !(a == b)
}
