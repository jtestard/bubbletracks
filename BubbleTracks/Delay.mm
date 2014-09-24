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
                          1.0,
                          0);
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kDelayParam_WetDryMix,
                          kAudioUnitScope_Global,
                          0,
                          50.0,
                          0);
    ((AEAudioUnitFilter*)self.filter).bypassed = YES;
    return self;
}

- (void) modifyEffectX:(Float32) x Y:(Float32) y {
    [super modifyEffectX:x Y:y];
    AudioUnitParameterValue delaytime;
    AudioUnitGetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kDelayParam_DelayTime,
                          kAudioUnitScope_Global,
                          0,
                          &delaytime);
    AudioUnitParameterValue dryWetValue;
    AudioUnitGetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kDelayParam_WetDryMix,
                          kAudioUnitScope_Global,
                          0,
                          &dryWetValue); 
    //Harmonize the change.
    x = x * 0.05;
    y = y * 0.2;
    delaytime += x;
    dryWetValue += y;
    if (dryWetValue < 0) dryWetValue = 0;
    if (delaytime < 0) delaytime = 0;
    if (delaytime > 2) delaytime = 2;
    if (dryWetValue > 100) dryWetValue = 100;
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kDelayParam_DelayTime,
                          kAudioUnitScope_Global,
                          0,
                          delaytime,
                          0);
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kDelayParam_WetDryMix,
                          kAudioUnitScope_Global,
                          0,
                          dryWetValue,
                          0);
    NSLog(@"Delay Time : %f, DryWetValue : %f",delaytime,dryWetValue);
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
