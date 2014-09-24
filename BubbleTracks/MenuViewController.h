//
//  ViewController.h
//  appAddMenu
//
//  Created by jules testard on 26/02/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//
//
/**
 * The table view contronller handles how the table with the available audio files 
 */

#import <UIKit/UIKit.h>


@class BubbleTrackView;
@class ViewController;

@interface MenuViewController : UITableViewController <UITableViewDataSource, UIAlertViewDelegate> {
	NSMutableArray *audioUnitArray;
	NSMutableArray *sectionsArray;
    BOOL selected;
    CGPoint lastTouched;
    ViewController * mainViewController;
}

@property (nonatomic, retain) NSMutableArray *audioUnitArray;
@property BOOL selected;
@property CGPoint lastTouched;
@property (nonatomic, strong) ViewController * mainViewController;
- (void) setUpMenuView:(CGPoint)touch;

@end