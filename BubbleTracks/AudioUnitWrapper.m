/*
 */

#import "AudioUnitWrapper.h"


@implementation AudioUnitWrapper

@synthesize name, instrument, bubble, type;

- (id)initWithInstrument:(NSString *)aTrackType Name:(NSString*) aTrackName Type:(NSUInteger) aType {
	
	if (self = [super init]) {		
		self.instrument = aTrackType;
		self.name = aTrackName;
        if (aType==0) {
            self.type = 0;
        } else if (aType==1) {
            self.type = 1;
        } else if (aType==2) {
            self.type = 2;
        }
        else {
            NSLog(@"Wrong type value! for AudioUnitWrapper init.");
            self.type = -1;
        }
	}
	return self;
}


- (void)dealloc {
}


@end
