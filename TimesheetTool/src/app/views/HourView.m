//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HourView.h"


@implementation HourView {
}


@synthesize borderColor;
@synthesize padding;


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {

        self.layer.borderColor = CGColorCreateGenericRGB(0.9, 0.9, 0.9, 1.0);
        self.layer.borderWidth = 2.0;

        self.padding = 0.5;

        self.borderColor = [NSColor lightGrayColor];
    }

    return self;
}


- (void) drawRect: (NSRect) rect {

        [self drawBorder: rect];
}


- (void) drawBorder: (NSRect) rect {
    //  NSRect rect = [self bounds];
    NSRect frameRect = [self bounds];

    if (rect.size.height < frameRect.size.height)
        return;
    NSRect newRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width - (padding), rect.size.height - (padding));

    NSBezierPath *textViewSurround = [NSBezierPath bezierPathWithRect: newRect];
    [textViewSurround setLineWidth: 1.0];
    [self.borderColor set];
    [textViewSurround stroke];
}

@end