//
//  Line.m
//  BubbleTracks
//
//  Created by jules testard on 01/04/12.
//  Copyright (c) 2012 Jules Testard. All rights reserved.
//

#import "Line.h"
#ifndef max
#define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

#ifndef min
#define min( a, b ) ( ((a) < (b)) ? (a) : (b) )
#endif

@implementation Line

@synthesize minX,maxX,minY,maxY,a,b,vertical;

-(id) initWithX0:(int)x0 Y0:(int)y0 X1:(int)x1 Y1:(int)y1 {
    self = [[Line alloc] init];
    self.minX = min(x0,x1);
    self.maxX = max(x0,x1);
    self.minY = min(y0,y1);
    self.maxY = max(y0,y1);
    if (x1-x0!=0) {
        self.a = ((double)(y1-y0))/((double)(x1-x0));        
        self.b = y0 - a*x0;
        self.vertical = false;
    } else {
        self.a = DBL_MAX; // if we see these value appear, then something is wrong
        self.b = INT_MAX; 
        self.vertical = true;
    }
    return self;
}

-(BOOL) intersects:(Line*) line {
    double tol = 0.001;
    if (-tol < self.a-line.a && self.a-line.a < tol) {
        return NO;
    } else {
        //X-Y intersection coordinates.
        int x=0,y=0;
        if (!self.vertical) {
            if (!line.vertical) {
                x = -(self.b-line.b)/(self.a-line.a);
                y = self.a * x + self.b;
            } else {
                x = line.minX;
                y = self.a * x + self.b;
            }
        } else {
            if (!line.vertical) {
                x = self.minX; //could be maxX
                y = line.a * x + line.b;                
            } else {
                if (self.minX == line.minX) {
                    return YES;
                } else {
                    return NO;
                }
            }
        }
        int greatestMinX = max(self.minX,line.minX);
        int smallestMaxX = min(self.maxX,line.maxX);
        int greatestMinY = max(self.minY,line.minY);
        int smallestMaxY = min(self.maxY,line.maxY);
        int tol=10;
        if (greatestMinX-tol <= x && x <= smallestMaxX+tol) {
            if (greatestMinY-tol <= y && y <= smallestMaxY+tol) {
                return YES;
            }
        }
        return NO;
    }
}

@end
