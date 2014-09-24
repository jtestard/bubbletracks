//
//  BandPassFilter.m
//  BubbleTracks
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "BandPassFilter.h"

@implementation BandPassFilter

- (id) initWithName:(NSString*) effectName andController:(AEAudioController*) controller {
    self = [super init];
    self.filter = [[AEAudioUnitFilter alloc]
                   initWithComponentDescription:AEAudioComponentDescriptionMake(
                                                                                kAudioUnitManufacturer_Apple,
                                                                                kAudioUnitType_Effect,
                                                                                kAudioUnitSubType_BandPassFilter)
                   audioController:controller error:NULL];
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kBandpassParam_CenterFrequency,
                          kAudioUnitScope_Global,
                          0,
                          700.0,
                          0);
    ((AEAudioUnitFilter*)self.filter).bypassed = YES;
    return self;
}

- (void) modifyEffectX:(Float32) x Y:(Float32) y {
    [super modifyEffectX:x Y:y];
    AudioUnitParameterValue centerFrequencyValue;
    AudioUnitGetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kBandpassParam_CenterFrequency,
                          kAudioUnitScope_Global,
                          0,
                          &centerFrequencyValue);
    AudioUnitParameterValue bandwithValue;
    AudioUnitGetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kBandpassParam_Bandwidth,
                          kAudioUnitScope_Global,
                          0,
                          &bandwithValue);
    //Harmonize the change.
    x = x * 5.5;
    y = y * 1.0;
    centerFrequencyValue += x;
    bandwithValue += y;
    if (bandwithValue < 100) bandwithValue = 100;
    if (centerFrequencyValue < 100) centerFrequencyValue = 100;
    if (centerFrequencyValue > 5000) centerFrequencyValue = 5000;
    if (bandwithValue > 10000) bandwithValue = 10000;
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kBandpassParam_CenterFrequency,
                          kAudioUnitScope_Global,
                          0,
                          centerFrequencyValue,
                          0);
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kBandpassParam_Bandwidth,
                          kAudioUnitScope_Global,
                          0,
                          bandwithValue,
                          0);
    NSLog(@"Center Frequency : %f, BandWith : %f",centerFrequencyValue,bandwithValue);
}

-(void) enable {
    AEAudioUnitFilter* bp = (AEAudioUnitFilter*) self.filter;
    bp.bypassed = NO;
}

-(void) disable {
    AEAudioUnitFilter* bp = (AEAudioUnitFilter*) self.filter;
    bp.bypassed = YES;
}

@end
