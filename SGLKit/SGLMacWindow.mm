//
// Copyright (c) 2014 Secret Geometry, Inc.  All rights reserved.
//

#import "SGLMacWindow.h"
#import "SGLMacWindowController.h"
#import "SGLDebug.h"


@interface SGLMacWindow ()

@property NSPoint mouseDownLoc;
@property NSRect mouseDownFrame;
@property BOOL mouseDownWasOnFrame;
@property NSRect actualFrame;
@property NSTimeInterval timeOfLastMouseInteraction;

@end


@implementation SGLMacWindow

- (id) initWithContentRect:(NSRect)contentRect
                 styleMask:(NSUInteger)styleMask
                   backing:(NSBackingStoreType)backingType
                     defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:styleMask backing:backingType defer:flag];
    
    _userFrame = [self frameRectForContentRect:contentRect];
	_actualFrame = self.frame;
    
    self.acceptsMouseMovedEvents = YES;
    self.backgroundColor = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
    
    // CJC: Not working: trying to keep shadow.
    self.hasShadow = YES;
    
    return self;
}

- (void) encodeRestorableStateWithCoder:(NSCoder*)coder
{
    [super encodeRestorableStateWithCoder:coder];
}

- (void) restoreStateWithCoder:(NSCoder*)coder
{
    [super restoreStateWithCoder:coder];
}

- (void) setFrame:(NSRect)frame display:(BOOL)display
{
    //NSLog(@"&&& setFrame %@", NSStringFromRect(frame));
    
	_actualFrame = frame;
    
	[super setFrame:frame display:display];
    [self sendRepositionNotification];
}

- (void) setFrame:(NSRect)frame display:(BOOL)display animate:(BOOL)animate
{
    //NSLog(@"&&& setFrame %@", NSStringFromRect(frame));
    
	_actualFrame = frame;
    
	[super setFrame:frame display:display animate:animate];
    [self sendRepositionNotification];
}

- (void) setFrameOrigin:(NSPoint)origin
{
    //NSLog(@"&&& setFrameOrigin %@", NSStringFromPoint(origin));
    
	_actualFrame.origin = origin;
    
	[super setFrameOrigin:origin];
    [self sendRepositionNotification];
}

- (void) sendEvent:(NSEvent*)event
{	
    BOOL isMouseEvent = YES;
    
	switch (event.type)
	{
        case NSMouseMoved:
            // Nothing to do, but don't wan't the default case.
			break;
            
		case NSLeftMouseDown:
		{
			_mouseDownLoc = NSEvent.mouseLocation;
			_mouseDownFrame = self.frame;
			
			NSRect contentRect = [self contentRectForFrameRect:self.frame];
			_mouseDownWasOnFrame = (NSPointInRect(_mouseDownLoc, contentRect) == NO);
            _mouseIsDown = YES;
            
			break;
		}
            
		case NSLeftMouseDragged:
		{
			if (_mouseDownWasOnFrame)
			{
				CGFloat dx = NSEvent.mouseLocation.x - _mouseDownLoc.x;
				CGFloat dy = NSEvent.mouseLocation.y - _mouseDownLoc.y;
				
                if (dx == 0.0 && dy == 0.0)
                    break;
                
				_actualFrame = _mouseDownFrame;
				_actualFrame.origin.x += dx;
				_actualFrame.origin.y += dy;
                [self sendRepositionNotification];
			}
            
			break;
		}
            
        case NSLeftMouseUp:
            _mouseIsDown = NO;
			break;
            
        case NSRightMouseDown:
            _rightMouseIsDown = YES;
            break;
            
        case NSRightMouseUp:
            _rightMouseIsDown = NO;
            break;
            
        case NSOtherMouseDown:
            _otherMouseIsDown = YES;
            break;
            
        case NSOtherMouseUp:
            _otherMouseIsDown = NO;
            break;
            
        default:
            isMouseEvent = NO;
	}
	
    if (isMouseEvent)
        _timeOfLastMouseInteraction = NSDate.timeIntervalSinceReferenceDate;
    
	[super sendEvent:event];
}

- (BOOL) isOpaque
{
    // CJC: I can't figure out why this doesn't work.
    //return (transparent == NO);
    
    // For now, windows are always non-opaque.
    return NO;
    
    // CJC: testing
    //return YES;
}

/*
- (void) setTransparent:(BOOL)b
{
    if (transparent == b)
        return;
    
    transparent = b;
    
    //float alpha = (transparent) ? 0.0f : 1.0f;
    //self.backgroundColor = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:alpha];
    
    self.backgroundColor = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:0.0];
}
*/

- (BOOL) isZoomed
{
    return NSEqualRects(self.frame, self.zoomedFrame);
}

