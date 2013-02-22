//
// Created by dpostigo on 2/21/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicWhiteView.h"
#import "TimeEntry.h"



@interface TimeEntryCell : NSTableCellView {

    __unsafe_unretained TimeEntry *timeEntry;

    IBOutlet NSTextField *timeStartedLabel;
    IBOutlet NSTextField *timeEndedLabel;
    IBOutlet BasicWhiteView *backgroundView;
    IBOutlet NSBox *divider;
    IBOutlet NSButton *button;
}


@property(nonatomic, strong) BasicWhiteView *backgroundView;
@property(nonatomic, strong) NSBox *divider;
@property(nonatomic, strong) NSButton *button;
@property(nonatomic, strong) NSTextField *timeStartedLabel;
@property(nonatomic, strong) NSTextField *timeEndedLabel;
@property(nonatomic, assign) TimeEntry *timeEntry;

@end