//
//  ViewController.m
//  BubbleTracks
//
//  Created by Jules Testard on 29/08/2014.
//  Copyright (c) 2014 julestestard. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "AEBlockChannel.h"
#import "MenuViewController.h"
#import "TrackWrapper.h"
#import "FXWrapper.h"
#import "BubbleView.h"
#import "BubbleFXView.h"
#import "AudioUnitWrapper.h"
#import "LinkView.h"
#import "FileParser.h"
#import "Line.h"
#import "ScaleFunctions.h"
#import "AudioMixer.h"
#import <vector>

@interface ViewController () {
    CGPoint min;
    CGPoint max;
    MenuViewController* _controller;
    NSMutableArray * linksArray;
    int color;
}
@end

@implementation ViewController

@synthesize bubblesArray, lastTouched, audioMixer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set up the view elements
    self.view.backgroundColor = [UIColor blackColor];
    min = CGPointMake(self.view.center.x - self.view.bounds.size.width/2, self.view.center.y - self.view.bounds.size.height/2);
    max = CGPointMake(self.view.center.x + self.view.bounds.size.width/2, self.view.center.y + self.view.bounds.size.height/2);
    
    // Setup gesture recognizers
    UITapGestureRecognizer * twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handle2FingerTap:)];
    UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UILongPressGestureRecognizer * longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    twoFingerTapRecognizer.delegate = self;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    tapRecognizer.delegate = self;
    tapRecognizer.numberOfTouchesRequired = 1;
    panRecognizer.delegate = self;
    longPressRecognizer.delegate = self;
    
    [self.view addGestureRecognizer:panRecognizer];
    [self.view addGestureRecognizer:longPressRecognizer];
    [self.view addGestureRecognizer:tapRecognizer];
    [self.view addGestureRecognizer:twoFingerTapRecognizer];
    
    //Initialize audio mixer
    self.audioMixer = [[AudioMixer alloc] init];
    
    //Initialize table view controller. It is hidden at first.
    _controller = [[MenuViewController alloc] initWithStyle:UITableViewStylePlain];
    _controller.mainViewController = self;
    
    // Generate wrappers for menu view.
    FileParser* fileparser = [[FileParser alloc] init];
    NSMutableArray* trackUnitArray = [fileparser generateTrackWrappers];
    NSMutableArray* fXUnitArray = [fileparser generatefXWrappers];
    NSMutableArray * audioUnitArray = [[NSMutableArray alloc] initWithCapacity:[trackUnitArray count] + [fXUnitArray count]];
    [audioUnitArray addObjectsFromArray:trackUnitArray];
    [audioUnitArray addObjectsFromArray:fXUnitArray];
    _controller.audioUnitArray = audioUnitArray;
    _controller.selected = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handle2FingerTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Two tap gesture initiated...");
    CGPoint firstTouch = [recognizer locationOfTouch:0 inView:self.view];
    CGPoint secondTouch = [recognizer locationOfTouch:1 inView:self.view];
    NSLog(@"Tap 0 : (%f,%f)", firstTouch.x, firstTouch.y);
    NSLog(@"Tap 1 : (%f,%f)", secondTouch.x, secondTouch.y);
    BubbleView * firstView = nil;
    BubbleView * secondView = nil;
    //Find if first touch location meets a bubble
    for (int i = 0 ; i < [self.view.subviews count]; i++) {
        BubbleView * subview = (BubbleView*)[self.view.subviews objectAtIndex:i];
        if ([subview pointInside:firstTouch withEvent:nil]) {
            firstView = subview;
            break;
        }
    }
    //If first touch met a bubble ...
    if (firstView!=nil) {
        //... find if second touch meets a bubble
        for (int i = 0 ; i < [self.view.subviews count] ; i++) {
            BubbleView * subview = (BubbleView*)[self.view.subviews objectAtIndex:i];
            if ([subview pointInside:secondTouch withEvent:nil]) {
                secondView = subview;
                break;
            }
        }
        //If both touches met bubbles ...
        if (secondView!=nil) {
            //... attempt to create a link between them
            [self createLinkWithFirstView:firstView andSecondView:secondView];
            NSLog(@"Link created!");
        }
        
    }
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    NSLog(@"Pan gesture initiated...");
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint touch = [recognizer locationInView:self.view];
    for (int i = self.view.subviews.count-1 ; i >= 0 ; i--) {
        UIView* aView = (UIView*)[self.view.subviews objectAtIndex:i];
        if ([aView isKindOfClass:[BubbleView class]]) {
            BubbleView* view = (BubbleView*) aView;
            if ([view pointInside:touch withEvent:nil]) {
                CGFloat xOff=view.center.x + translation.x, yOff=view.center.y + translation.y;
                view.center = CGPointMake(xOff,yOff);
                // If the view is an effect
                if (view.type==1) {
                    BubbleFXView* fxView = (BubbleFXView*) view;
                    [audioMixer modifyEffect:fxView.audioEffectName X:translation.x Y:translation.y];
                }
                [view updateFrameAndBounds:view.center];
                //Handles sliding of bubbles and acceleration
                if (recognizer.state == UIGestureRecognizerStateEnded) {
                    CGPoint velocity = [recognizer velocityInView:self.view];
                    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
                    CGFloat slideMult = magnitude / 200;
                    
                    float slideFactor = 0.1 * slideMult; // Increase for more of a slide
                    CGPoint finalPoint = CGPointMake(view.center.x + (velocity.x * slideFactor),
                                                     view.center.y + (velocity.y * slideFactor));
                    finalPoint.x = MIN(MAX(finalPoint.x, view.bounds.size.width/2), self.view.bounds.size.width-view.bounds.size.width/2);
                    finalPoint.y = MIN(MAX(finalPoint.y, view.bounds.size.height/2), self.view.bounds.size.height-view.bounds.size.height/2);
                    
                    [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        view.center = finalPoint;
                        [view updateFrameAndBounds:view.center];
                    } completion:nil];
                }
                if ([self didExitPond:view]) {
                    // If view is a track
                    if (view.type==TRACK) {
                        BubbleTrackView* trackView = (BubbleTrackView*) view;
                        [trackView removeAllLinks];
                        [self.audioMixer removeTrack:trackView.audioTrackName];
                        NSLog(@"Track bubble with no id has been removed...");
                        NSLog(@"Track bubble with name %@ has been removed...", trackView.audioTrackName);
                        // If view is an effect
                    } else if (view.type==FX){
                        BubbleFXView* fxView = (BubbleFXView*) view;
                        [fxView removeAllLinks];
                        [self.audioMixer removeEffect:fxView.audioEffectName];
                        NSLog(@"Effect bubble with name %@ has been removed...", fxView.audioEffectName);
                    }
                    
                    [view removeFromSuperview];
                }
                break;
            }
        }
        else if([aView isMemberOfClass:[LinkView class]]) {
            LinkView* linkView = (LinkView*) aView;
            //Get line function for the link view frame
            Line* linkViewLine = [[Line alloc]
                                  initWithX0:linkView.frame.origin.x
                                  Y0:linkView.frame.origin.y
                                  X1:linkView.frame.origin.x+linkView.frame.size.width
                                  Y1:linkView.frame.origin.y+linkView.frame.size.height];
            Line* panLine = [[Line alloc]
                             initWithX0:touch.x
                             Y0:touch.y
                             X1:touch.x+translation.x
                             Y1:touch.y+translation.y];
            if ([linkViewLine intersects:panLine]) {
                NSLog(@"Attempting to remove link");
                [linkView removeLink];
                NSLog(@"%@",[[linkView.firstView linkArray] description]);
                NSLog(@"%@",[[linkView.secondView linkArray] description]);
                [audioMixer unlinkTrack:linkView.firstView.audioTrackName
                               toEffect:linkView.secondView.audioEffectName];
                [linkView removeFromSuperview];
                break;
            }
        }
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer*) recognizer {
    NSLog(@"Swipe gesture initiated...");
}

