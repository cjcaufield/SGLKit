//
//  SGLUtilities.swift
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

import Foundation

public extension SGLUtilities {
    
    public class func numberArray(_ attrs: [SGLVertexAttribute]) -> [NSNumber] {
        return attrs.map { NSNumber(value: $0.rawValue) }
    }
    
    public class func numberArray(_ attrs: SGLVertexAttribute...) -> [NSNumber] {
        return self.numberArray(attrs)
    }
    
    /*
    public func arrayToNSData<T>(_ array: [T]) -> Data {
        let pointer = UnsafeMutablePointer<UInt8>(array)
        let length = array.count * MemoryLayout<T>.size
        return Data(bytesNoCopy: pointer, count: length, deallocator: .none)
    }
    */
}
