//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "BasicOutlineView.h"


@interface ProjectsViewController : BasicViewController {

    IBOutlet NSTextField *emptyLabel;
    IBOutlet NSTextField *projectNameField;
    IBOutlet BasicOutlineView *outlineView;

    IBOutlet NSTextField *validationLabel;
}


@property(nonatomic, strong) NSTextField *projectNameField;
- (IBAction) handleAddProject: (id) sender;

@end