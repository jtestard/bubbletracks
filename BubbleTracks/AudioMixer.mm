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
#import "AudioTrack.h"

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
        AudioTrack* audioTrack = [[AudioTrack alloc] initWithName:nameWithExtension andController:self.controller];
        while(!(quantizeRegion-tolerance <= rateIndex && rateIndex <= quantizeRegion+tolerance)){
            //wait for the quantization
        }
        [self.controller addChannels:@[audioTrack.player]];
        self.filePlayers[nameWithExtension] = audioTrack;
    } else {
        NSLog(@"Trying to add the file %@, but this file is already being played. This is not possible yet.",nameWithExtension);
    }
}

-(void) removeTrack:(NSString*) nameWithExtension {
    AudioTrack* audioTrack = (AudioTrack*) self.filePlayers[nameWithExtension];
    AEAudioFilePlayer* player = audioTrack.player;
    [self.controller removeChannels:@[player]];
    [self.filePlayers removeObjectForKey:nameWithExtension];
    player = nil;
    audioTrack = nil;
}

-(void) unmuteTrack:(NSString*) nameWithExtension {
    ((AudioTrack*) self.filePlayers[nameWithExtension]).player.channelIsMuted = NO;

}
-(void) muteTrack:(NSString*) nameWithExtension {
    ((AudioTrack*) self.filePlayers[nameWithExtension]).player.channelIsMuted = YES;
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
            self.effects[effectName] = [[BandPassFilter alloc] initWithName:effectName andController:self.controller];
        } else if ([effectName isEqualToString:@"Delay"]) {
            self.effects[effectName] = [[Delay alloc] initWithName:effectName andController:self.controller];
        } else if ([effectName isEqualToString:@"HighPassFilter"]) {
            self.effects[effectName] = [[HighPassFilter alloc] initWithName:effectName andController:self.controller];
        } else if ([effectName isEqualToString:@"LowPassFilter"]) {
            self.effects[effectName] = [[LowPassFilter alloc] initWithName:effectName andController:self.controller];
        } else if ([effectName isEqualToString:@"Reverb"]) {
            self.effects[effectName] = [[Reverb alloc] initWithName:effectName andController:self.controller];
        } else {
            NSLog(@"Trying to add the effect %@, but it is not recognized as a valid effect name.", effectName);
        }
    } else {
        NSLog(@"Trying to add the effect %@, but this file is already being played. This is not possible yet.",effectName);
    }
}

-(void) removeEffect:(NSString*) effectName {
    AudioEffect* effect = (AudioEffect*) [self.effects objectForKey:effectName];
    [self.controller removeFilter:effect.filter];
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
    if (![self.filePlayers objectForKey:track] || ![self.effects objectForKey:effect]) {
        NSLog(@"There was a problem linking %@ to %@",track,effect);
        return false;
    }
    AudioTrack* audioTrack = (AudioTrack*)[self.filePlayers objectForKey:track];
    AudioEffect* audioEffect = (AudioEffect*)[self.effects objectForKey:effect];
    //Link the effect to the track channel
    [self.controller addFilter:audioEffect.filter toChannel:audioTrack.player];
    return true;
}

-(BOOL) unlinkTrack:(NSString*) track toEffect:(NSString*) effect {
    NSLog(@"unlink track %@ from effect %@",track,effect);
    if (![self.filePlayers objectForKey:track] || ![self.effects objectForKey:effect]) {
        NSLog(@"There was a problem linking %@ to %@",track,effect);
        return false;
    }
    AudioTrack* audioTrack = (AudioTrack*)[self.filePlayers objectForKey:track];
    AudioEffect* audioEffect = (AudioEffect*)[self.effects objectForKey:effect];
    //Link the effect to the track channel
    [self.controller removeFilter:audioEffect.filter fromChannel:audioTrack.player];
    return true;
}

@end
