//
//  BubbleFXView.h
//  BubbleTrack_6
//
//  Created by jules testard on 27/02/12.
//  Copyright (c) 2012 Jules Testard.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubbleView.h"

@interface BubbleFXView : BubbleView {
}

@property (strong,nonatomic) NSString  *audioEffectName;
- (id)initWithName:(NSString*)aName Image:(UIImage*)image HighlightedImage:(UIImage*)highlightedImage Location:(CGPoint)location;

@end
