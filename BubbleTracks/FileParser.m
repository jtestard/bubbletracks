//
//  FileParser.m
//  BubbleTracks
//
//  Created by jules testard on 28/03/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import "FileParser.h"
#import "TrackWrapper.h"
#import "FXWrapper.h"

@implementation FileParser

- (NSMutableArray*) generateTrackWrappers {
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];    
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp3'"];
    NSArray *audiofiles = [dirContents filteredArrayUsingPredicate:fltr];    
    NSArray *names = audiofiles;
    NSMutableArray * trackUnitArray = [[NSMutableArray alloc] initWithCapacity:[names count]];
    //Needs to be replaced by a more thorough check.
    if (true) {
        for (int i = 0 ; i < [names count] ; i++) {
            TrackWrapper* trackWrapper = [[TrackWrapper alloc] initWithInstrument:@"loop" Name:[names objectAtIndex:i] Type:0];
            [trackUnitArray addObject:trackWrapper];
        }
    } else {
        NSLog(@"Original data for wavefiles corrupted.");
    }
    return trackUnitArray;
}

- (NSMutableArray*) generatefXWrappers {
    NSArray * fXNames = [NSArray arrayWithObjects:@"Delay",@"HighPassFilter",@"Reverb",@"LowPassFilter",@"BandPassFilter",nil];
    NSArray * fXTypes = [NSArray arrayWithObjects:@"filter",@"filter",@"filter",@"filter",@"filter",nil];
    NSMutableArray * fXUnitArray = [[NSMutableArray alloc] initWithCapacity:[fXNames count]];
    if ([fXNames count] == [fXTypes count]) {
        for (int i = 0 ; i < [fXNames count] ; i++) {
            FXWrapper* fXWrapper = [[FXWrapper alloc] initWithInstrument:[fXTypes objectAtIndex:i] Name:[fXNames objectAtIndex:i] Type:1];
            [fXUnitArray addObject:fXWrapper];
        }
    } else {
        NSLog(@"Original data for effects corrupted.");
    }
    return fXUnitArray;
}

@end
