//
// Created by dpostigo on 2/19/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface NSColor (Utils)


+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
+ (NSColor *) colorWithString: (NSString *) hexString;

@end