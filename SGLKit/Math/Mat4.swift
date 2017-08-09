//
//  Mat4.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-23.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Foundation

//
// Mat4
//

extension mat4 {
    
    public init() {
        self.elements.0  = 1.0
        self.elements.1  = 0.0
        self.elements.2  = 0.0
        self.elements.3  = 0.0
        self.elements.4  = 0.0
        self.elements.5  = 1.0
        self.elements.6  = 0.0
        self.elements.7  = 0.0
        self.elements.8  = 0.0
        self.elements.9  = 0.0
        self.elements.10 = 1.0
        self.elements.11 = 0.0
        self.elements.12 = 0.0
        self.elements.13 = 0.0
        self.elements.14 = 0.0
        self.elements.15 = 1.0
    }
    
    public init(_ repeatedValue: Float) {
        self.init()
        self.fill(repeatedValue)
    }
    
    public init(_ buffer: UnsafePointer<Float>) {
        self.init()
        self.fill(buffer)
    }
    
    public init(_ m: mat3) {
        self.init()
        self.setRow(0, vec4(m.row(0), 0.0))
        self.setRow(1, vec4(m.row(1), 0.0))
        self.setRow(2, vec4(m.row(2), 0.0))
        self.setRow(3, vec4(vec3(0.0), 1.0))
    }
    
    /*
    public func pointerToElements() -> UnsafePointer<Float> {
        return UnsafePointer<Float>(unsafeAddress(of: self.elements.0 as AnyObject))
    }
    */
    
    public func indexForRow(_ row: Int, col: Int) -> Int {
        return row * 4 + col
    }
    
    public func indexIsValid(_ index: Int) -> Bool {
        return index < 16
    }
    
