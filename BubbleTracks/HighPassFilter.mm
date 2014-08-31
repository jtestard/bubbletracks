//
//  HighPassFilter.m
//  BubbleTracks
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "HighPassFilter.h"

@implementation HighPassFilter

- (id) initWithName:(NSString*) effectName andController:(AEAudioController*) controller {
    self = [super init];
    self.filter = [[AEAudioUnitFilter alloc]
                   initWithComponentDescription:AEAudioComponentDescriptionMake(
                                                                                kAudioUnitManufacturer_Apple,
                                                                                kAudioUnitType_Effect,
                                                                                kAudioUnitSubType_HighPassFilter)
                   audioController:controller error:NULL];
    AudioUnitSetParameter(((AEAudioUnitFilter*)self.filter).audioUnit,
                          kHipassParam_CutoffFrequency,
                          kAudioUnitScope_Global,
                          0,
                          900.0,
                          0);
    return self;
}

- (void) modifyEffectX:(Float32) x Y:(Float32) y {
    [super modifyEffectX:x Y:y];
}

-(void) enable {
    AEAudioUnitFilter* hp = (AEAudioUnitFilter*) self.filter;
    hp.bypassed = NO;
}

-(void) disable {
    AEAudioUnitFilter* hp = (AEAudioUnitFilter*) self.filter;
    hp.bypassed = YES;
}

@end
