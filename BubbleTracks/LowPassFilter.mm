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
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kLowPassParam_Resonance,
                          kAudioUnitScope_Global,
                          0,
                          0.0,
                          0);
    ((AEAudioUnitFilter*)self.filter).bypassed = YES;
    return self;
}

- (void) modifyEffectX:(Float32) x Y:(Float32) y {
    [super modifyEffectX:x Y:y];
    AudioUnitParameterValue cutoffFrequencyValue;
    AudioUnitGetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kLowPassParam_CutoffFrequency,
                          kAudioUnitScope_Global,
                          0,
                          &cutoffFrequencyValue);
    AudioUnitParameterValue resonanceValue;
    AudioUnitGetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kLowPassParam_Resonance,
                          kAudioUnitScope_Global,
                          0,
                          &resonanceValue);
    //Harmonize the change.
    x = x * 5.5;
    y = y * 0.2;
    cutoffFrequencyValue += x;
    resonanceValue += y;
    if (resonanceValue < -20) resonanceValue = 20;
    if (cutoffFrequencyValue < 100) cutoffFrequencyValue = 100;
    if (cutoffFrequencyValue > 5000) cutoffFrequencyValue = 5000;
    if (resonanceValue > 40) resonanceValue = 40;
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kLowPassParam_CutoffFrequency,
                          kAudioUnitScope_Global,
                          0,
                          cutoffFrequencyValue,
                          0);
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kLowPassParam_Resonance,
                          kAudioUnitScope_Global,
                          0,
                          resonanceValue,
                          0);
    NSLog(@"Cutoff Frequency : %f, Resonance : %f",cutoffFrequencyValue,resonanceValue);
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
