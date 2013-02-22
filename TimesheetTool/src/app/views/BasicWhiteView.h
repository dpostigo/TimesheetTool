//
// Created by dpostigo on 2/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicView.h"


@interface BasicWhiteView : NSView {

    NSView *shadowLayer;
    BasicView *backgroundLayer;

    IBOutlet NSView *contentView;


    CGFloat cornerRadius;
    CGFloat shadowRadius;
    CGFloat padding;
    NSColor *fillColor;
    NSColor *borderColor;
    NSColor *shadowColor;


}


@property(nonatomic, retain) NSView *shadowLayer;
@property(nonatomic, retain) BasicView *backgroundLayer;
@property(nonatomic, retain) NSView *contentView;
@property(nonatomic) CGFloat cornerRadius;
@property(nonatomic) CGFloat shadowRadius;
@property(nonatomic, strong) NSColor *fillColor;
@property(nonatomic, strong) NSColor *borderColor;
@property(nonatomic, strong) NSColor *shadowColor;
@property(nonatomic) CGFloat padding;
@property(nonatomic) BOOL isDoubleView;

@end