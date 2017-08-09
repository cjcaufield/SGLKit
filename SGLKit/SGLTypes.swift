//
//  SGLTypes.h
//  SGLKit
//
//  Created by Colin Caufield on 12-05-01.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#if os(OSX)

    public typealias XXColor = NSColor
    public typealias XXImage = NSImage
    public typealias XXFont  = NSFont

    //typealias StringFromRect = NSStringFromRect

#endif

#if os(iOS)

    public typealias XXColor = UIColor
    public typealias XXImage = UIImage
    public typealias XXFont  = UIFont

    //typealias StringFromRect = NSStringFromCGRect
    
#endif
