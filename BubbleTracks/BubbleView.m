//
//  BubbleView.m
//  BubbleTrack_6
//
//  Created by jules testard on 27/02/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import "BubbleView.h"
#import "LinkView.h"

int const TRACK = 0;
int const FX = 1;

@implementation BubbleView

@synthesize linkArray, name, size, type, title,color, center;

// Will update the position frame and bounds attribute of a BubbleView using the coordinates of update as its center.
- (void) updateFrameAndBounds:(CGPoint)  update {
    CGFloat xOff = update.x;
    CGFloat yOff = update.y;
    self.center = update;
    self.frame = CGRectMake(xOff-self.frame.size.width/2, yOff-self.frame.size.height/2,self.frame.size.width,self.frame.size.height);
    self.bounds = CGRectMake(xOff-self.frame.size.width/2, yOff-self.frame.size.height/2,self.frame.size.width,self.frame.size.height);
    int off = 20;
    if (self.type)off=0;
    self.title.frame = CGRectMake(xOff-self.title.frame.size.width/2, yOff-off-self.title.frame.size.height/2,self.title.frame.size.width,self.title.frame.size.height);
    for (int i = 0 ; i < linkArray.count ; i++) {
        LinkView* link = (LinkView*) [linkArray objectAtIndex:i];
        [link updateFrame];
    }
}

- (id) initWithName:(NSString *)aName Image:(UIImage *)image HighlightedImage:(UIImage *)highlightedImage Location:(CGPoint)location {
    self = [super initWithImage:image highlightedImage:highlightedImage];
    self.linkArray = [[NSMutableArray alloc] init];
    self.name = aName;
    self.size = 100; //default size
    self.frame = CGRectMake(location.x, location.y, self.size, self.size);
    self.bounds = CGRectMake(location.x, location.y, self.size, self.size);
    self.center = CGPointMake(self.frame.origin.x+self.frame.size.width/2, self.frame.origin.y+self.frame.size.height/2);    
    NSLog(@"Center location@init : %f,%f", center.x, center.y);    
    return self;
}

// Links this view with another view. Returns YES if the link is implemented succesfully.
- (BOOL) linkWith:(BubbleView*) view {
    [self.linkArray addObject:view];
    [view.linkArray addObject:self];
    return YES;
}

- (void) resize:(int) newSize {  
    self.size = newSize;    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size, size);
    self.bounds = CGRectMake(self.frame.origin.x, self.frame.origin.y, size, size);
}

- (void) removeAllLinks {
    for (int i = 0 ; i < linkArray.count ; i++) {
        LinkView* view = (LinkView*)[linkArray objectAtIndex:i];
        //If the first view of the link is self.
        if ([view.firstView isEqual:self]) {
            [view.secondView.linkArray removeObject:view];
        }
        //If the second view of the link is self. Assumes that link is well built.
        else {
            [view.firstView.linkArray removeObject:view];
        }
        [view removeFromSuperview];
        view=nil;
    }
    linkArray = nil;
}

@end
