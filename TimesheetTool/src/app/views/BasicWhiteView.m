//
// Created by dpostigo on 2/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicWhiteView.h"
#import "NSColor+Utils.h"
#import "NSBezierPath+Utils.h"
#import "NSShadow+Utils.h"


#define SHADOW_START_OPACITY 0.43
#define SHADOW_HEIGHT 6.0


@implementation BasicWhiteView {
    BOOL isDoubleView;
}


@synthesize shadowLayer;
@synthesize backgroundLayer;
@synthesize contentView;
@synthesize cornerRadius;
@synthesize shadowRadius;
@synthesize fillColor;
@synthesize borderColor;
@synthesize shadowColor;
@synthesize padding;
@synthesize isDoubleView;


- (id) initWithFrame: (NSRect) frameRect {
    self = [super initWithFrame: frameRect];
    if (self) {
        //[self create];

        self.borderColor = [NSColor whiteColor];
        self.fillColor = [NSColor colorWithString: @"f4f4f4"];
        self.shadowColor = [NSColor lightGrayColor];
        self.shadowRadius = 2;
        self.cornerRadius = 2.0;
        self.padding = 5.0;
    }

    return self;
}


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
    }

    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];
    //[self create];
}


- (void) create {

    self.wantsLayer = YES;
    self.layer.shadowColor = CGColorCreateGenericRGB(0, 0, 0, 1);
    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1.0;
    self.layer.masksToBounds = NO;

    NSLog(@"%s", __PRETTY_FUNCTION__);

    CGFloat padding = 1;
    NSRect shadowFrame = NSMakeRect(0, 0, self.width - padding, self.height - padding);
    NSRect backgroundFrame = NSMakeRect(0, padding, self.width - padding, self.height - (padding * 2));

    self.backgroundLayer = [[BasicView alloc] initWithFrame: backgroundFrame];
    [backgroundLayer setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
    //    backgroundLayer.wantsLayer = YES;
    backgroundLayer.backgroundColor = [NSColor colorWithString: @"f4f4f4"];

    [self addSubview: backgroundLayer];

    //    backgroundLayer.wantsLayer = YES;
    backgroundLayer.layer.borderColor = CGColorCreateGenericRGB(1, 1, 1, 1);
    backgroundLayer.layer.borderWidth = 1.0;
    backgroundLayer.layer.cornerRadius = 5.0;

    contentView.wantsLayer = YES;
}


- (void) drawRect: (NSRect) dirtyRect {
    [super drawRect: dirtyRect];

    NSRect modifiedRect = NSMakeRect(2, 2, dirtyRect.size.width - padding, dirtyRect.size.height - padding);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: modifiedRect xRadius: cornerRadius yRadius: cornerRadius];

    [self drawShadow: path];

    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];
    [context setCompositingOperation: NSCompositeSourceOver];

    [fillColor setFill];

    NSRectFill(modifiedRect);

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = self.shadowColor;
    shadow.shadowBlurRadius = self.shadowRadius;
    //    shadow.shadowOffset = NSMakeSize(0, 2);



    [path setLineWidth: 1.0];
    [shadow set];
    [path fill];


    [self.borderColor setStroke];
    [path stroke];

    [self drawGradientInRect: modifiedRect];

    [context restoreGraphicsState];
}


- (void) drawShadow: (NSBezierPath *) bezierPath {


    //    [NSShadow setShadowWithOffset: NSMakeSize(0, -3) blurRadius: 3 color: [NSColor colorWithCalibratedWhite: 0 alpha: 0.65]];
    [NSShadow setShadowWithOffset: NSMakeSize(0, -3) blurRadius: 3 color: self.shadowColor];
    [[NSColor colorWithCalibratedWhite: 0.9 alpha: 1.0] set];
    [bezierPath fill];
    [NSShadow clearShadow];
}


