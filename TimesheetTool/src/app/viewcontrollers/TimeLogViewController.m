//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TimeLogViewController.h"
#import "Project.h"
#import "TimeEntry.h"
#import "NSDate+JMSimpleDate.h"
#import "NSDateFormatter+JMSimpleDate.h"
#import "SaveDataOperation.h"
#import "BasicView.h"


#define SELECT_PROJECT_KEY @"Select a project"


@implementation TimeLogViewController {
}


@synthesize validationLabel;


- (void) loadView {
    [super loadView];

    [validationLabel setHidden: YES];

    NSMenuItem *anItem = [[NSMenuItem alloc] init];
    anItem.title = SELECT_PROJECT_KEY;
    [projectsMenu addItem: anItem];

    for (Project *project in _model.projects) {

        NSInteger index = [_model.projects indexOfObject: project];
        NSLog(@"index = %li", index);
        NSMenuItem *item = [[NSMenuItem alloc] init];
        item.title = project.title;
        item.tag = index;
        [projectsMenu addItem: item];
    }

    anItem = [[NSMenuItem alloc] init];
    anItem.title = @"Add new project...";
    anItem.action = @selector(selectedAddNewProject:);
    anItem.target = self;
    [projectsMenu addItem: anItem];

    NSLog(@"_model.currentProject = %@", _model.currentProject);
    if (_model.currentProject != nil) {
        [self displayCurrentProject];
    } else {
        [self switchMode: firstContainer];
    }
}


- (void) updateTimer {

    if (_model.currentProject != nil) {

        TimeEntry *timeEntry = _model.currentProject.currentTimeEntry;
        NSDate *date = [NSDate date];


        //        NSString *string = [NSString stringWithFormat: @"%i:%i:%i", [date hoursAfterDate: timeEntry.timeStarted], [date minutesAfterDate: timeEntry.timeStarted], [date seconds]];



        NSInteger hoursValue = [date hoursAfterDate: timeEntry.timeStarted];
        NSString *hours = [NSString stringWithFormat: @"%i", hoursValue];
        if ([hours length] == 1) hours = [NSString stringWithFormat: @"0%@", hours];

        NSInteger minuteValue = [date minutesAfterDate: timeEntry.timeStarted] - (hoursValue * 60);
        NSString *minutes = [NSString stringWithFormat: @"%i", minuteValue];
        if ([minutes length] == 1) minutes = [NSString stringWithFormat: @"0%@", minutes];

        NSString *seconds = [NSString stringWithFormat: @"%i", [date secondsAfterDate: timeEntry.timeStarted]];
        if ([seconds length] == 1) seconds = [NSString stringWithFormat: @"0%@", seconds];

        NSString *string = [NSString stringWithFormat: @"%@:%@:%@", hours, minutes, seconds];

        [timeElapsed.cell setPlaceholderString: string];
        [self performSelector: @selector(updateTimer) withObject: nil afterDelay: 1.0];
    }
}


- (IBAction) selectedAddNewProject: (id) sender {
    [_model notifyDelegates: @selector(didSelectAddNewProject) object: nil];
}


- (IBAction) handleStartClicked: (id) sender {

    if (projectsMenu.highlightedItem.title == nil || [projectsMenu.highlightedItem.title isEqualToString: SELECT_PROJECT_KEY]) {
        [validationLabel setHidden: NO];
        return;
    }

    NSInteger index = [projectsMenu indexOfItem: projectsMenu.highlightedItem] - 1;

    NSLog(@"index = %li", index);
    _model.currentProject = [_model.projects objectAtIndex: index];
    [self addTimeEntry];

    [_queue addOperation: [[SaveDataOperation alloc] init]];
    [self displayCurrentProject];
}


- (void) addTimeEntry {

    Project *project = _model.currentProject;
    TimeEntry *timeEntry = [[TimeEntry alloc] initWithTimeStarted: [NSDate date] projectId: project.projectId];

    [project.timeEntries addObject: timeEntry];
    [_model notifyDelegates: @selector(timeEntryAdded:toProject:) object: timeEntry object: project];
}


- (IBAction) handleStopClicked: (id) sender {

    NSLog(@"%s", __PRETTY_FUNCTION__);

    Project *project = _model.currentProject;
    _model.currentProject.currentTimeEntry.timeEnded = [NSDate date];
    _model.currentProject = nil;
    [_queue addOperation: [[SaveDataOperation alloc] init]];

    [self switchMode: firstContainer];

    [_model notifyDelegates: @selector(timeEntriesChangedForProject:) object: project];
    [_model notifyDelegates: @selector(timeEntryCompleted:) object: project.currentTimeEntry];
}


- (void) switchMode: (NSView *) container {

    if (container == firstContainer) {
        if ([secondContainer superview]) [secondContainer removeFromSuperview];
        //        self.view.frame = firstContainer.frame;
        [firstContainer setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
        [self.view addSubview: firstContainer];
    } else if (container == secondContainer) {
        if ([firstContainer superview]) [firstContainer removeFromSuperview];
        //        self.view.frame = secondContainer.frame;
        [secondContainer setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
        [self.view addSubview: secondContainer];
    }

    [_model notifyDelegates: @selector(timeLogSwitchedMode) object: nil];
}


- (void) displayCurrentProject {

    [self switchMode: secondContainer];
    Project *project = _model.currentProject;
    NSString *string = [self stringFromTimeEntry: project.currentTimeEntry];
    [timeStartedLabel.cell setPlaceholderString: string];
    currentProjectLabel.stringValue = project.title;
    [self performSelector: @selector(updateTimer) withObject: nil afterDelay: 1.0];
}


- (NSString *) stringFromTimeEntry: (TimeEntry *) timeEntry {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    [formatter setDateFormat: @"h:mm a"];

    NSDate *date = timeEntry.timeStarted;
    NSString *string = [NSDateFormatter formattedStringTimeElapsedFromDate: date];

    if (date.isToday) {
        string = [NSString stringWithFormat: @"Today, %@", [formatter stringFromDate: date]];
    } else if (date.isYesterday) {
        string = [NSString stringWithFormat: @"Yesterday, %@", [formatter stringFromDate: date]];
    } else {
        string = [NSDateFormatter formattedStringTimeElapsedFromDate: date];
    }

    NSLog(@"string = %@", string);
    return string;
}

@end