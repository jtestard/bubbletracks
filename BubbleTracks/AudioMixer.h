//
//  AudioMixer.h
//  AEUnitSample
//
//  Created by Jules Testard on 30/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheAmazingAudioEngine.h"

@interface AudioMixer : NSObject

@property (nonatomic, strong) AEAudioController     *controller;
@property (nonatomic, strong) AEBlockChannel        *timeChannel;
@property (nonatomic, strong) NSMutableDictionary   *filePlayers;
@property                     float                 bpm;

-(id) init;

-(void) addTrack:(NSString*) name andExtension:(NSString*) extension;
-(void) removeTrack:(NSString*) name andExtension:(NSString*) extension;
-(void) unmuteTrack:(NSString*) name withExtension:(NSString*) extension;
-(void) muteTrack:(NSString*) name withExtension:(NSString*) extension;
-(void) recordTime;

@end
