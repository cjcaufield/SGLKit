//
//  Functions.h
//  SGLKit
//
//  Created by Colin Caufield on 11-06-24.
//  Copyright 2017 Secret Geometry. All rights reserved.
//

#ifndef SGL_FUNCTIONS_H
#define SGL_FUNCTIONS_H

#import "SGLMath.h"

#ifdef __cplusplus

    bool intersect(ray& r, sphere& s, float sphereAspect, vec3* intersectPos);

    bool intersect(const ray& r, const tri& t);

    bool intersect(const ray& r, const quad& q);

#endif

#endif
