//
//  LowPassFilter.m
//  BubbleTracks
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "LowPassFilter.h"

@implementation LowPassFilter

- (id) initWithName:(NSString*) effectName andController:(AEAudioController*) controller {
    self = [super init];
    self.filter = [[AEAudioUnitFilter alloc]
                   initWithComponentDescription:AEAudioComponentDescriptionMake(
                                                                                kAudioUnitManufacturer_Apple,
                                                                                kAudioUnitType_Effect,
                                                                                kAudioUnitSubType_LowPassFilter)
                   audioController:controller error:NULL];
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kLowPassParam_CutoffFrequency,
                          kAudioUnitScope_Global,
                          0,
                          500.0,
                          0);
    return self;
}

- (void) modifyEffectX:(Float32) x Y:(Float32) y {
    [super modifyEffectX:x Y:y];
}

-(void) enable {
    AEAudioUnitFilter* lp = (AEAudioUnitFilter*) self.filter;
    lp.bypassed = NO;
}

-(void) disable {
    AEAudioUnitFilter* lp = (AEAudioUnitFilter*) self.filter;
    lp.bypassed = YES;
}

@end
