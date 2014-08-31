//
//  AudioFilter.h
//  BubbleTracks
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "TheAmazingAudioEngine.h"

@interface AudioEffect : NSObject {
    Float32 xAxis;
    Float32 yAxis;
}

@property (nonatomic, strong) NSString                      *effectName;
@property (nonatomic, strong) NSObject <AEAudioFilter>      *filter;
@property (nonatomic, strong) AEAudioController             *controller;

- (id) initWithName:(NSString*) effectName andController:(AEAudioController*) controller;

- (void) modifyEffectX:(Float32) x Y:(Float32) y;

- (void) disable;

- (void) enable;

@end