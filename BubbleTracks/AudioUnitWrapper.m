/*
 */

#import "AudioUnitWrapper.h"


@implementation AudioUnitWrapper

@synthesize name, instrument, bubble, type;

- (id)initWithInstrument:(NSString *)aTrackType Name:(NSString*) aTrackName Type:(NSUInteger) aType {
	
	if (self = [super init]) {		
		self.instrument = aTrackType;
		self.name = aTrackName;
        if (aType <= 2 ) {
            self.type = aType;
        } else {
            NSLog(@"Wrong type value! for AudioUnitWrapper init.");
            self.type = -1;
        }
	}
	return self;
}


- (void)dealloc {
}


@end
