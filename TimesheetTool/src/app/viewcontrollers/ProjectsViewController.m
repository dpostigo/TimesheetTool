//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ProjectsViewController.h"
#import "Project.h"
#import "SaveDataOperation.h"


#define RECENT_KEY @"Recent"


@implementation ProjectsViewController {
}


@synthesize projectNameField;


- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.title = @"Projects";
    }

    return self;
}


- (void) loadView {
    [super loadView];

    if ([_model.projects count] > 0) {

        [outlineView.childrenDictionary setObject: _model.projectTitles forKey: RECENT_KEY];
    } else {

        outlineView.topLevelItems = [NSArray array];
    }

    [outlineView reloadData];
}


- (IBAction) handleAddProject: (id) sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSString *projectName = projectNameField.stringValue;
    NSArray *projectTitles = [[NSArray alloc] initWithArray: _model.projectTitles];

    if ([projectTitles containsObject: projectName]) {
        NSLog(@"Already exists.");
        [validationLabel setHidden: NO];

        return;
    }

    [validationLabel setHidden: YES];

    Project *project = [[Project alloc] initWithTitle: projectNameField.stringValue];
    [_model.projects addObject: project];

    [self refreshOutlineView];

}


- (void) refreshOutlineView {

    [outlineView.childrenDictionary setObject: _model.projectTitles forKey: RECENT_KEY];
    [outlineView reloadData];
    [_queue addOperation: [[SaveDataOperation alloc] init]];

}

- (void) shouldRemoveProjectWithIndex: (NSNumber *) number {
    NSInteger index = [number integerValue];

    [_model.projects removeObjectAtIndex: index];

    [self refreshOutlineView];
}

@end