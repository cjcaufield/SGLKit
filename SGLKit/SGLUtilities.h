//
//  SGLUtilities.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLDebug.h"
#import "SGLTypes.h"
#import "SGLMath.h"
#import "SGLTexture.h"

#ifdef __cplusplus
    #include <vector>
#endif

//
// Helpful methods.
//

@interface SGLUtilities : NSObject

+ (void) checkForErrors;

#ifdef SGL_MAC
    + (void) exitGracefullyWithMessage:(NSString*)message;
#endif

+ (void) swapTexture:(__strong SGLTexture**)tex1 with:(__strong SGLTexture**)tex2;

+ (void) drawTexture:(SGLTexture*)tex outputSize:(vec2)size samplingType:(SamplingType)type;

@end

#ifdef __cplusplus

    //
    // Equality operators for common Cocoa structs.
    //

    bool operator==(const NSRange& a, const NSRange& b);
    bool operator==(const CGPoint& a, const CGPoint& b);
    bool operator==(const CGSize& a, const CGSize& b);
    bool operator==(const CGRect& a, const CGRect& b);

    //
    // Array and Vector conversions to NSData.
    //

    template <typename T, int N>
    NSData* CArrayToData(T (&array)[N])
    {
        unsigned long length = N * sizeof(T);
        return [NSData dataWithBytesNoCopy:array length:length freeWhenDone:NO];
    }

    template <typename T>
    NSData* VectorToData(std::vector<T>& vec)
    {
        unsigned long length = vec.size() * sizeof(T);
        return [NSData dataWithBytesNoCopy:&vec[0] length:length freeWhenDone:NO];
    }

#endif

//
// Add objects to arrays while preventing duplicates.
//

@interface NSMutableArray (Unique)

- (void) addObjectIfUnique:(id)object;

@end
