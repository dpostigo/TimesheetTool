//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "VeryBasicViewController.h"


@implementation VeryBasicViewController {
}


- (void) loadView {
    [super loadView];

    if (_queue == nil) {
        _queue = [NSOperationQueue new];
    }

    _model = [Model sharedModel];
    [_model subscribeDelegate: self];
}


- (void) replaceViewControllerView: (NSViewController *) viewController asView: (NSView *) aSuperview; {

    viewController.view.frame = aSuperview.bounds;
    [viewController.view setAutoresizingMask: aSuperview.autoresizingMask];

    if ([aSuperview superview]) [aSuperview removeFromSuperview];
    [self.view addSubview: viewController.view];
}


- (void) replaceView: (NSView *) newView asView: (NSView *) oldView; {

    newView.frame = oldView.frame;
    newView.autoresizingMask = oldView.autoresizingMask;


    if ([oldView superview]) {

        NSView *superView = [oldView superview];

        NSLog(@"superView = %@", superView);
        [oldView removeFromSuperview];
        [superView addSubview: newView];
    }
}


- (void) addExternalView: (NSViewController *) viewController toView: (NSView *) aSuperview {

    viewController.view.frame = aSuperview.bounds;
    [viewController.view setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
    [aSuperview addSubview: viewController.view];
}

@end