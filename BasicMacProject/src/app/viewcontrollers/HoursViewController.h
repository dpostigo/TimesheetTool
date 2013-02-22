//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "BasicView.h"


@interface HoursViewController : BasicViewController <NSTableViewDelegate, NSTableViewDataSource, NSSplitViewDelegate, NSOutlineViewDelegate, NSOutlineViewDataSource> {


    IBOutlet NSSplitView *splitView;
    IBOutlet NSView *topView;
    IBOutlet NSView *bottomView;
    IBOutlet BasicView *timelogView;

    IBOutlet NSCollectionView *collection;


    IBOutlet NSTableView *table;
    IBOutlet NSScrollView *scrollView;


    IBOutlet NSView *agendaView;

    IBOutlet NSArrayController *sortedTimeEntries;
    IBOutlet NSTreeController *treeController;

    IBOutlet NSOutlineView *outline;

    IBOutlet NSMutableArray *dataSource;
}


@property(nonatomic, strong) NSMutableArray *dataSource;

@end