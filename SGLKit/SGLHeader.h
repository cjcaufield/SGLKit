//
//  SGLHeader.h
//  SGLKit
//
//  Created by Colin Caufield on 2014-04-22.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import "SGLDebug.h"

#ifdef SGL_MAC
    #import <OpenGL/gl.h>
    //#import <OpenGL/gl3.h>
#endif
#ifdef SGL_IOS
    #import <OpenGLES/ES2/gl.h>
    #import <OpenGLES/ES2/glext.h> // CJC revisit: needed for SGLMesh and SGLVertexAttribute.
#endif
