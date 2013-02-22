//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"
#import "BasicView.h"


@interface TimeLogViewController : BasicViewController {


    IBOutlet NSView *firstContainer;
    IBOutlet NSView *secondContainer;
    IBOutlet BasicView *debugView;


    IBOutlet NSPopUpButton *projectsPopup;
    IBOutlet NSMenu *projectsMenu;

    IBOutlet NSTextField *timeStartedLabel;
    IBOutlet NSTextField *validationLabel;
    IBOutlet NSTextField *timeElapsed;

    IBOutlet NSTextField *currentProjectLabel;


}


@property(nonatomic, strong) NSTextField *validationLabel;
- (IBAction) selectedAddNewProject: (id) sender;
- (IBAction) handleStartClicked: (id) sender;
- (IBAction) handleStopClicked: (id) sender;

@end