//
//  BubbleFXView.m
//  BubbleTrack_6
//
//  Created by jules testard on 27/02/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import "BubbleFXView.h"

@implementation BubbleFXView

@synthesize audioEffectName;

- (id)initWithName:(NSString*)aName Image:(UIImage*)image HighlightedImage:(UIImage*)highlightedImage Location:(CGPoint)location{
    self = [super initWithImage:image highlightedImage:highlightedImage];
    self.name = name;
    self.color = @"blue";
    self.linkArray = [[NSMutableArray alloc] init];    
    self.frame = CGRectMake(location.x, location.y, 100, 100);
    self.bounds = CGRectMake(location.x, location.y, 100, 100);
    self.size = 100;
    self.type = 1;
    self.center = CGPointMake(location.x+self.frame.size.width/2, location.y+self.frame.size.height/2);    
    int fXType=0;
    if ([aName isEqualToString: @"LowPassFilter"]) {
        fXType = 0;
    } else if ([aName isEqualToString: @"bandPassFilter"]) {
        fXType = 1;
    } else {
        NSLog(@"Error : unknown effect type : %@", aName);
        return self;
    }
    self.audioEffectName = name; //this will change XXX
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(location.x+15, location.y+40, 70, 20)];
    [self.title setText:aName];
    [self.title setTextColor:[UIColor blackColor]];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self.title setFont:[UIFont fontWithName: @"Trebuchet MS" size: 12.0f]]; 
    [self addSubview:self.title];    
    return self;
}
@end
