//
//  LinkView.m
//  BubbleTrack_6
//
//  Created by jules testard on 28/02/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import "LinkView.h"

@implementation LinkView

@synthesize firstView, secondView;


//This class assumes firstView is a track view and second view is a FX view
- (id) initWithColor:(UIColor*) color firstView:(BubbleView*) afirstView secondView:(BubbleView*) asecondView andFrame:(CGRect) rect {
    self = [super initWithFrame:rect];
    if (![afirstView isMemberOfClass:[BubbleTrackView class]]) {
        NSLog(@"WARNING : linkView init : first is not a track view.");
    }
    self.firstView = (BubbleTrackView*)afirstView; // Always a track.
    if (![asecondView isMemberOfClass:[BubbleFXView class]]) {
        NSLog(@"WARNING : linkView init : second is not a fx view.");
    }    
    self.secondView = (BubbleFXView*)asecondView; //Always an effect.
    NSLog(@"Link view initialized");
    [self setOpaque:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setNeedsDisplay];
    return self;
}

- (BOOL) isHighlighted {
    return NO;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext(); //get the graphics context
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1);
    CGContextSetLineWidth(ctx, 3.0f);
    double width = secondView.center.x - firstView.center.x;
    double height = secondView.center.y - firstView.center.y;
    if ((width>0 && height>0) || (width < 0 && height < 0)) {
        CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(ctx, rect.size.width+rect.origin.x,rect.size.height+rect.origin.y);        
    } else {
        CGContextMoveToPoint(ctx, rect.origin.x+rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(ctx, rect.origin.x,rect.size.height+rect.origin.y);        
    }
    CGContextStrokePath(ctx);
}

- (void) updateFrame{
    CGRect rect = CGRectMake(self.firstView.frame.origin.x+self.firstView.frame.size.width/2, self.firstView.frame.origin.y+self.firstView.frame.size.height/2, self.secondView.frame.origin.x-self.firstView.frame.origin.x, self.secondView.frame.origin.y-firstView.frame.origin.y);
    self.frame = rect;
    [self setNeedsDisplay];
}

- (void) removeLink {
    [firstView.linkArray removeObject:self];
    [secondView.linkArray removeObject:self];
}

@end
