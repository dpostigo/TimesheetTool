//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AgendaCellView.h"
#import "BasicWhiteView.h"
#import "BasicInnerShadowView.h"


@implementation AgendaCellView {
    NSTrackingArea *trackingArea;
    BOOL isClicked;
}


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {


        //        BasicWhiteView *basicWhiteView = [[BasicWhiteView alloc] initWithFrame: self.bounds];
        //        basicWhiteView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        //        basicWhiteView.height = self.height - 3;
        //        basicWhiteView.alphaValue = 0.5;
        //        [self addSubview: basicWhiteView];


        BasicInnerShadowView *shadowView = [[BasicInnerShadowView alloc] initWithFrame: self.bounds];
        shadowView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
//        shadowView.height = self.height - 3;
        //        shadowView.wantsLayer = YES;
        //        shadowView.layer.cornerRadius = 5.0;
        //        shadowView.alphaValue = 0.5;
        [self addSubview: shadowView];

        backgroundView = [[BasicView alloc] initWithFrame: self.bounds];
        backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        backgroundView.backgroundColor = [NSColor whiteColor];
        backgroundView.height = self.height;
        backgroundView.alphaValue = 0;
        [self addSubview: backgroundView];


        //        backgroundView.wantsLayer = YES;
        //        backgroundView.layer.cornerRadius = 5.0;
        //        backgroundView.layer.borderColor = CGColorCreateGenericRGB(1, 1, 1, 0.2);
        //        backgroundView.layer.borderWidth = 1.0;

        //        self.textField.wantsLayer = YES;
        //        self.textField.layer.cornerRadius = 50;

//        self.textField.stringValue = @"";

        self.wantsLayer = YES;

        trackingArea = [[NSTrackingArea alloc] initWithRect: self.frame options: (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInKeyWindow) owner: self userInfo: nil];
        [self addTrackingArea: trackingArea];
    }

    return self;
}


- (void) mouseEntered: (NSEvent *) theEvent {
    [super mouseEntered: theEvent];

    if (!isClicked) {
        backgroundView.alphaValue = 0.3;
    }
}


- (void) mouseExited: (NSEvent *) theEvent {
    [super mouseExited: theEvent];
    if (!isClicked) {
        backgroundView.alphaValue = 0;
    }
}


- (void) mouseDown: (NSEvent *) theEvent {
    [super mouseDown: theEvent];

    if (isClicked) {
        isClicked = NO;
        backgroundView.alphaValue = 0;
    } else {

        isClicked = YES;
        backgroundView.alphaValue = 0.6;
    }
}

@end