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

@property (nonatomic, strong) NSString* effectName;
@property (nonatomic, strong) NSObject <AEAudioFilter>   *filter;

- (id) initWithName:(NSString*) effectName;

- (void) modifyEffectX:(Float32) x Y:(Float32) y;

- (void) disable;

- (void) enable;

@end