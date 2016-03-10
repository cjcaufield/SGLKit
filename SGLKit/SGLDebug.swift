//
//  SGLDebug.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-03-08.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

#if os(iOS)
    
    public let SGL_IOS = true
    public let SGL_MAC = false
    public let SGL_LINUX = false

    #if arch(i386) || arch(x86_64)

        public let SGL_IOS_DEVICE = false
        public let SGL_IOS_SIMULATOR = true
        
    #else
        
        public let SGL_IOS_DEVICE = true
        public let SGL_IOS_SIMULATOR = false
    
    #endif
    
#elseif os(OSX)
    
    public let SGL_IOS = false
    public let SGL_MAC = true
    public let SGL_LINUX = false
    public let SGL_IOS_DEVICE = false
    public let SGL_IOS_SIMULATOR = false

#elseif os(Linux)

    public let SGL_IOS = false
    public let SGL_MAC = false
    public let SGL_LINUX = true
    public let SGL_IOS_DEVICE = false
    public let SGL_IOS_SIMULATOR = false

#endif