    subscript(index: Int) -> Float {
        
        get {
            switch index {
            case 0:  return self.elements.0
            case 1:  return self.elements.1
            case 2:  return self.elements.2
            case 3:  return self.elements.3
            case 4:  return self.elements.4
            case 5:  return self.elements.5
            case 6:  return self.elements.6
            case 7:  return self.elements.7
            case 8:  return self.elements.8
            case 9:  return self.elements.9
            case 10: return self.elements.10
            case 11: return self.elements.11
            case 12: return self.elements.12
            case 13: return self.elements.13
            case 14: return self.elements.14
            case 15: return self.elements.15
            default:
                assert(false)
                return 0.0
            }
        }
        
        set {
            switch index {
            case 0:  self.elements.0  = newValue
            case 1:  self.elements.1  = newValue
            case 2:  self.elements.2  = newValue
            case 3:  self.elements.3  = newValue
            case 4:  self.elements.4  = newValue
            case 5:  self.elements.5  = newValue
            case 6:  self.elements.6  = newValue
            case 7:  self.elements.7  = newValue
            case 8:  self.elements.8  = newValue
            case 9:  self.elements.9  = newValue
            case 10: self.elements.10 = newValue
            case 11: self.elements.11 = newValue
            case 12: self.elements.12 = newValue
            case 13: self.elements.13 = newValue
            case 14: self.elements.14 = newValue
            case 15: self.elements.15 = newValue
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
    
    public func row(_ row: Int) -> vec4 {
        
        assert(row < 4)
        
        let x = self[row, 0]
        let y = self[row, 1]
        let z = self[row, 2]
        let w = self[row, 3]
        
        return vec4(x, y, z, w)
    }
    
    public mutating func setRow(_ row: Int, _ value: vec4) {
        
        self[row, 0] = value.x
        self[row, 1] = value.y
        self[row, 2] = value.z
        self[row, 3] = value.w
    }
    
    public func isAffine() -> Bool {
        
        return self[0, 3] == 0.0 &&
               self[1, 3] == 0.0 &&
               self[2, 3] == 0.0 &&
               self[3, 3] == 1.0
    }
    
    public func position() -> vec3 {
        return vec3(self[3, 0], self[3, 1], self[3, 2])
    }
    
    public func transpose() -> mat4 {
        
        var result = mat4()
        
        for i in 0 ..< 4 {
            for j in 0 ..< 4 {
                result[i, j] = self[j, i]
            }
        }
        
        return result
    }
    
    public mutating func fill(_ value: Float) {
        for i in 0 ..< 16 {
            self[i] = value
        }
    }
    
    public mutating func fill(_ values: UnsafePointer<Float>) {
        self.fill(values, count: 16)
    }
    
    public mutating func fill(_ values: UnsafePointer<Float>, count: Int) {
        for i in 0 ..< count {
            self[i] = values[i]
        }
    }
    
    public mutating func reset() {
        self.fill(0.0)
        for i in 0 ..< 4 {
            self[i, i] = 1.0
        }
    }
    
    public static func identity() -> mat4 {
        return mat4()
    }
    
    public static func translation(_ v: vec3) -> mat4 {
        
        var tm = mat4()
        
        tm[3, 0] = v.x
        tm[3, 1] = v.y
        tm[3, 2] = v.z
        
        return tm
    }
    
    public static func rotationYX(_ yrot: Float, xrot: Float) -> mat4 {
        
        let siny = sin(yrot)
        let cosy = cos(yrot)
        let sinx = sin(xrot)
        let cosx = cos(xrot)
        
        var yrm = mat4()
        yrm[0, 0] = +cosy
        yrm[2, 0] = -siny
        yrm[0, 2] = +siny
        yrm[2, 2] = +cosy
        
        var xrm = mat4()
        xrm[1, 1] = +cosx
        xrm[2, 1] = +sinx
        xrm[1, 2] = -sinx
        xrm[2, 2] = +cosx
        
        return yrm * xrm
    }
    
    public static func rotation(_ radians: Float, axis: vec3) -> mat4 {
        
        let cos = cosf(radians)
        let sin = sinf(radians)
        let cosp = 1.0 - cos
        
        var naxis = axis
        naxis.normalize()
        
        var result = mat4()
        
        result[0, 0] = cos + cosp * naxis.x * naxis.x
        result[1, 1] = cos + cosp * naxis.y * naxis.y
        result[2, 2] = cos + cosp * naxis.z * naxis.z
        
        result[0, 1] = cosp * naxis.x * naxis.y + naxis.z * sin
        result[1, 0] = cosp * naxis.x * naxis.y - naxis.z * sin
        result[1, 2] = cosp * naxis.y * naxis.z + naxis.x * sin
        result[2, 1] = cosp * naxis.y * naxis.z - naxis.x * sin
        result[0, 2] = cosp * naxis.x * naxis.z - naxis.y * sin
        result[2, 0] = cosp * naxis.x * naxis.z + naxis.y * sin
        
        return result
    }
    
    public static func scale(_ scale: vec3) -> mat4 {
        
        var sm = mat4()
        
        sm[0, 0] = scale.x
        sm[1, 1] = scale.y
        sm[2, 2] = scale.z
        
        return sm
    }
    
    public static func ortho(_ left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> mat4 {
    
        var result = mat4()
        
        result[0, 0] = +2.0 / (right - left)
        result[1, 1] = +2.0 / (top - bottom)
        result[2, 2] = -2.0 / (far - near)
        
        result[3, 0] = -1.0 * (right + left) / (right - left)
        result[3, 1] = -1.0 * (top + bottom) / (top - bottom)
        result[3, 2] = -1.0 * (far + near) / (far - near)
        
        return result
    }
    
    public static func projection(_ fovy: Float, aspect: Float, nearZ: Float, farZ: Float) -> mat4 {
    
        let cotan = 1.0 / tanf(fovy / 2.0)
        
        var result = mat4()
        
        result[0, 0] = cotan / aspect
        result[1, 1] = cotan
        result[2, 2] = (farZ + nearZ) / (nearZ - farZ)
        result[2, 3] = -1.0
        result[3, 2] = (2.0 * farZ * nearZ) / (nearZ - farZ)
        result[3, 3] = 0.0
        
        return result
    }
    
    public static func offsetProjection(_ left: Float, right: Float, bottom: Float, top: Float, near: Float, far: Float) -> mat4 {
    
        var result = mat4()
        
        result[0, 0] = 2.0 * near / (right - left)
        result[1, 1] = 2.0 * near / (top - bottom)
        result[2, 0] = (right + left) / (right - left)
        result[2, 1] = (top + bottom) / (top - bottom)
        result[2, 2] = -1.0 * (far + near) / (far - near)
        result[2, 3] = -1.0
        result[3, 2] = -2.0 * far * near / (far - near)
        result[3, 3] = 0.0
        
        return result
    }
}

// Arithmetic Operators.

public func *(m: mat4, v: vec3) -> vec3 {

    let v4 = vec4(v, 1.0)
    var result = vec3(0.0)
    
    for i in 0 ..< 3 {
        for c in 0 ..< 4 {
            result[i] += m.at(c, i) * v4.at(c)
        }
    }
    
    return result
}

public func *(a: mat4, b: mat4) -> mat4 {
    
    var result = mat4(0.0)
    
    for i in 0 ..< 4 {
        for j in 0 ..< 4 {
            for c in 0 ..< 4 {
                result[i, j] += a[c, j] * b[i, c]
            }
        }
    }
    
    return result
}

public func *=(matrix: inout mat4, scalar: Float) {
    for i in 0 ..< 16 {
        matrix[i] *= scalar
    }
}

public func /=(matrix: inout mat4, scalar: Float) {
    for i in 0 ..< 16 {
        matrix[i] /= scalar
    }
}

// Equality Operators.

public func ==(a: mat4, b: mat4) -> Bool {
    
    for i in 0 ..< 4 {
        for j in 0 ..< 4 {
            if a[i, j] != b[i, j] {
                return false
            }
        }
    }
    
    return true
}

public func !=(a: mat4, b: mat4) -> Bool {
    return !(a == b)
}