- (void) resizeForContentSize:(NSSize)newSize display:(BOOL)display animate:(BOOL)animate
{
    // Invalidate the user frame.
    _userFrame = NSZeroRect;
    
    NSSize oldContentSize = [self.contentView frame].size;
    
    CGFloat changeInWidth = newSize.width - oldContentSize.width;
    CGFloat changeInHeight = newSize.height - oldContentSize.height;
    
    NSRect newFrame = self.frame;
    newFrame.origin.y -= changeInHeight;
    newFrame.size.width += changeInWidth;
    newFrame.size.height += changeInHeight;
    
    NSRect fittedNewFrame = [self makeFrameFitOnScreen:newFrame];
    
    [self setFrame:fittedNewFrame display:display animate:animate];
}

- (void) adjustToFitOnScreenWithAnimation:(BOOL)animate
{
    NSRect newFrame = [self makeFrameFitOnScreen:self.frame];
    
    [self setFrame:newFrame display:YES animate:animate];
}

- (void) zoom:(id)sender
{
    NSRect newFrame;
    
    BOOL userFrameIsValid = NSEqualRects(_userFrame, NSZeroRect) == NO;
    
    // The user can only unzoom if a valid user frame exists.
    if (self.isZoomed && userFrameIsValid)
    {
        newFrame = [self makeFrameFitOnScreen:_userFrame];
    }
    else
    {
        newFrame  = self.zoomedFrame;
        _userFrame = self.frame;
    }
    
    [self setFrame:newFrame display:YES animate:NO];
}

- (NSRect) makeFrameFitOnScreen:(NSRect)frame
{
    NSRect screenFrame = self.screen.visibleFrame; // Doesn't include menubar, dock, etc.
    
    NSRect newFrame = frame;
    
    // If the frame is larger than the screen's visible frame, resize it (preserving the content aspect).
    
    if (frame.size.width > screenFrame.size.width || frame.size.height > screenFrame.size.height)
    {
        NSSize contentSize = [self contentRectForFrameRect:frame].size;
        CGFloat aspect = contentSize.width / contentSize.height;
        newFrame = [self maxFrameForContentAspect:aspect];
    }
    
    // Now that the frame is definitely small enough, move it to be fully on screen.
    
    newFrame.origin = [self originForFullyVisibleFrame:newFrame];
    
    return newFrame;
}

- (NSRect) maxFrameForContentAspect:(CGFloat)aspect
{
    NSRect screenFrame = self.screen.visibleFrame; // Doesn't include menubar, dock, etc.
    
    NSRect maxContentFrame = [self contentRectForFrameRect:screenFrame];
    CGFloat maxContentAspect = maxContentFrame.size.width / maxContentFrame.size.height;
    
    NSRect newContentFrame = [self contentRectForFrameRect:self.frame];
    
    if (aspect > maxContentAspect)
    {
        newContentFrame.size.width = maxContentFrame.size.width;
        newContentFrame.size.height = floor(maxContentFrame.size.width / aspect);
    }
    else
    {
        newContentFrame.size.height = maxContentFrame.size.height;
        newContentFrame.size.width = floor(maxContentFrame.size.height * aspect);
    }
    
    SGL_ASSERT(newContentFrame.size.width <= maxContentFrame.size.width);
    SGL_ASSERT(newContentFrame.size.height <= maxContentFrame.size.height);
    
    NSRect newFrame = [self frameRectForContentRect:newContentFrame];
    
    return newFrame;
}

- (NSPoint) originForFullyVisibleFrame:(NSRect)frame
{
    NSRect screenFrame = self.screen.visibleFrame; // Doesn't include menubar, dock, etc.
    
    SGL_ASSERT(frame.size.width <= screenFrame.size.width);
    SGL_ASSERT(frame.size.height <= screenFrame.size.height);
    
    NSPoint newOrigin = frame.origin;
    
    if (newOrigin.x < screenFrame.origin.x)
        newOrigin.x = screenFrame.origin.x;
    
    if (newOrigin.y < screenFrame.origin.y)
        newOrigin.y = screenFrame.origin.y;
    
    CGFloat screenRight = screenFrame.origin.x + screenFrame.size.width;
    CGFloat windowRight = newOrigin.x + frame.size.width;
    CGFloat rightOverlap = windowRight - screenRight;
    
    if (rightOverlap > 0.0)
        newOrigin.x -= rightOverlap;
    
    return newOrigin;
}

- (NSRect) zoomedFrame
{
    return self.screen.visibleFrame;
}

- (NSTimeInterval) timeSinceLastMouseInteraction
{
    if (_mouseIsDown || _rightMouseIsDown || _otherMouseIsDown)
        return 0.0;
    
    return NSDate.timeIntervalSinceReferenceDate - _timeOfLastMouseInteraction;
}

- (void) sendRepositionNotification
{
    id controller = (id)self.windowController;
    if ([controller respondsToSelector:@selector(windowDidReposition)])
        [controller windowDidReposition];
}

@end
