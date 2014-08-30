//
//  BubbleView.h
//  BubbleTrack_6
//
//  Created by jules testard on 27/02/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import <UIKit/UIKit.h>

extern int const TRACK;
extern int const FX;

@interface BubbleView : UIImageView {
    NSMutableArray* linkArray;
    NSString* name;
}

@property (strong,nonatomic) NSMutableArray* linkArray;
@property (strong,nonatomic) NSString* name;
@property                    int size;
@property                    CGPoint center;
@property                    NSUInteger type;
@property (strong,nonatomic) UILabel* title;
@property (strong,nonatomic) NSString* color;

- (id) initWithName:(NSString *)aName Image:(UIImage *)image HighlightedImage:(UIImage *)highlightedImage Location:(CGPoint)location;
- (void) updateFrameAndBounds:(CGPoint) update;
- (BOOL) linkWith:(BubbleView*) view;
- (void) removeAllLinks;

@end
