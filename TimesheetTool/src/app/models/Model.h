//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicModel.h"
#import "Project.h"


@interface Model : BasicModel {

    NSMutableArray *projects;
    __unsafe_unretained Project *currentProject;
}


@property(nonatomic, strong) NSMutableArray *projects;
@property(nonatomic, assign) Project *currentProject;
+ (Model *) sharedModel;
- (NSArray *) projectTitles;
- (NSInteger) currentProjectIndex;
- (NSString *) currentProjectId;
- (NSArray *) recentTimeEntries: (NSInteger) length;
- (void) populateProjectIds;
- (Project *) projectFromId: (NSString *) projectId;

@end