- (void) drawGradientInRect: (NSRect) drawingRect {
    //
    //    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithCalibratedWhite: 1 alpha: 0.85], 0.0,
    //                                                                           [NSColor colorWithCalibratedWhite: 1 alpha: 0.5], 0.5,
    //                                                                           [NSColor colorWithCalibratedWhite: 1 alpha: 0.05], 1.0,
    //                                                                           nil];


    CGFloat offset = 0.05;
    NSColor *color1 = [NSColor colorWithDeviceRed: fillColor.redComponent - offset green: fillColor.greenComponent - offset blue: fillColor.blueComponent - offset alpha: 1.0];
    NSColor *color2 = self.fillColor;
    NSColor *color3 = self.fillColor;
    NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations: color1, 0.0,
                                                                           color2, 0.5,
                                                                           color3, 1.0,
                                                                           nil];

    //    [[NSColor clearColor] setFill];
    //    [gradient drawInRect: drawingRect angle: 90];
    //    NSRectFill(NSMakeRect(NSMinX(drawingRect), NSMinY(drawingRect), NSWidth(drawingRect), 1));

    if (isDoubleView) {

        [[NSColor clearColor] setFill];
        NSRectFill(NSMakeRect(NSMinX(drawingRect), NSMinY(drawingRect), NSWidth(drawingRect), 1));



    } else {
        [gradient drawInRect: drawingRect angle: 90];
    }
}


- (void) drawGradient2: (NSRect) drawingRect {

    NSRect modifiedRect = NSMakeRect(2, 2, drawingRect.size.width - padding, drawingRect.size.height - padding);
    NSBezierPath *aPath = [NSBezierPath bezierPathWithRoundedRect: modifiedRect xRadius: cornerRadius yRadius: cornerRadius];
    CGPathRef clippingPath = [aPath quartzPath];
    CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextAddPath(ctx, clippingPath);
    CGContextClip(ctx);

    CGFloat offset = 0.05;
    NSColor *chromeStartingColor = [NSColor colorWithDeviceRed: fillColor.redComponent - offset green: fillColor.greenComponent - offset blue: fillColor.blueComponent - offset alpha: 1.0];
    NSColor *chromeEndingColor = self.fillColor;


    //        NSColor *chromeStartingColor = [NSColor colorWithCalibratedRed: 52/255.0 green: 119/255.0 blue: 194/255.0 alpha: 1];
    //        NSColor *chromeEndingColor = [NSColor colorWithCalibratedRed: 115/255.0 green: 184/255.0 blue: 243/255.0 alpha: 1];


    NSGradient *glossGradient = [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithCalibratedWhite: 1 alpha: 0.85], 0.0,
                                                                                [NSColor colorWithCalibratedWhite: 1 alpha: 0.5], 0.5,
                                                                                [NSColor colorWithCalibratedWhite: 1 alpha: 0.05], 1.0,
                                                                                nil];
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor: chromeStartingColor endingColor: chromeEndingColor];

    gradient = glossGradient;
    [[NSColor darkGrayColor] setFill];

    [gradient drawInRect: drawingRect angle: 90];
    NSRectFill(NSMakeRect(NSMinX(drawingRect), NSMinY(drawingRect), NSWidth(drawingRect), 1));
}


- (void) drawGlossPath: (NSRect) ellip {

    //    const CGFloat glossInset = 8;
    //    CGFloat glossRadius = (ellipseCenterRect.size.width * 0.5) - glossInset;
    //    NSPoint center = NSMakePoint(NSMidX(ellipseRect), NSMidY(ellipseRect));
    //    double arcFraction = 0.02;
    //    NSPoint arcStartPoint = NSMakePoint( center.x - glossRadius * cos(arcFraction * M_PI),  center.y + glossRadius * sin(arcFraction * M_PI));
    //    NSPoint arcEndPoint = NSMakePoint( center.x + glossRadius * cos(arcFraction * M_PI), center.y + glossRadius * sin(arcFraction * M_PI));
    //    NSBezierPath *glossPath = [[[NSBezierPath alloc] init] autorelease];
    //    [glossPath moveToPoint: arcStartPoint];
    //    [glossPath
    //            appendBezierPathWithArcWithCenter: center
    //                                       radius: glossRadius
    //                                   startAngle: arcFraction * 180
    //                                     endAngle: (1.0 - arcFraction) * 180];
    //
    //    const CGFloat bottomArcBulgeDistance = 70;
    //    const CGFloat bottomArcRadius = 2.6;
    //    [glossPath moveToPoint: arcEndPoint];
    //    [glossPath
    //            appendBezierPathWithArcFromPoint:
    //                    NSMakePoint(center.x, center.y - bottomArcBulgeDistance)
    //                                     toPoint: arcStartPoint
    //                                      radius: glossRadius * bottomArcRadius];
    //    [glossPath lineToPoint: arcStartPoint];
}

@end