//
//  ViewController.h
//  BubbleTracks
//
//  Created by Jules Testard on 29/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;
@class BubbleTrackView;
@class BubbleView;

@interface ViewController : UIViewController<UIGestureRecognizerDelegate> {
        NSMutableArray *bubblesArray;
        CGPoint lastTouched;   
}

@property (nonatomic, retain) NSMutableArray *bubblesArray;
@property (nonatomic, assign) CGPoint lastTouched;

/**
 Handles multiple simultaneous taps by the user in the pond.
 
 Currently, this gesture is only used two link bubbles together.
 Requires the user to tap on a track bubble with one finger and
 an effect bubble with the other.
 */
- (IBAction)handle2FingerTap:(UITapGestureRecognizer *)recognizer;

/**
 Handles events when the user uses a pan (or slide) gesture in the pond.
 
 Two events may happen :
 
 @b 1. When a bubble is slided, it moves in the pond.
 @b 2. When a link is slided against, it will disappear.
 */
- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer;


/**
 Currently not supported.
 */
- (IBAction)handleSwipe:(UISwipeGestureRecognizer*) recognizer;

/**
 Handles events when the pond is tapped.
 
 Two events may happen when the pond is tapped:
 
 @b 1. When an empty space is tapped, pull out the menu for new bubbles.
 @b 2. When an space with a bubble is tapped, then that bubble get switched on
 if it's status was off, and off if its status was on.
 */
- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer;

/**
 Currently not supported.
 */
- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)recognizer;

/**
 This function loads the files for the bubble track view that has been selected. It lets us
 save space when we show the table. It also makes the views visible and playable.
 */
- (BubbleTrackView*) loadTrackFiles:(NSString*) name;

/**
 This function loads the files for the bubble effect view that has been selected. It lets us
 save space when we show the table. It also makes the views visible and playable.
 
 @param name
 */
- (BOOL) loadFXFiles:(NSString*) name;

/**
 Creates a link between an effect and a track view.
 
 Following conditions on the two input parameters must be met :
 
 @b 1. Exactly one of the parameters must be a TrackView.
 @b 2. Exactly one of the parameters must be a FXView.
 */
- (void) createLinkWithFirstView:(BubbleView*) afirstView andSecondView:(BubbleView*) asecondView;

/**
 Checks if link for view already exists.
 */
- (BOOL) linkAlreadyExistsforFirstView:(BubbleView*) aFirstView secondView:(BubbleView*) aSecondView;

/**
 Checks if a bubble has exited the pond.
 */
- (BOOL) didExitPond:(BubbleView*)view;


@end
