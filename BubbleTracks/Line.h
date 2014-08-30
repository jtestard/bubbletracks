//
//  Line.h
//  BubbleTracks
//
//  Created by jules testard on 01/04/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Line : NSObject {
    int minX,maxX,minY,maxY;
    double a;
    int b;
}

@property int minX;
@property int maxX;
@property int minY;
@property int maxY;
@property bool vertical;
@property double a;
@property int b;

-(id) initWithX0:(int)x0 Y0:(int)y0 X1:(int)x1 Y1:(int)y1;
-(BOOL) intersects:(Line*) line;
@end
