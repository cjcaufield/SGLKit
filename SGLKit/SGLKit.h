//
//  SGLKit.h
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-01.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

#ifndef SGLKIT_H
#define SGLKIT_H

//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <SGLKit/SGLDebug.h>
#import <SGLKit/SGLHeader.h>
#import <SGLKit/SGLMath.h>
#import <SGLKit/SGLTypes.h>
#import <SGLKit/SGLDefaults.h>
#import <SGLKit/SGLUtilities.h>
#import <SGLKit/SGLMeshes.h>
#import <SGLKit/SGLContext.h>
#import <SGLKit/SGLRenderer.h>
#import <SGLKit/SGLScene.h>
#import <SGLKit/SGLMesh.h>
#import <SGLKit/SGLProgram.h>
#import <SGLKit/SGLShader.h>
#import <SGLKit/SGLTexture.h>
#import <SGLKit/SGLUniform.h>
#import <SGLKit/SGLVertexAttribute.h>
#import <SGLKit/SGLVertexBuffer.h>
#import <SGLKit/SGLIndexBuffer.h>

#ifdef SGL_MAC
    #import <SGLKit/SGLMacSceneView.h>
    #import <SGLKit/SGLMacView.h>
    #import <SGLKit/SGLMacWindow.h>
    #import <SGLKit/SGLMacWindowController.h>
#endif

#ifdef SGL_IOS
    #import <SGLKit/SGLIosSceneView.h>
    #import <SGLKit/SGLIosView.h>
    #import <SGLKit/SGLIosViewController.h>
    #import <SGLKit/SGLMotionManager.h>
#endif


#ifdef SGL_IOS
    #import <UIKit/UIKit.h>
    FOUNDATION_EXPORT double SGLKitTouchVersionNumber;
    FOUNDATION_EXPORT const unsigned char SGLKitTouchVersionString[];
#endif

#endif
