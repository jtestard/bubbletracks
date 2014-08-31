//
//  Delay.m
//  BubbleTracks
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "Delay.h"

@implementation Delay

- (id) initWithName:(NSString*) effectName andController:(AEAudioController*) controller {
    self = [super init];
    self.filter = [[AEAudioUnitFilter alloc]
                   initWithComponentDescription:AEAudioComponentDescriptionMake(
                                                                                kAudioUnitManufacturer_Apple,
                                                                                kAudioUnitType_Effect,
                                                                                kAudioUnitSubType_Delay)
                   audioController:controller error:NULL];
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kDelayParam_DelayTime,
                          kAudioUnitScope_Global,
                          0,
                          400.0,
                          0);
    return self;
}

- (void) modifyEffectX:(Float32) x Y:(Float32) y {
    [super modifyEffectX:x Y:y];
}

-(void) enable {
    AEAudioUnitFilter* delay = (AEAudioUnitFilter*) self.filter;
    delay.bypassed = NO;
}

-(void) disable {
    AEAudioUnitFilter* delay = (AEAudioUnitFilter*) self.filter;
    delay.bypassed = YES;
}

@end
