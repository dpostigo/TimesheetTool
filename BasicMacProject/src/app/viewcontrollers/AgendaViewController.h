//
// Created by dpostigo on 2/20/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"


@interface AgendaViewController : BasicViewController {

    IBOutlet NSTableView *table;
}


@property(nonatomic, strong) NSTableView *table;

@end