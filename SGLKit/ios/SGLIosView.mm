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

@interface SGLIosView ()

@property (nonatomic) int currentTextRow;

@end


@implementation SGLIosView

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    // CJC: Trying to remove flash while rotating.  Not working.
    //self.contentMode = UIViewContentModeRedraw;
    
    _tripleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapGesture:)];
    _tripleTapRecognizer.numberOfTapsRequired = 3;
    [self addGestureRecognizer:_tripleTapRecognizer];
}

- (void) openGLWasPrepared
{
    // nothing
}

- (void) openGLWasDestroyed
{
    // nothing
}

- (CGFloat) pixelDensity
{
    return self.contentScaleFactor;
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

- (IBAction) reloadShaders:(id)sender
{
    #ifdef DEBUG
    
        [SGLShader reloadAll];
        [self shadersDidReload];
        
    #endif
}

- (IBAction) tripleTapGesture:(UITapGestureRecognizer*)recognizer
{
    [self reloadShaders:recognizer];
}

- (void) shadersDidReload
{
    // nothing.
}

@end
