//
//  AudioMixer.m
//  AEUnitSample
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "AudioMixer.h"

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
    float milestone;
    NSTimeInterval startTime;
}
@end

@implementation AudioMixer

-(id) init {
    self = [super init];
    
    self.controller = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:NO];
    self.filePlayers = [[NSMutableDictionary alloc] init];
    self.bpm = BPM;
    startTime = [AEBlockScheduler secondsFromHostTicks:[AEBlockScheduler now]];
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


-(void) addTrack:(NSString*) name andExtension:(NSString*) extension {
    NSString* fullname = [NSString stringWithFormat:@"%@.%@", name, extension];
    if (![self.filePlayers objectForKey:fullname]) {
        AEAudioFilePlayer* player = [AEAudioFilePlayer audioFilePlayerWithURL:[[NSBundle mainBundle] URLForResource:name withExtension:extension]
                                                              audioController: self.controller
                                                                        error:NULL];
        player.volume = 1.0;
        player.channelIsMuted = NO;
        player.loop = YES;
        while(!(quantizeRegion-tolerance <= rateIndex && rateIndex <= quantizeRegion+tolerance)){
            //wait for the quantization
        }
        [self.controller addChannels:@[player]];
        self.filePlayers[fullname] = player;
    }
}

-(void) removeTrack:(NSString*) name andExtension:(NSString*) extension {
    NSString* fullname = [NSString stringWithFormat:@"%@.%@", name, extension];
    AEAudioFilePlayer* player = (AEAudioFilePlayer*) self.filePlayers[fullname];
    [self.controller removeChannels:@[player]];
    [self.filePlayers removeObjectForKey:fullname];
    player = nil;
}

-(void) unmuteTrack:(NSString*) name withExtension:(NSString*) extension {
    ((AEAudioFilePlayer*) self.filePlayers[[NSString stringWithFormat:@"%@.%@", name, extension]]).channelIsMuted = NO;

}
-(void) muteTrack:(NSString*) name withExtension:(NSString*) extension {
    ((AEAudioFilePlayer*) self.filePlayers[[NSString stringWithFormat:@"%@.%@", name, extension]]).channelIsMuted = YES;
}



@end
