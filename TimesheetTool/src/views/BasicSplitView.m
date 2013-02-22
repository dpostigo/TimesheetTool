//
// Created by dpostigo on 2/20/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicSplitView.h"


@implementation BasicSplitView {
}


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {

    }

    return self;
}


- (CGFloat) dividerThickness {
    return 10;
}


- (NSColor *) dividerColor {
    return [NSColor clearColor];
}


- (void) mouseEntered: (NSEvent *) theEvent {

}



@end