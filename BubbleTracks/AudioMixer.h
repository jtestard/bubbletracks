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
@property (nonatomic, strong) NSMutableDictionary   *effects;
@property                     float                 bpm;

-(id) init;

-(void) addTrack:(NSString*) nameWithExtension;
-(void) removeTrack:(NSString*) nameWithExtension;
-(void) unmuteTrack:(NSString*) nameWithExtension;
-(void) muteTrack:(NSString*) nameWithExtension;
-(void) addEffect:(NSString*) effectName;
-(void) removeEffect:(NSString*) effectName;
-(void) enableEffect:(NSString*) effectName;
-(void) disableEffect:(NSString*) effectName;
-(void) recordTime;
-(BOOL) linkTrack:(NSString*) track toEffect:(NSString*) effect;
-(BOOL) unlinkTrack:(NSString*) track toEffect:(NSString*) effect;
- (void) modifyEffect:(NSString*)effectName X:(Float32) x Y:(Float32) y;

@end
