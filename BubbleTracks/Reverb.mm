//
//  ReverbEffect.m
//  BubbleTracks
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "Reverb.h"

@implementation Reverb

- (id) initWithName:(NSString*) effectName andController:(AEAudioController*) controller {
    self = [super init];
    self.filter = [[AEAudioUnitFilter alloc]
                   initWithComponentDescription:AEAudioComponentDescriptionMake(
                                                        kAudioUnitManufacturer_Apple,
                                                        kAudioUnitType_Effect,
                                                        kAudioUnitSubType_Reverb2)
                   audioController:controller error:NULL];
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kReverb2Param_DryWetMix,
                          kAudioUnitScope_Global,
                          0,
                          100.0,
                          0);
    ((AEAudioUnitFilter*)self.filter).bypassed = YES;
    return self;
}

- (void) modifyEffectX:(Float32) x Y:(Float32) y {
    [super modifyEffectX:x Y:y];
    //Not implemented yet.
}

-(void) enable {
    AEAudioUnitFilter* reverb = (AEAudioUnitFilter*) self.filter;
    reverb.bypassed = NO;
}

-(void) disable {
    AEAudioUnitFilter* reverb = (AEAudioUnitFilter*) self.filter;
    reverb.bypassed = YES;
}

@end
