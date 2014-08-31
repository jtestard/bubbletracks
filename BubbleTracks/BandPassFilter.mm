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
    return self;
}

- (void) modifyEffectX:(Float32) x Y:(Float32) y {
    [super modifyEffectX:x Y:y];
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
