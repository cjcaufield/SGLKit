//
//  SGLIosSceneView.h
//  SGLKitTouch
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "SGLIosView.h"

@class SGLScene;

@interface SGLIosSceneView : SGLIosView

@property (nonatomic, strong) SGLScene* scene;
@property (nonatomic, strong) UIPanGestureRecognizer* singlePanRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer* doublePanRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer* triplePanRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer* doubleTapRecognizer;
@property (nonatomic) BOOL userControlsCamera;

- (void) transformWasChanged;

- (IBAction) resetCamera:(id)sender;

@end