- (IBAction)handleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Single tap gesture initiated...");
    CGPoint tap = [recognizer locationInView:self.view];
    NSArray* array = self.view.subviews;
    BOOL tapOnEmptySpace = true;
    for (int i = 0 ; i < [array count]; i++) {
        BubbleView* subView = (BubbleView*) [array objectAtIndex:i];
        if ([subView pointInside:tap withEvent:nil]) {
            tapOnEmptySpace = false;
            if (!subView.highlighted) {
                subView.highlighted = true;
                if (subView.type==TRACK) {
                    BubbleTrackView* trackView = (BubbleTrackView*) subView;
                    [audioMixer unmuteTrack:trackView.audioTrackName];
                }
                if (subView.type==FX) {
                    BubbleFXView* fxView = (BubbleFXView*) subView;
                    [audioMixer enableEffect:fxView.audioEffectName];
                }
                
            } else {
                subView.highlighted = false;
                if (subView.type==TRACK) {
                    BubbleTrackView* trackView = (BubbleTrackView*) subView;
                    [audioMixer muteTrack:trackView.audioTrackName];
                }
                if (subView.type==FX) {
                    BubbleFXView* fxView = (BubbleFXView*) subView;
                    [audioMixer disableEffect:fxView.audioEffectName];
                }
            }
        }
    }
    if (tapOnEmptySpace) {
        if (!_controller.selected) {
            _controller.selected = true;
            [self.navigationController pushViewController:_controller animated:YES];
            [_controller setUpMenuView:tap];
            lastTouched = tap;
        }
        
    }
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    NSLog(@"Long press gesture initiated...");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BubbleTrackView*) loadTrackFiles:(NSString*) name {
    NSString* colorString = nil;
    switch (color) {
        case 0:
            colorString=@"blue";
            break;
        case 1:
            colorString=@"orange";
            break;
        case 2:
            colorString=@"green";
            break;
        case 3:
            colorString=@"purple";
            break;
        default:
            break;
    }
    NSString* circle = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",@"paused_",colorString] ofType:@"png"];
    NSString* circle_lit = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",@"playing_",colorString] ofType:@"png"];
    UIImage* img = [[UIImage alloc] initWithContentsOfFile:circle];
    UIImage* img_highlight = [[UIImage alloc] initWithContentsOfFile:circle_lit];
    BubbleTrackView* bubbleTrackView = [[BubbleTrackView alloc] initWithName:name Image:img HighlightedImage:img_highlight Location:lastTouched];
    bubbleTrackView.color = colorString;
    [bubblesArray addObject:bubbleTrackView];
    [self.view addSubview:bubbleTrackView];
    //XXX Adds the track to the AudioMixer
    [audioMixer addTrack:bubbleTrackView.audioTrackName];
    //Change color regularily
    color = (color + 1)%4;
    return bubbleTrackView;
}

