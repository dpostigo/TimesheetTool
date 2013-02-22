//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SidebarOutlineView.h"
#import "SidebarTableCellView.h"
#import "Model.h"


#define SECOND_SECTION @"Employee Tools"
#define FIRST_SECTION @"Dailies"


@implementation SidebarOutlineView {
    Model *_model;
}


@synthesize mainContentView;


- (id) initWithCoder: (NSCoder *) aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {



        _model = [Model sharedModel];
        [_model subscribeDelegate: self];

        self.delegate = self;
        self.dataSource = self;

        topLevelItems = [NSArray arrayWithObjects: FIRST_SECTION, SECOND_SECTION, nil];

        childrenDictionary = [NSMutableDictionary new];
        [childrenDictionary setObject: [NSArray arrayWithObjects: @"Inbox", nil] forKey: FIRST_SECTION];
        [childrenDictionary setObject: [NSArray arrayWithObjects: @"Hours", @"Projects", nil] forKey: SECOND_SECTION];
        [childrenDictionary setObject: [NSArray arrayWithObjects: @"ContentView2", nil] forKey: @"Mailboxes"];
        [childrenDictionary setObject: [NSArray arrayWithObjects: @"ContentView1", @"ContentView1", @"ContentView1", @"ContentView1", @"ContentView2", nil] forKey: @"A Fourth Group"];

        [self sizeLastColumnToFit];
        [self reloadData];

        self.floatsGroupRows = NO;
        self.rowSizeStyle = NSTableViewRowSizeStyleDefault;

        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration: 0];
        [self expandItem: nil expandChildren: YES];
        [NSAnimationContext endGrouping];


        [self setContentViewToName: @"Inbox"];

    }

    return self;
}



- (void) setContentViewToName: (NSString *) name {

    NSString *selectedString = [self itemAtRow: self.selectedRow];

    if (![selectedString isEqualToString: name])  {
        [self selectItem: name];
        return;

    }

    if (currentController) {
        [[currentController view] removeFromSuperview];
    }

    NSString *nibName = [name stringByAppendingString: @"View"];

    currentController = [[NSClassFromString([nibName stringByAppendingString: @"Controller"]) alloc] initWithNibName: nibName bundle: nil]; // Retained


    NSView *view = currentController.view;
    view.frame = mainContentView.bounds;
    [view setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
    [mainContentView addSubview: view];



}



#pragma mark Model notifications


- (void) didSelectAddNewProject {
    [self setContentViewToName: @"Projects"];
}

#pragma mark NSOutlineViewDelegate

- (void) outlineViewSelectionDidChange: (NSNotification *) notification {
    if ([self selectedRow] != -1) {
        NSString *item = [self itemAtRow: [self selectedRow]];

        if ([self parentForItem: item] != nil) {
            // Only change things for non-root items (root items can be selected, but are ignored)
            [self setContentViewToName: item];
        }
    }
}



- (id) outlineView: (NSOutlineView *) outlineView child: (NSInteger) index ofItem: (id) item {
    return [[self childrenForItem: item] objectAtIndex: index];
}


- (BOOL) outlineView: (NSOutlineView *) outlineView isItemExpandable: (id) item {
    if ([outlineView parentForItem: item] == nil) {
        return YES;
    } else {
        return NO;
    }
}


- (NSInteger) outlineView: (NSOutlineView *) outlineView numberOfChildrenOfItem: (id) item {
    return [[self childrenForItem: item] count];
}


- (BOOL) outlineView: (NSOutlineView *) outlineView isGroupItem: (id) item {
    return [topLevelItems containsObject: item];
}


- (BOOL) outlineView: (NSOutlineView *) outlineView shouldShowOutlineCellForItem: (id) item {
    // As an example, hide the "outline disclosure button" for FAVORITES. This hides the "Show/Hide" button and disables the tracking area for that row.
    if ([item isEqualToString: @"Favorites"]) {
        return NO;
    } else {
        return YES;
    }
}


- (NSView *) outlineView: (NSOutlineView *) outlineView viewForTableColumn: (NSTableColumn *) tableColumn item: (id) item {


    // For the groups, we just return a regular text view.
    if ([topLevelItems containsObject: item]) {
//        NSTextField *result = [outlineView makeViewWithIdentifier: @"HeaderTextField" owner: self];
//        // Uppercase the string value, but don't set anything else. NSOutlineView automatically applies attributes as necessary
        NSString *value = [item uppercaseString];

        SidebarTableCellView *result = [outlineView makeViewWithIdentifier: @"HeaderTextField" owner: self];
        result.textField.stringValue = value;



        return result;


    } else {
        // The cell is setup in IB. The textField and imageView outlets are properly setup.
        // Special attributes are automatically applied by NSTableView/NSOutlineView for the source list
        SidebarTableCellView *result = [outlineView makeViewWithIdentifier: @"MainCell" owner: self];
        result.textField.stringValue = item;




        // Setup the icon based on our section
        id parent = [outlineView parentForItem: item];
        NSInteger index = [topLevelItems indexOfObject: parent];
        NSInteger iconOffset = index % 4;

        switch (iconOffset) {
            case 0: {
                result.imageView.image = [NSImage imageNamed: NSImageNameHomeTemplate];
                break;
            }
            case 1: {
                result.imageView.image = [NSImage imageNamed: NSImageNameHomeTemplate];
                break;
            }
            case 2: {
                result.imageView.image = [NSImage imageNamed: NSImageNameQuickLookTemplate];
                break;
            }
            case 3: {
                result.imageView.image = [NSImage imageNamed: NSImageNameSlideshowTemplate];
                break;
            }
        }

        if ([item isEqualToString: @"Hours"]) {
            result.imageView.image = [NSImage imageNamed: @"clock-icon.png"];
        } else if ([item isEqualToString: @"Inbox"]) {
            result.imageView.image = [NSImage imageNamed: @"inbox-icon.png"];
        } else if ([item isEqualToString: @"Projects"]) {
            result.imageView.image = [NSImage imageNamed: @"full-drawer-icon.png"];
        }

        BOOL hideUnreadIndicator = YES;
        // Setup the unread indicator to show in some cases. Layout is done in SidebarTableCellView's viewWillDraw
        if (index == 0) {
            // First row in the index
            hideUnreadIndicator = NO;
            [result.button setTitle: @"42"];
            [result.button sizeToFit];
            // Make it appear as a normal label and not a button
            [[result.button cell] setHighlightsBy: 0];
        } else if (index == 2) {
            // Example for a button
            hideUnreadIndicator = NO;
            result.button.target = self;
            result.button.action = @selector(handleRemoveProject:);
            [result.button setImage: [NSImage imageNamed: NSImageNameAddTemplate]];
            // Make it appear as a button
            [[result.button cell] setHighlightsBy: NSPushInCellMask | NSChangeBackgroundCellMask];
        }
        [result.button setHidden: hideUnreadIndicator];
        return result;
    }
}

@end