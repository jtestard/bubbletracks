//
//  BubbleTrackView.h
//  BubblesTracks
//
//  Created by jules testard on 09/02/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
//#import "AudioEffect.h"
#import "BubbleView.h"

@interface BubbleTrackView : BubbleView {
}
//@property (strong,nonatomic) AudioTrack* audioTrack;

- (id)initWithName:(NSString*)aName Image:(UIImage*)image HighlightedImage:(UIImage*)highlightedImage Location:(CGPoint)location;
@end