- (BOOL) loadFXFiles:(NSString*) name {
    NSString* colorString = nil;
    switch (color) {
        case 0:
            colorString=@"orange";
            break;
        case 1:
            colorString=@"green";
            break;
        case 2:
            colorString=@"blue";
            break;
        case 3:
            colorString=@"purple";
            break;
        default:
            break;
    }
    NSString* circle = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",@"fx_",colorString] ofType:@"png"];
    NSString* circle_lit = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",@"fxlit_",colorString] ofType:@"png"];
    UIImage* img = [[UIImage alloc] initWithContentsOfFile:circle];
    UIImage* img_highlight = [[UIImage alloc] initWithContentsOfFile:circle_lit];
    BubbleFXView * bubbleFXView = [[BubbleFXView alloc] initWithName:name Image:img HighlightedImage:img_highlight Location:lastTouched];
    [bubblesArray addObject:bubbleFXView];
    [self.view addSubview:bubbleFXView];
    //XXX Adds the effect to the AudioMixer
    [audioMixer addEffect:bubbleFXView.audioEffectName];
    color = (color+1)%4;
    return YES;
}

- (void) createLinkWithFirstView:(BubbleView*) afirstView andSecondView:(BubbleView*) asecondView {
    if (afirstView.type==0) {
        if (asecondView.type==1) {
            if (![self linkAlreadyExistsforFirstView:afirstView secondView:asecondView]) {
                // Setup link
                LinkView * link = [[LinkView alloc] initWithColor:UIColor.blueColor firstView:afirstView secondView:asecondView andFrame:CGRectMake(afirstView.frame.origin.x+afirstView.frame.size.width/2, afirstView.frame.origin.y+afirstView.frame.size.height/2, asecondView.frame.origin.x-afirstView.frame.origin.x, asecondView.frame.origin.y-afirstView.frame.origin.y)];
                [afirstView.linkArray addObject:link];
                [asecondView.linkArray addObject:link];
                [self.view insertSubview:link belowSubview:afirstView];
                [self.view sendSubviewToBack:link];
                BubbleTrackView* trackView = (BubbleTrackView*)afirstView;
                BubbleFXView* fxView = (BubbleFXView*) asecondView;
                [self.audioMixer linkTrack:trackView.audioTrackName toEffect:fxView.audioEffectName];
                NSLog(@"Link setup");
            }
        }
    } else if (afirstView.type==1) {
        if (asecondView.type==0) {
            if (![self linkAlreadyExistsforFirstView:afirstView secondView:asecondView]) {
                // Setup link
                LinkView * link = [[LinkView alloc] initWithColor:UIColor.blueColor firstView:asecondView secondView:afirstView andFrame:CGRectMake(afirstView.frame.origin.x+afirstView.frame.size.width/2, afirstView.frame.origin.y+afirstView.frame.size.height/2, asecondView.frame.origin.x-afirstView.frame.origin.x, asecondView.frame.origin.y-afirstView.frame.origin.y)];
                [afirstView.linkArray addObject:link];
                [asecondView.linkArray addObject:link];
                [self.view insertSubview:link belowSubview:afirstView];
                [self.view sendSubviewToBack:link];
                BubbleTrackView* trackView = (BubbleTrackView*)asecondView;
                BubbleFXView* fxView = (BubbleFXView*) afirstView;
                [self.audioMixer linkTrack:trackView.audioTrackName toEffect:fxView.audioEffectName];
                NSLog(@"Link setup");
            }
        }
    } else {
        NSLog(@"Data in ViewController.view.subviews is corrupted.");
    }
}


- (BOOL) linkAlreadyExistsforFirstView:(BubbleView*) aFirstView secondView:(BubbleView*) aSecondView {
    for (int i = 0 ; i < aFirstView.linkArray.count ; i++) {
        LinkView* link = (LinkView*) [aFirstView.linkArray objectAtIndex:i];
        if (link.firstView==aSecondView || link.secondView==aSecondView ) {
            return YES;
        }
    }
    return NO;
}


- (BOOL) didExitPond:(BubbleView *)view {
    return view.center.x < self.view.frame.origin.x ||
    view.center.x > self.view.frame.origin.x + self.view.frame.size.width ||
    view.center.y < self.view.frame.origin.y ||
    view.center.y > self.view.frame.origin.y + self.view.frame.size.height;
}


@end
