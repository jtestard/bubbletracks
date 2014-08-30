//
//  LinkView.h
//  BubbleTracks
//
//  Created by jules testard on 28/02/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleView.h"
#import "BubbleTrackView.h"
#import "BubbleFXView.h"

@interface LinkView : UIView {
    BubbleTrackView * firstView; //Always a track view.
    BubbleFXView * secondView; //Always an effect view.
}


@property (strong,nonatomic) BubbleTrackView * firstView;
@property (strong,nonatomic) BubbleFXView * secondView;
- (void) drawRect:(CGRect)rect;
- (id) initWithColor:(UIColor*) color firstView:(BubbleView*) afirstView secondView:(BubbleView*) asecondView andFrame:(CGRect) rect;
- (void) updateFrame;
- (void) removeLink;
@end
