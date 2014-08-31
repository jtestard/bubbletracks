//
//  AudioTrack.m
//  BubbleTracks
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "AudioTrack.h"

@implementation AudioTrack

- (id) initWithName:(NSString*) nameWithExtension andController:(AEAudioController*) controller {
    self = [[AudioTrack alloc] init];
    NSArray* nameAndExtension = [nameWithExtension componentsSeparatedByString:@"."];
    NSString* name = (NSString*)[nameAndExtension objectAtIndex:0];
    NSString* extension = (NSString*)[nameAndExtension objectAtIndex:1];
    self.trackName = nameWithExtension;
    self.controller = controller;
    AEAudioFilePlayer* player = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:name withExtension:extension]
                                                          audioController: self.controller
                                                                    error:NULL];
    player.volume = 1.0;
    player.channelIsMuted = YES;
    player.loop = YES;
    self.player = player;
    return self;
}

@end
