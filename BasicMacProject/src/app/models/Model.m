//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Model.h"
#import "Project.h"
#import "TimeEntry.h"


@implementation Model {
}


@synthesize projects;
@synthesize currentProject;


+ (Model *) sharedModel {
    static Model *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}


- (id) init {
    self = [super init];
    if (self) {

        NSArray *array = nil;
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey: @"projects"];
        if (data != nil) array = [NSKeyedUnarchiver unarchiveObjectWithData: data];

        if (array != nil) {
            self.projects = [[NSMutableArray alloc] initWithArray: array];
        } else {

            self.projects = [[NSMutableArray alloc] init];

            //            self.projects = [[NSMutableArray alloc] initWithObjects: [[Project alloc] initWithTitle: @"Mapping Plate Action"], nil];
        }

        NSString *currentProjectId = [[NSUserDefaults standardUserDefaults] objectForKey: @"currentProjectId"];

        if (currentProjectId) {
            @try {
                self.currentProject = [self projectFromId: currentProjectId];
            } @catch (NSException *exception) {
                NSLog(@"Couldn't get current project.");
            }
        }

        [self populateProjectIds];
    }

    return self;
}


- (NSArray *) projectTitles {

    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (Project *project in self.projects) {
        [titles addObject: project.title];
    }
    return titles;
}


- (NSInteger) currentProjectIndex {
    if (self.currentProject == nil) return NULL;
    return [self.projects indexOfObject: self.currentProject];
}


- (NSString *) currentProjectId {
    if (self.currentProject == nil) return nil;
    return self.currentProject.projectId;
}


- (NSArray *) recentTimeEntries: (NSInteger) length {

    NSMutableArray *completedTimeEntries = [[NSMutableArray alloc] init];
    NSMutableArray *uncompletedTimeEntries = [[NSMutableArray alloc] init];
    for (Project *project in self.projects) {

        for (TimeEntry *timeEntry in project.timeEntries) {
            if (timeEntry.timeEnded == nil) {
                [uncompletedTimeEntries addObject: timeEntry];
            } else {
                [completedTimeEntries addObject: timeEntry];
            }
        }
    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey: @"timeEnded" ascending: NO];
    [completedTimeEntries sortUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];

    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey: @"timeStarted" ascending: NO];
    [uncompletedTimeEntries sortUsingDescriptors: [NSArray arrayWithObject: sortDescriptor2]];

    //    NSArray *timeEntries = [NSArray arrayWithObjects: uncompletedTimeEntries, completedTimeEntries, nil];
    NSMutableArray *timeEntries = [[NSMutableArray alloc] init];
    [timeEntries addObjectsFromArray: uncompletedTimeEntries];
    [timeEntries addObjectsFromArray: completedTimeEntries];


    NSInteger arrayLength = [timeEntries count];
    if (arrayLength > length) {
        [timeEntries removeObjectsInRange: NSMakeRange(length, arrayLength - length)];
    }

    return timeEntries;
}


- (void) populateProjectIds {
    for (Project *project in self.projects) {
        if (project.projectId == nil) {
            project.projectId = [NSString stringWithFormat: @"%lu", [self.projects indexOfObject: project]];
        }

        for (TimeEntry *timeEntry in project.timeEntries) {
            timeEntry.projectId = project.projectId;
        }
    }
}


- (Project *) projectFromId: (NSString *) projectId {
    for (Project *project in self.projects) {
        if ([project.projectId isEqualToString: projectId]) {
            return project;
        }
    }
    return nil;
}

@end