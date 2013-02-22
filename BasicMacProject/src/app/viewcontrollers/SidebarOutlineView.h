//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicView.h"
#import "BasicOutlineView.h"




@interface SidebarOutlineView : BasicOutlineView <NSOutlineViewDelegate, NSOutlineViewDataSource> {


    NSViewController *currentController;
    IBOutlet BasicView *mainContentView;



}


@property(nonatomic, strong) BasicView *mainContentView;

- (void) setContentViewToName: (NSString *) name;

@end