
/*
 */
#include "BubbleTrackView.h"

@interface AudioUnitWrapper : NSObject {
	NSString *name;
	NSString *instrument;
    NSString *bubble;
    NSUInteger type;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *instrument;
@property (nonatomic, copy) NSString *bubble;
@property NSUInteger type;

- (id)initWithInstrument:(NSString *)aTrackType Name:(NSString*) aTrackName Type:(NSUInteger) aType;

@end
