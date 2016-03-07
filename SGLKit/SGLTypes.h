//
//  SGLTypes.h
//  SGLKit
//
//  Created by Colin Caufield on 12-05-01.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "SGLDebug.h"

#ifdef SGL_MAC
    #import <Cocoa/Cocoa.h>
#endif
#ifdef SGL_IOS
    #import <UIKit/UIKit.h>
#endif

typedef enum RenderingQuality
{
    RenderingQuality_Minimal,
    RenderingQuality_Low,
    RenderingQuality_Medium,
    RenderingQuality_High,
    RenderingQuality_Maximal
    
} RenderingQuality;

typedef enum ProjectionType
{
    PERSPECTIVE,
    ORTHOGRAPHIC
    
} ProjectionType;

#ifdef SGL_MAC

    typedef NSColor XXColor;
    typedef NSImage XXImage;
    typedef NSFont  XXFont;

    #define StringFromRect NSStringFromRect

#endif
#ifdef SGL_IOS

    typedef UIColor XXColor;
    typedef UIImage XXImage;
    typedef UIFont  XXFont;

    #define StringFromRect NSStringFromCGRect

#endif
