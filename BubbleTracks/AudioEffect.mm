//
//  AudioFilter.m
//  BubbleTracks
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "AudioEffect.h"

@implementation AudioEffect

- (id) initWithName:(NSString*) effectName andController:(AEAudioController*) controller{
    self = [[AudioEffect alloc] init];
    xAxis=0.5;
    yAxis=0.5;
    self.effectName = effectName;
    self.filter = nil;
    self.controller = controller;
    return self;
}

//TODO: more testing to determin the validity of the 80.0 measure.
- (void) modifyEffectX:(Float32) x Y:(Float32) y {
    xAxis+=((Float32)x)/80.0;
    yAxis+=((Float32)y)/80.0;
    [self avoidClipping];
    //NSLog(@"Effect Modified %@ (%f,%f)",self.effectName,x,y);
}

-(void) avoidClipping {
    if (xAxis<0.01)
        xAxis = 0.01;
    if (yAxis<0.01)
        yAxis = 0.01;
    if (xAxis>0.99)
        xAxis = 0.99;
    if (yAxis>0.99)
        yAxis = 0.99;
}

-(void) enable {
    //Nothing. Must be implemented by subclass
    NSLog(@"You are calling enable on an AudioEffect object, or a subclass in which you did not override the enable method.");
}

-(void) disable {
    //Nothing. Must be implemented by subclass
    NSLog(@"You are calling disable on an AudioEffect object, or a subclass in which you did not override the disable method.");
}

@end
