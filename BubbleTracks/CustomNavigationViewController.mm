//
//  CustomNavigationViewController.m
//  BubbleTracks
//
//  Created by jules testard on 30/03/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import "CustomNavigationViewController.h"
#import "MenuViewController.h"

@interface CustomNavigationViewController ()

@end

@implementation CustomNavigationViewController 

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    
	if([[self.viewControllers lastObject] class] == [MenuViewController class]){
        MenuViewController* menuViewController = (MenuViewController*) self.viewControllers.lastObject;
        menuViewController.selected = false;
		return [super popViewControllerAnimated:animated];
	} else {
		return [super popViewControllerAnimated:animated];
	}
}

@end
