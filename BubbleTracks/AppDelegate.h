//
//  AppDelegate.h
//  BubbleTracks
//
//  Created by Jules Testard on 29/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AEAudioController.h"

@class AEAudioController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AEAudioController *audioController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
