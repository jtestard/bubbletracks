//
//  AudioTrack.h
//  BubbleTracks
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//
#import "TheAmazingAudioEngine.h"

@interface AudioTrack : NSObject

@property (strong, nonatomic) NSString              *trackName;
@property (strong, nonatomic) AEAudioFilePlayer     *player;
@property (strong, nonatomic) AEAudioController     *controller;

- (id) initWithName:(NSString*) trackName andController:(AEAudioController*) controller;

@end
