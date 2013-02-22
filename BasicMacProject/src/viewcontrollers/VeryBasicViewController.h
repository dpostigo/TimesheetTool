//
// Created by dpostigo on 2/17/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Model.h"


@interface VeryBasicViewController : NSViewController {

    __unsafe_unretained Model *_model;
    NSOperationQueue *_queue;
}


- (void) replaceViewControllerView: (NSViewController *) viewController asView: (NSView *) aSuperview;
- (void) replaceView: (NSView *) newView asView: (NSView *) oldView;
- (void) addExternalView: (NSViewController *) viewController toView: (NSView *) aSuperview;

@end