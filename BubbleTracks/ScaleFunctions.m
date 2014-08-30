//
//  ScaleFunctions.m
//  BubbleTracks
//
//  Created by jules testard on 06/09/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import "ScaleFunctions.h"
#import "math.h"
#define PINCH_SIGMA 0.2146 // equals to 1 - atan(1)
#define PINCH_SCALE_FACTOR 32.0

@implementation ScaleFunctions

+ (CGFloat) pinchScale : (CGFloat) scale {
    CGFloat tmp = (atan(scale) + PINCH_SIGMA - 1.0) / PINCH_SCALE_FACTOR;
    return 1.0 + tmp;
}

@end
