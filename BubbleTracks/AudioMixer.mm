//
//  AudioMixer.m
//  AEUnitSample
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "AudioMixer.h"
#import "AudioEffect.h"
#import "Reverb.h"
#import "BandPassFilter.h"
#import "LowPassFilter.h"
#import "HighPassFilter.h"
#import "Delay.h"

#define SAMPLE_RATE 44100
#define BPM 120
#define SECS_PER_MINUTE 60
#define TOLERANCE 2

UInt32 samplerate;
UInt32 rateIndex;
UInt32 tempoRate;
UInt32 quantizeRegion;
UInt32 tolerance;

@interface AudioMixer () {
}
@end

@implementation AudioMixer

-(id) init {
    self = [super init];
    
    self.controller = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:NO];
    self.filePlayers = [[NSMutableDictionary alloc] init];
    self.effects = [[NSMutableDictionary alloc] init];
    self.bpm = BPM;
    samplerate = SAMPLE_RATE;
    rateIndex=0;
    tempoRate = (UInt32)(((double)SECS_PER_MINUTE / (double)self.bpm) * samplerate);
    quantizeRegion = 0;
    tolerance = TOLERANCE;
    
    NSError *errorAudioSetup = NULL;
    BOOL result = [self.controller start:&errorAudioSetup];
    if ( !result ) {
        NSLog(@"Error starting audio engine: %@", errorAudioSetup.localizedDescription);
    }
    [self recordTime];
    return self;
}

-(void) recordTime {
    self.timeChannel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp  *time,
                                       UInt32 frames,
                                       AudioBufferList *audio) {
        for ( int i=0; i<frames; i++ ) {
            rateIndex = (rateIndex+1)%samplerate;
            if(rateIndex == (tempoRate + quantizeRegion)%samplerate) {
                quantizeRegion = (tempoRate + quantizeRegion)%samplerate;
            }
        }
    }];
    [self.controller addChannels:@[self.timeChannel]];
}


-(void) addTrack:(NSString*) nameWithExtension {
    if (![self.filePlayers objectForKey:nameWithExtension]) {
        NSArray* nameAndExtension = [nameWithExtension componentsSeparatedByString:@"."];
        NSString* name = (NSString*)[nameAndExtension objectAtIndex:0];
        NSString* extension = (NSString*)[nameAndExtension objectAtIndex:1];
        AEAudioFilePlayer* player = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:name withExtension:extension]
                                                              audioController: self.controller
                                                                        error:NULL];
        player.volume = 1.0;
        player.channelIsMuted = YES;
        player.loop = YES;
        while(!(quantizeRegion-tolerance <= rateIndex && rateIndex <= quantizeRegion+tolerance)){
            //wait for the quantization
        }
        [self.controller addChannels:@[player]];
        self.filePlayers[nameWithExtension] = player;
    } else {
        NSLog(@"Trying to add the file %@, but this file is already being played. This is not possible yet.",nameWithExtension);
    }
}

-(void) removeTrack:(NSString*) nameWithExtension {
    AEAudioFilePlayer* player = (AEAudioFilePlayer*) self.filePlayers[nameWithExtension];
    [self.controller removeChannels:@[player]];
    [self.filePlayers removeObjectForKey:nameWithExtension];
    player = nil;
}

-(void) unmuteTrack:(NSString*) nameWithExtension {
    ((AEAudioFilePlayer*) self.filePlayers[nameWithExtension]).channelIsMuted = NO;

}
-(void) muteTrack:(NSString*) nameWithExtension {
    ((AEAudioFilePlayer*) self.filePlayers[nameWithExtension]).channelIsMuted = YES;
}

- (void) modifyEffect:(NSString*)effectName X:(Float32) x Y:(Float32) y {
    AudioEffect* effect = (AudioEffect*)[self.effects objectForKey:effectName];
    if (effect) {
        [effect modifyEffectX:x Y:y];
    } else {
        NSLog(@"Trying to modify the effect %@, but it doesn't exist!",effectName);
    }
}

-(void) addEffect:(NSString*) effectName {
    if (![self.effects objectForKey:effectName]) {
        if ([effectName isEqualToString:@"BandPassFilter"]) {
            self.effects[effectName] = [[BandPassFilter alloc] initWithName:effectName];
        } else if ([effectName isEqualToString:@"Delay"]) {
            self.effects[effectName] = [[Delay alloc] initWithName:effectName];
        } else if ([effectName isEqualToString:@"HighPassFilter"]) {
            self.effects[effectName] = [[HighPassFilter alloc] initWithName:effectName];
        } else if ([effectName isEqualToString:@"LowPassFilter"]) {
            self.effects[effectName] = [[LowPassFilter alloc] initWithName:effectName];
        } else if ([effectName isEqualToString:@"Reverb"]) {
            self.effects[effectName] = [[Reverb alloc] initWithName:effectName];
        } else {
            NSLog(@"Trying to add the effect %@, but it is not recognized as a valid effect name.", effectName);
        }
    } else {
        NSLog(@"Trying to add the effect %@, but this file is already being played. This is not possible yet.",effectName);
    }
}

-(void) removeEffect:(NSString*) effectName {
    AudioEffect* effect = (AudioEffect*) [self.effects objectForKey:effectName];
    [self.effects removeObjectForKey:effectName];
    effect = nil;
}

-(void) enableEffect:(NSString*) effectName {
    [((AudioEffect*) [self.effects objectForKey:effectName]) enable];
}

-(void) disableEffect:(NSString*) effectName {
    [((AudioEffect*) [self.effects objectForKey:effectName]) disable];
}

-(BOOL) linkTrack:(NSString*) track toEffect:(NSString*) effect {
    NSLog(@"link track %@ to effect %@",track,effect);
    return true;
}

-(BOOL) unlinkTrack:(NSString*) track toEffect:(NSString*) effect {
    NSLog(@"unlink track %@ from effect %@",track,effect);
    return true;
}

@end
