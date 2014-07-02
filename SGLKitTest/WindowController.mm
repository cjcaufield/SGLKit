//
//  WindowController.mm
//  SGLKitTest
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "WindowController.h"
#import "View.h"


@implementation WindowController

- (id) init
{
    self = [super initWithWindowNibName:@"Window"];
    return self;
}

- (NSString*) windowTitleForDocumentDisplayName:(NSString*)displayName
{
    switch ([(id)self.view shape])
    {
        case SPHERE:        return @"Sphere";
        case TORUS:         return @"Torus";
        case CONE:          return @"Cone";
        case TETRAHEDRON:   return @"Tetrahedron";
        case CUBE:          return @"Cube";
        case OCTAHEDRON:    return @"Octahedron";
        case DODECAHEDRON:  return @"Dodecahedron";
        case ICOSAHEDRON:   return @"Icosahedron";
        case TEAPOT:        return @"Teapot";
        default:            return @"Unknown";
    }
}

@end
