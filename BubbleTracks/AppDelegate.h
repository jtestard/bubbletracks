//
//  AppDelegate.h
//  BubbleTracks
//
//  Created by Jules Testard on 29/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController* viewController;

@property (strong, nonatomic) UISplitViewController* splitViewController;

-(void)showViewController;

-(void)showSplitViewController;

@end
