//
//  SGLDefaults.mm
//  SGLKit
//
//  Created by Colin Caufield on 7/19/14.
//
//

#import "SGLDefaults.h"
#import "SGLTypes.h"
#import "SGLDebug.h"

NSString* const FullFramerateBackgroundWindows  = @"BackgroundWindowsRenderAtFullQuality";
NSString* const PositionalPerspective           = @"PositionalPerspective";
NSString* const UserControlsCamera              = @"MouseControlsCamera";

#ifdef SGL_IOS

    NSString* const Framerate                   = @"userFramesPerSecond";
    NSString* const LightLevel                  = @"lightLevel";
    NSString* const RenderingQualityKey         = @"renderingQuality";
    NSString* const UseRetinaResolution         = @"retina";

#endif
#ifdef SGL_MAC

    NSString* const Framerate                   = @"Framerate";
    NSString* const LightLevel                  = @"LightLevel";
    NSString* const RenderingQualityKey         = @"RenderingQuality";
    NSString* const UseRetinaResolution         = @"UseRetinaResolution";

#endif


@implementation NSUserDefaults (SGLKit)

+ (void) load
{
    int quality = RenderingQuality_Maximal;
    
    #ifdef SGL_IOS
        quality = RenderingQuality_High;
    #endif
        
    [DEFAULTS registerDefaults:
    @{
        Framerate           : @60.0,
        LightLevel          : @0.25,
        RenderingQualityKey : @(quality),
    }];
}

@end
