//
//  BubbleTrackView.m
//  BubblesTracks
//
//  Created by jules testard on 09/02/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//
#import "BubbleTrackView.h"

@implementation BubbleTrackView

//@synthesize audioTrack;

- (id)initWithName:(NSString*)aName Image:(UIImage*)image HighlightedImage:(UIImage*)highlightedImage Location:(CGPoint)location{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    self.linkArray = [[NSMutableArray alloc] init];
    self.name = aName;
    self.color = @"blue";
    self.size = 100;
    self.type = 0;
    self.frame = CGRectMake(location.x, location.y, 100, 100);
    self.bounds = CGRectMake(location.x, location.y, 100, 100);
    self.center = CGPointMake(location.x+self.frame.size.width/2, location.y+self.frame.size.height/2);    
    //self.audioTrack = [[AudioTrack alloc] initWithName:aName];
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(location.x+15, location.y+20, 70, 20)];
    [self.title setText:aName];
    [self.title setTextColor:[UIColor blackColor]];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self.title setFont:[UIFont fontWithName: @"Trebuchet MS" size: 12.0f]]; 
    [self addSubview:self.title];
    return self;
}
@end
