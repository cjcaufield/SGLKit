//
//  SGLIosView.mm
//  SGLKitTouch
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

#import "SGLIosView.h"
#import "SGLContext.h"
#import "SGLTexture.h"
#import "SGLShader.h"
#import "SGLHeader.h"

#pragma mark - Private

@interface SGLIosView ()

@property (nonatomic) int currentTextRow;

@end

#pragma mark - Public

@implementation SGLIosView

#pragma mark - Lifecycle

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    // CJC: Trying to remove flash while rotating.  Not working.
    //self.contentMode = UIViewContentModeRedraw;
    
    _tripleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapGesture:)];
    _tripleTapRecognizer.numberOfTapsRequired = 3;
    [self addGestureRecognizer:_tripleTapRecognizer];
}

#pragma mark - Rendering

- (void) openGLWasPrepared
{
    // nothing
}

- (void) openGLWasDestroyed
{
    // nothing
}

- (void) update:(double)seconds
{
    // nothing
}

- (void) render
{
    // nothing
}

- (void) renderOverlay
{
    // nothing
}

#pragma mark - Text

- (void) drawText:(NSString*)text
{
    [self drawTextLines:@[text]];
}

- (void) drawTextLines:(NSArray*)lines
{
    /*
    CGRect backingRect = self.bounds; //[self convertRectToBacking:self.bounds]; // CJC revisit
    
    [SGLTexture deactivateAll];
    [SGLShader deactivateAll];
    
    [_context removeMatrices];
    
    glColor3f(1.0f, 1.0f, 1.0f);
    
    for (NSString* line in lines)
    {
        float pixelPosX = 6.0f;
        float pixelPosY = float(_currentTextRow + 1) * 26.0f;
        glRasterPos3f(-1.0f + pixelPosX / backingRect.size.width, 1.0f - pixelPosY / backingRect.size.height, -1.0f);
        
        for (int i = 0; i < line.length; i++)
            glutBitmapCharacter(GLUT_BITMAP_8_BY_13, [line characterAtIndex:i]);
        
        _currentTextRow++;
    }
    
    [_context restoreMatrices];
    */
}

#pragma mark - Sizing

- (CGFloat) pixelDensity
{
    return self.contentScaleFactor;
}

#pragma mark - Shaders

- (IBAction) reloadShaders:(id)sender
{
    #ifdef DEBUG
    
        [SGLShader reloadAll];
        [self shadersDidReload];
        
    #endif
}

- (void) shadersDidReload
{
    // nothing.
}

#pragma mark - Gestures

- (IBAction) tripleTapGesture:(UITapGestureRecognizer*)recognizer
{
    [self reloadShaders:recognizer];
}

@end
