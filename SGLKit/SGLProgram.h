//
//  SGLProgram.h
//  SGLKit
//
//  Created by Colin Caufield on 2012-12-09.
//  Copyright (c) 2014 Secret Geometry, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SGLProgram : NSObject

@property (readonly) unsigned int glName;

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* vertexSource;
@property (nonatomic, copy) NSString* fragmentSource;
//@property (nonatomic, copy) NSString* vertexPath;
//@property (nonatomic, copy) NSString* fragmentPath;
@property (nonatomic, strong) NSArray* defines;
@property (nonatomic, strong) NSDictionary* uniforms;
@property (nonatomic) int positionLoc;
@property (nonatomic) int normalLoc;
@property (nonatomic) int colorLoc;
@property (nonatomic) int texCoordLoc;

+ (SGLProgram*) programNamed:(NSString*)name;
+ (SGLProgram*) programNamed:(NSString*)name defines:(NSArray*)defs;

+ (void) registerResourceBundle:(NSBundle*)bundle;
+ (void) registerSourcePath:(NSString*)path;

- (void) activate;
- (void) validate;
- (void) reload;
+ (void) reloadAll;
+ (void) deleteAll;

@end
