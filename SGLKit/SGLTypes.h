//
//  SGLTypes.h
//  SGLKit
//
//  Created by Colin Caufield on 12-05-01.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#ifndef SGLTYPES_H
#define SGLTYPES_H

#import "SGLDebug.h"

#ifdef SGL_MAC
    #import <Cocoa/Cocoa.h>
#endif
#ifdef SGL_IOS
    #import <UIKit/UIKit.h>
#endif

typedef enum RenderingQuality
{
    RenderingQuality_Minimal = 0,
    RenderingQuality_Low     = 1,
    RenderingQuality_Medium  = 2,
    RenderingQuality_High    = 3,
    RenderingQuality_Maximal = 4
    
} RenderingQuality;

typedef enum ProjectionType
{
    PERSPECTIVE,
    ORTHOGRAPHIC
    
} ProjectionType;

#ifdef SGL_MAC

    //typedef NSColor XXColor;
    //typedef NSImage XXImage;
    //typedef NSFont  XXFont;

    #define XXColor NSColor
    #define XXImage NSImage
    #define XXFont  NSFont

    #define StringFromRect NSStringFromRect

#endif
#ifdef SGL_IOS

    //typedef UIColor XXColor;
    //typedef UIImage XXImage;
    //typedef UIFont  XXFont;

    #define XXColor UIColor
    #define XXImage UIImage
    #define XXFont  UIFont

    #define StringFromRect NSStringFromCGRect

#endif

#endif
