//
// Created by dpostigo on 2/18/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SaveDataOperation.h"


@implementation SaveDataOperation {
}


- (void) main {
    [super main];

    [_model populateProjectIds];

    NSLog(@"_model.currentProjectIndex = %li", _model.currentProjectIndex);
    [[NSUserDefaults standardUserDefaults] setObject: [NSKeyedArchiver archivedDataWithRootObject: _model.projects] forKey: @"projects"];
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInteger: _model.currentProjectIndex] forKey: @"currentProjectIndex"];
    [[NSUserDefaults standardUserDefaults] setObject: _model.currentProjectId forKey: @"currentProjectId"];
}

@end