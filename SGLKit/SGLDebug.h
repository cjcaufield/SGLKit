//
//  SGLDebug.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2014 Secret Geometry. All rights reserved.
//

//
// Platforms
//

#ifdef __APPLE__

    #include "TargetConditionals.h"

    #if TARGET_OS_IPHONE
        #define SGL_IOS

    #elif TARGET_IPHONE_SIMULATOR
        #define SGL_IOS

    #elif TARGET_OS_MAC
        #define SGL_MAC

    #endif

#elif __linux

    #define SGL_LINUX

#endif

//
// Asserts
//

#define SGL_NOTHING ((void)0)

#ifdef DEBUG

    #ifdef __APPLE__

        #define SGL_LOG(...) \
            NSLog(@"%@", [NSString stringWithFormat:__VA_ARGS__])

        #define SGL_METHOD_LOG \
            NSLog(@"%@ %@", self, NSStringFromSelector(_cmd))

        #define SGL_METHOD_LOG_ARGS(...) \
            NSLog(@"%@ %@ %@", self, NSStringFromSelector(_cmd), [NSString stringWithFormat:__VA_ARGS__])

        #if TARGET_OS_IPHONE

            #include <signal.h>
            #define SGL_ASSERT(b) { if (!(b)) raise(SIGINT); /* kill(getpid(), SIGINT); */ }

        #elif TARGET_IPHONE_SIMULATOR

            #include <signal.h>
            #define SGL_ASSERT(b) { if (!(b)) raise(SIGINT); /* kill(getpid(), SIGINT); */ }

        #elif TARGET_OS_MAC

            #include <MacTypes.h>
            #define SGL_ASSERT(b) { if (!(b)) Debugger(); }

        #endif

    #elif __linux

        #define SGL_ASSERT(b) { if (!(b)) kill(getpid(), SIGINT); }

    #endif

#else // RELEASE

    #define SGL_LOG(...)             SGL_NOTHING
    #define SGL_METHOD_LOG           SGL_NOTHING
    #define SGL_METHOD_LOG_ARGS(...) SGL_NOTHING
    #define SGL_ASSERT(b)            SGL_NOTHING

#endif
