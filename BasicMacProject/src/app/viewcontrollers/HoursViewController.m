//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HoursViewController.h"
#import "TimeLogViewController.h"
#import "Person.h"
#import "iTableColumnHeaderCell.h"
#import "AgendaHeaderCell.h"
#import "AgendaViewController.h"
#import "AgendaCellView.h"
#import "TreeDatum.h"
#import "TimeEntry.h"
#import "TimeEntryCell.h"
#import "SidebarTableCellView.h"
#import "SaveDataOperation.h"


#define NUM_TIME_ENTRIES 5


@implementation HoursViewController {
}


@synthesize dataSource;


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.title = @"Hours";
    }

    return self;
}


- (void) loadView {
    [super loadView];

    TimeLogViewController *controller = [[TimeLogViewController alloc] initWithNibName: @"TimeLogView" bundle: nil];
    controller.view.frame = timelogView.bounds;
    [controller.view setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
    [timelogView addSubview: controller.view];

    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = [NSColor clearColor];
    table.enclosingScrollView.drawsBackground = NO;

    for (NSTableColumn *column in table.tableColumns) {
        [column setHeaderCell: [[AgendaHeaderCell alloc] initTextCell: [[column headerCell] stringValue]]];
    }

    //    [treeController setContent: [self makeTimeEntriesTree]];
    //    [outline reloadData];
    //    dataSource = [self makeTimeEntriesTree];


    self.dataSource = [NSMutableArray arrayWithArray: [_model recentTimeEntries: NUM_TIME_ENTRIES]];
    [table reloadData];
}


#pragma mark Notify delegates

- (void) timeLogSwitchedMode {
}


- (void) timeEntriesChangedForProject: (Project *) project {

    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    //    dataSource = [NSMutableArray arrayWithArray: [_model recentTimeEntries: NUM_TIME_ENTRIES]];
    //    [table reloadData];
}


- (void) timeEntryAdded: (TimeEntry *) timeEntry toProject: (Project *) project {

    NSLog(@"%s", __PRETTY_FUNCTION__);

    dataSource = [NSMutableArray arrayWithArray: [_model recentTimeEntries: NUM_TIME_ENTRIES]];
    [table insertRowsAtIndexes: [NSIndexSet indexSetWithIndex: 0] withAnimation: NSTableViewAnimationSlideDown];
    [table removeRowsAtIndexes: [NSIndexSet indexSetWithIndex: [dataSource count]] withAnimation: NSTableViewAnimationEffectFade];
    [_queue addOperation: [[SaveDataOperation alloc] init]];
}


- (void) timeEntryCompleted: (TimeEntry *) timeEntry {

    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSInteger index = [dataSource indexOfObject: timeEntry];
    NSLog(@"index = %li", index);

    dataSource = [NSMutableArray arrayWithArray: [_model recentTimeEntries: NUM_TIME_ENTRIES]];

    [table reloadDataForRowIndexes: [NSIndexSet indexSetWithIndex: index] columnIndexes: [NSIndexSet indexSetWithIndex: 0]];

}



#pragma mark Data preparation


- (void) didSelectAddNewProject {
}


- (void) addTimeEntry: (id) sender {
}


- (void) deleteTimeEntry: (id) sender {

    TimeEntryCell *cell = (TimeEntryCell *) [[sender superview] superview];
    TimeEntry *timeEntry = cell.timeEntry;
    NSInteger index = [dataSource indexOfObject: timeEntry];
    Project *project = [_model projectFromId: timeEntry.projectId];

    [project.timeEntries removeObject: timeEntry];
    [dataSource removeObject: timeEntry];
    [table removeRowsAtIndexes: [NSIndexSet indexSetWithIndex: index] withAnimation: NSTableViewAnimationSlideDown];
    [_queue addOperation: [[SaveDataOperation alloc] init]];
}

#pragma mark NSTableViewDataSource


#pragma mark NSTableView Delegate


- (NSTableRowView *) tableView: (NSTableView *) tableView rowViewForRow: (NSInteger) row {

    NSTableRowView *rowView = [[NSTableRowView alloc] initWithFrame: NSMakeRect(0, 0, 100, 100)];
    [rowView setEmphasized: YES];
    rowView.backgroundColor = [NSColor yellowColor];
    return rowView;
}


- (NSView *) tableView: (NSTableView *) tableView viewForTableColumn: (NSTableColumn *) tableColumn row: (NSInteger) row {

    NSTableCellView *cellView = nil;
    TimeEntry *timeEntry = [dataSource objectAtIndex: row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    [formatter setDateFormat: @"MM/dd h:mm a"];

    if ([tableColumn.identifier isEqualToString: @"TimeStartedColumn"]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier: @"TimeCell" owner: self];
        cell.textField.stringValue = [formatter stringFromDate: timeEntry.timeStarted];
        cellView = cell;
    } else if ([tableColumn.identifier isEqualToString: @"TimeEndedColumn"]) {
        NSTableCellView *cell = [tableView makeViewWithIdentifier: @"TimeCell" owner: self];

        if (timeEntry.timeEnded == nil) {
            cell.textField.stringValue = @"";
        } else {
            cell.textField.stringValue = [formatter stringFromDate: timeEntry.timeEnded];
        }
        cellView = cell;
    } else if ([tableColumn.identifier isEqualToString: @"DeleteColumn"]) {
        SidebarTableCellView *cell = [tableView makeViewWithIdentifier: @"DeleteCell" owner: self];
        cell.button.stringValue = @"x";
        cell.textField.stringValue = @"Delete";
        cellView = cell;
    } else {

        NSLog(@"Creating DataCell");

        Project *project = [_model projectFromId: timeEntry.projectId];
        TimeEntryCell *cell = [tableView makeViewWithIdentifier: @"DataCell" owner: self];
        cell.timeStartedLabel.stringValue = [formatter stringFromDate: timeEntry.timeStarted];
        cell.timeEntry = timeEntry;
        cell.textField.stringValue = project.title;
        cell.divider.alphaValue = 0.5;
        cell.button.tag = row;
        cell.button.target = self;
        cell.button.action = @selector(deleteTimeEntry:);

        if (timeEntry.timeEnded != nil) {
            cell.timeEndedLabel.stringValue = [formatter stringFromDate: timeEntry.timeEnded];
        } else {
            cell.timeEndedLabel.stringValue = @"-";
        }

        cellView = cell;
    }

    return cellView;
}

//
//- (NSInteger) numberOfRowsInTableView: (NSTableView *) tableView {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    NSInteger count = [dataSource count];
//    return NUM_TIME_ENTRIES;
//}
//



- (NSTableRowView *) outlineView: (NSOutlineView *) outlineView rowViewForItem: (id) item {

    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSTableRowView *rowView = [[NSTableRowView alloc] initWithFrame: NSMakeRect(0, 0, 100, 100)];

    rowView.backgroundColor = [NSColor yellowColor];

    return rowView;
    return nil;
}


#pragma mark NSSplitView Delegate


- (CGFloat) splitView: (NSSplitView *) splitView1 constrainMinCoordinate: (CGFloat) proposedMinimumPosition ofSubviewAt: (NSInteger) dividerIndex {
    NSView *subview = [[splitView1 subviews] objectAtIndex: dividerIndex];

    if (subview == timelogView) {
        return timelogView.height;
    }

    return 0;
}

#pragma mark Deprecated


- (NSArray *) makeProjectTree {

    NSMutableArray *roots = [[NSMutableArray alloc] init];

    for (Project *project in _model.projects) {

        TreeDatum *datum = [TreeDatum treeDatumFromName: project.title value: @"Top Level"];
        NSTreeNode *datumNode = [NSTreeNode treeNodeWithRepresentedObject: datum];

        for (TimeEntry *timeEntry in project.timeEntries) {

            TreeDatum *subDatum = [TreeDatum treeDatumFromName: @"A Time Entry" value: nil];
            [datumNode.mutableChildNodes addObject: [NSTreeNode treeNodeWithRepresentedObject: subDatum]];
        }

        [roots addObject: datumNode];
    }

    return roots;
}


- (void) setTableColumnIdentifiers {
    for (NSTableColumn *tableColumn in table.tableColumns) {
        NSTableHeaderCell *headerCell = tableColumn.headerCell;
        tableColumn.identifier = headerCell.title;
    }
}


- (void) createTableColumns {

    NSArray *tableColumns = [NSArray arrayWithObjects: @"M",
                                                       @"Tu",
                                                       @"W",
                                                       @"Th",
                                                       @"F",
                                                       @"Sa",
                                                       @"Su",
                                                       nil];

    for (NSString *columnTitle in tableColumns) {

        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier: columnTitle];
        NSTableHeaderCell *headerCell = (NSTableHeaderCell *) column.headerCell;
        headerCell.title = columnTitle;

        NSTextFieldCell *textCell = [[NSTextFieldCell alloc] init];
        //        textCell.controlView = [[AgendaCellView alloc] init];

        column.dataCell = textCell;

        [table addTableColumn: column];
    }
}


- (NSArray *) makeTimeEntriesTree {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSArray *timeEntries = [_model recentTimeEntries: NUM_TIME_ENTRIES];
    NSMutableArray *roots = [[NSMutableArray alloc] init];

    for (TimeEntry *timeEntry in timeEntries) {
        NSTreeNode *datumNode = [NSTreeNode treeNodeWithRepresentedObject: timeEntry];

        [roots addObject: datumNode];
    }

    return roots;
}

@end