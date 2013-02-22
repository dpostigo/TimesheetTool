//
// Created by dpostigo on 2/21/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TimeEntryCell.h"


@implementation TimeEntryCell {
}


@synthesize backgroundView;
@synthesize divider;
@synthesize button;
@synthesize timeStartedLabel;
@synthesize timeEndedLabel;
@synthesize timeEntry;


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {

       backgroundView.wantsLayer = NO;
    }

    return self;
}

@end